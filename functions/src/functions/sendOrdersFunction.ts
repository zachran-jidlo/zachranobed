import { onSchedule } from "firebase-functions/v2/scheduler";
import { getEntities, getEntityPairs, clearEntityCache } from "../services/entityService";
import { createDeliveryDocument } from "../services/deliveryService";
import { scheduleMultipleTransitions, scheduleConfirmationReminder, ScheduleTransitionParams } from "../services/cloudTaskService";
import {
  getNextBusinessDay,
  createDateWithTime,
  formatCzechDate,
} from "../utils/dateUtils";
import { getConfirmationMinutes } from "../utils/deliveryUtils";
import { logger } from "firebase-functions";
import { TIMEZONE, CONFIRMATION_REMINDER_MINUTES } from "../config/constants";

/**
 * Core logic for sending orders - creates delivery documents for tomorrow.
 * @param {Date} deliveryDate - Optional custom delivery date. If not provided, uses tomorrow.
 * @return {Promise<void>}
 */
export async function sendOrders(deliveryDate?: Date): Promise<void> {
  try {
    logger.info("Starting sendOrders function");

    // Load entity pairs and entities
    const entityPairs = await getEntityPairs();
    logger.info(`Loaded ${entityPairs.length} active entity pairs`);

    const entities = await getEntities();
    logger.info(`Loaded ${entities.length} entities`);

    // Get tomorrow's date (or Monday if tomorrow is weekend) if not provided
    if (!deliveryDate) {
      deliveryDate = getNextBusinessDay(1);
    }
    logger.info(`Creating deliveries for date: ${deliveryDate.toISOString()}`);

    let createdCount = 0;
    let errorCount = 0;
    let handledDeliveriesCount = 0;

    // Create delivery for each active pair
    for (const pair of entityPairs) {
      try {
        const donor = entities.find((e) => e.id === pair.donorId);
        const recipient = entities.find((e) => e.id === pair.recipientId);

        logger.debug(
          `|${handledDeliveriesCount}| Processing pair: donorId=${pair.donorId}, recipientId=${pair.recipientId}`,
        );

        if (!donor || !recipient) {
          logger.error(
            `Missing entity for pair: donorId=${pair.donorId}, recipientId=${pair.recipientId}`,
          );
          errorCount++;
          continue;
        }

        logger.debug(
          `|${handledDeliveriesCount}| -> Donor: ${donor?.establishmentName}/FBID(${donor?.ref.id})`,
        );
        logger.debug(
          `|${handledDeliveriesCount}| -> Recipient: ${recipient?.establishmentName}/FBID(${recipient?.ref.id})`,
        );

        // Generate delivery identifier
        const dateStr = formatCzechDate(deliveryDate);
        const deliveryIdentifier = `${donor.establishmentId}-${recipient.establishmentId}-${dateStr}`;

        // Get time windows from pair configuration
        const pickupWindow = pair.pickupTimeWindows[0];
        const deliveryWindow = pair.deliveryTimeWindows[0];

        if (!pickupWindow || !deliveryWindow) {
          logger.error(
            `Missing time windows for pair: ${donor.establishmentId}-${recipient.establishmentId}`,
          );
          errorCount++;
          continue;
        }

        // Create pickup and delivery time windows for the delivery date
        const pickupTimeWindow = {
          start: createDateWithTime(deliveryDate, pickupWindow.start),
          end: createDateWithTime(deliveryDate, pickupWindow.end),
        };

        const deliveryTimeWindow = {
          start: createDateWithTime(deliveryDate, deliveryWindow.start),
          end: createDateWithTime(deliveryDate, deliveryWindow.end),
        };

        // Create delivery document
        await createDeliveryDocument({
          carrierId: pair.carrierId,
          donorId: pair.donorId,
          recipientId: pair.recipientId,
          deliveryDate,
          deliveryIdentifier,
          pickupTimeWindow,
          deliveryTimeWindow,
          confirmationTime: pair.confirmationTime,
        });

        // Schedule Cloud Tasks for state transitions
        const confirmationMinutes = getConfirmationMinutes({
          carrierId: pair.carrierId,
          confirmationTime: pair.confirmationTime,
        });

        const notUsedAt = new Date(
          pickupTimeWindow.start.getTime() - confirmationMinutes * 60 * 1000,
        );

        const tasks: ScheduleTransitionParams[] = [
          {
            deliveryId: deliveryIdentifier,
            targetState: "NOT_USED",
            preconditionState: "PREPARED",
            executeAt: notUsedAt,
          },
        ];

        // For personal carrier: schedule all state transitions
        if (pair.carrierId === "personal") {
          tasks.push(
            {
              deliveryId: deliveryIdentifier,
              targetState: "ON_WAY_TO_PICK_UP",
              preconditionState: "ACCEPTED",
              executeAt: pickupTimeWindow.start,
            },
            {
              deliveryId: deliveryIdentifier,
              targetState: "IN_DELIVERY",
              preconditionState: "ON_WAY_TO_PICK_UP",
              executeAt: pickupTimeWindow.end,
            },
            {
              deliveryId: deliveryIdentifier,
              targetState: "DELIVERED",
              preconditionState: "IN_DELIVERY",
              executeAt: deliveryTimeWindow.end,
            },
          );
        }

        await scheduleMultipleTransitions(tasks);

        // Schedule confirmation reminder few minutes before the deadline
        const reminderAt = new Date(
          notUsedAt.getTime() - CONFIRMATION_REMINDER_MINUTES * 60 * 1000,
        );
        await scheduleConfirmationReminder(deliveryIdentifier, reminderAt);

        createdCount++;
        logger.debug(`Created delivery and scheduled Cloud Tasks: ${deliveryIdentifier}`);
      } catch (error) {
        logger.error(
          `Failed to create delivery for pair ${pair.donorId}-${pair.recipientId}:`,
          error,
        );
        errorCount++;
      }
      handledDeliveriesCount++;
    }

    logger.info(
      `sendOrders completed: ${createdCount} deliveries created, ${errorCount} errors`,
    );
  } catch (error) {
    logger.error("sendOrders failed:", error);
    throw error;
  } finally {
    // Clear cache to ensure fresh data on next invocation
    clearEntityCache();
  }
}

/**
 * Scheduled function that runs daily at 4:00 PM Prague time on weekdays.
 */
export const sendOrdersFunction = onSchedule(
  {
    schedule: "0 16 * * 1-5",
    timeZone: TIMEZONE,
  },
  async () => {
    await sendOrders();
  },
);
