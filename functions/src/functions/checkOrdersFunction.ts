import { logger } from "firebase-functions";
import { onSchedule } from "firebase-functions/v2/scheduler";
import { Timestamp } from "firebase-admin/firestore";
import {
  getTodaysDeliveries,
  updateDeliveryState,
  updateDeliveryWithOrderCreationTime,
  getTodaysBoxDeliveries,
  updateBoxDelivery,
} from "../services/deliveryService";
import { getEntities, getEntityPairs } from "../services/entityService";
import { getDodoToken, createDodoOrder } from "../services/dodoService";
import { Delivery, DodoToken, DodoOrder, Entity, EntityPair } from "../models";
import {
  getMinutesBeforePickup,
  getDateInFuture,
  formatCzechDate,
} from "../utils/dateUtils";
import { updateNoteWithPhoneNumbers } from "../utils/noteUtils";

/**
 * Get the number of minutes before pickup that confirmation is required.
 * Uses custom confirmationTime if set, otherwise defaults based on carrier.
 * @param {Delivery} delivery - The delivery document
 * @return {number} Minutes before pickup for confirmation deadline
 */
function getMinutesConfirmedBeforePickup(delivery: Delivery): number {
  // Use custom confirmationTime if set
  if (delivery.confirmationTime !== undefined) {
    return delivery.confirmationTime;
  }

  // Default based on carrier type
  if (delivery.carrierId === "dodo") {
    return 45; // 45 minutes for DODO carrier
  } else {
    return 20; // 20 minutes for personal carrier
  }
}

/**
 * Check if confirmation deadline has passed for a delivery.
 * @param {Delivery} delivery - The delivery document
 * @return {boolean} True if deadline has passed
 */
function hasConfirmationDeadlinePassed(delivery: Delivery): boolean {
  const minutesBeforePickup = getMinutesConfirmedBeforePickup(delivery);
  const minutesUntilPickup = getMinutesBeforePickup(
    delivery.pickupTimeWindow.start.toDate(),
  );

  return minutesUntilPickup < minutesBeforePickup;
}

/**
 * Get delivery participants (donor and recipient entities).
 * @param {Delivery} delivery - The delivery document
 * @param {EntityPair[]} entityPairs - All entity pairs
 * @param {Entity[]} entities - All entities
 * @param {number} handledOrdersCount - Counter for logging
 * @return {{entityPair: EntityPair, donor: Entity, recipient: Entity} | undefined}
 */
function getDeliveryParticipants(
  delivery: Delivery,
  entityPairs: EntityPair[],
  entities: Entity[],
  handledOrdersCount: number,
): { entityPair: EntityPair; donor: Entity; recipient: Entity } | undefined {
  const entityPair = entityPairs.find(
    (pair) =>
      pair.donorId === delivery.donorId &&
      pair.recipientId === delivery.recipientId,
  );

  if (!entityPair) {
    logger.warn(
      `|${handledOrdersCount}| Entity pair for delivery FBID: ${delivery.ref.id} not found`,
    );
    return undefined;
  }

  const donor = entities.find((entity) => entity.id === entityPair.donorId);
  const recipient = entities.find(
    (entity) => entity.id === entityPair.recipientId,
  );

  if (!donor || !recipient) {
    logger.warn(
      `|${handledOrdersCount}| Donor or recipient for delivery FBID: ${delivery.ref.id} not found`,
    );
    return undefined;
  }

  return { entityPair, donor, recipient };
}

/**
 * Create a DODO order object from delivery and entity data.
 * @param {EntityPair} entityPair - The entity pair
 * @param {Entity} donor - The donor entity
 * @param {Entity} recipient - The recipient entity
 * @param {Delivery} delivery - The delivery document
 * @return {DodoOrder}
 */
function createDodoOrderFromDelivery(
  entityPair: EntityPair,
  donor: Entity,
  recipient: Entity,
  delivery: Delivery,
): DodoOrder {
  return {
    id: delivery.deliveryIdentifier,
    pickupDodoId: entityPair.carrierDonorId,
    pickupId: donor.establishmentId,
    pickupFrom: delivery.pickupTimeWindow.start.toDate(),
    pickupTo: delivery.pickupTimeWindow.end.toDate(),
    pickupNote: updateNoteWithPhoneNumbers(
      donor.noteForDriver || "",
      donor.phone,
      recipient.phone,
    ),
    deliverId: recipient.establishmentId,
    deliverAddress: `${recipient.street} ${recipient.houseNumber} ${recipient.city} ${recipient.postalCode}`,
    deliverFrom: delivery.deliveryTimeWindow.start.toDate(),
    deliverTo: delivery.deliveryTimeWindow.end.toDate(),
    deliverNote: updateNoteWithPhoneNumbers(
      recipient.noteForDriver || "",
      donor.phone,
      recipient.phone,
    ),
    customerName: recipient.responsiblePerson,
    customerPhone: recipient.phone,
  };
}

/**
 * Handle PREPARED deliveries - mark as NOT_USED if deadline passed.
 * @param {Delivery} delivery - The delivery in PREPARED state
 * @param {number} handledOrdersCount - Counter for logging correlation
 * @return {Promise<void>}
 */
async function handlePreparedDelivery(
  delivery: Delivery,
  handledOrdersCount: number,
): Promise<void> {
  const minutesBeforePickup = getMinutesConfirmedBeforePickup(delivery);

  if (hasConfirmationDeadlinePassed(delivery)) {
    const latestConfirmationDate = new Date(
      delivery.pickupTimeWindow.start.toDate().getTime() -
        minutesBeforePickup * 60000,
    );

    logger.warn(
      `|${handledOrdersCount}| Delivery ${
        delivery.deliveryIdentifier
      } NOT USED. Latest time for confirmation ${latestConfirmationDate.toLocaleString(
        "cs",
      )} passed.`,
    );

    await updateDeliveryState(delivery.ref, "NOT_USED");
  } else {
    logger.info(
      `|${handledOrdersCount}| Delivery ${delivery.deliveryIdentifier} can still be requested.`,
    );
  }
}

/**
 * Handle OFFERED/ACCEPTED deliveries - create DODO order if needed.
 * @param {Delivery} delivery - The delivery in OFFERED/ACCEPTED state
 * @param {number} handledOrdersCount - Counter for logging
 * @param {DodoToken} dodoToken - OAuth2 token for DODO API
 * @param {EntityPair[]} entityPairs - All entity pairs
 * @param {Entity[]} entities - All entities
 * @return {Promise<void>}
 */
async function handleOfferedOrAcceptedDelivery(
  delivery: Delivery,
  handledOrdersCount: number,
  dodoToken: DodoToken,
  entityPairs: EntityPair[],
  entities: Entity[],
): Promise<void> {
  const minutesBeforePickup = getMinutesConfirmedBeforePickup(delivery);

  // Add 30-minute buffer for DODO carrier to account for cron timing
  let correctedLatestConfirmationDate = new Date(
    delivery.pickupTimeWindow.start.toDate().getTime() -
      minutesBeforePickup * 60000,
  );

  if (delivery.carrierId === "dodo") {
    correctedLatestConfirmationDate = new Date(
      correctedLatestConfirmationDate.getTime() + 30 * 60000,
    );
  }

  // Before deadline - create order if needed
  if (new Date() < correctedLatestConfirmationDate) {
    if (delivery.carrierOrder?.createdAt) {
      logger.info(
        `|${handledOrdersCount}| Delivery ${delivery.deliveryIdentifier} already ordered.`,
      );
      return;
    }

    // Skip if not using DODO carrier
    if (delivery.carrierId !== "dodo") {
      logger.debug(
        `|${handledOrdersCount}| Carrier is ${delivery.carrierId}, won't create order`,
      );
      return;
    }

    logger.info(
      `|${handledOrdersCount}| Ordering delivery for ${delivery.deliveryIdentifier}.`,
    );

    const participants = getDeliveryParticipants(
      delivery,
      entityPairs,
      entities,
      handledOrdersCount,
    );

    if (!participants) {
      return;
    }

    const order = createDodoOrderFromDelivery(
      participants.entityPair,
      participants.donor,
      participants.recipient,
      delivery,
    );

    const orderCreated = await createDodoOrder(order, dodoToken);

    if (orderCreated) {
      await updateDeliveryWithOrderCreationTime(delivery.ref, {
        createdAt: Timestamp.now(),
      });
      logger.info(
        `|${handledOrdersCount}| Successfully created order ${delivery.deliveryIdentifier}`,
      );
    } else {
      logger.error(
        `|${handledOrdersCount}| Failed to create DODO order ${delivery.deliveryIdentifier}`,
      );
    }
  } else {
    // After deadline - check if order was created
    if (delivery.carrierOrder?.createdAt) {
      const pickupTo = delivery.pickupTimeWindow.end.toDate();

      if (new Date() > pickupTo) {
        logger.info(
          `|${handledOrdersCount}| Moving delivery ${delivery.deliveryIdentifier} to IN_DELIVERY state.`,
        );
        await updateDeliveryState(delivery.ref, "IN_DELIVERY");
      } else {
        logger.info(
          `|${handledOrdersCount}| Delivery ${delivery.deliveryIdentifier} is not ready for pickup yet.`,
        );
      }
    } else {
      logger.error(
        `|${handledOrdersCount}| Delivery for ${
          delivery.deliveryIdentifier
        } can't be ordered. Latest time for confirmation ${correctedLatestConfirmationDate.toLocaleString(
          "cs",
        )} passed.`,
      );
    }
  }
}

/**
 * Process box return deliveries - creates reverse DODO orders.
 * @param {DodoToken} dodoToken - OAuth2 token for DODO API
 * @param {EntityPair[]} entityPairs - All entity pairs
 * @param {Entity[]} entities - All entities
 * @return {Promise<void>}
 */
async function checkBoxReturnDeliveries(
  dodoToken: DodoToken,
  entityPairs: EntityPair[],
  entities: Entity[],
): Promise<void> {
  logger.info("Loading box deliveries from deliveries collection");
  const boxDeliveries = await getTodaysBoxDeliveries();
  logger.info(
    `Found ${boxDeliveries.length} box deliveries in deliveries collection`,
  );

  if (boxDeliveries.length === 0) {
    logger.info("No box deliveries found for today");
    return;
  }

  let loggerDeliveryNumber = -1;

  for (const delivery of boxDeliveries) {
    loggerDeliveryNumber++;
    logger.info(
      `|${loggerDeliveryNumber}| -> Handling box delivery FBID: ${delivery.ref.id}`,
    );

    if (delivery.state !== "OFFERED") {
      logger.info(
        `|${loggerDeliveryNumber}| -> Box delivery FBID: ${delivery.ref.id} is not in state OFFERED`,
      );
      continue;
    }

    const participants = getDeliveryParticipants(
      delivery,
      entityPairs,
      entities,
      loggerDeliveryNumber,
    );

    if (!participants) {
      continue;
    }

    const { entityPair, donor, recipient } = participants;

    // Create delivery for tomorrow (1 day in future)
    const deliveryDate = getDateInFuture(1);
    const deliveryIdentifier = `${recipient.establishmentId}-${
      donor.establishmentId
    }-${formatCzechDate(deliveryDate)}`
      .toLowerCase()
      .replace(/ /g, "");

    // Fixed time windows for box returns
    const pickupTimeWindow = {
      start: Timestamp.fromDate(getDateInFuture(1, "10:00")),
      end: Timestamp.fromDate(getDateInFuture(1, "10:30")),
    };

    const deliveryTimeWindow = {
      start: Timestamp.fromDate(getDateInFuture(1, "11:00")),
      end: Timestamp.fromDate(getDateInFuture(1, "11:30")),
    };

    // Create reverse order: pickup from recipient, delivery to donor
    const order: DodoOrder = {
      id: deliveryIdentifier,
      pickupDodoId: entityPair.carrierRecipientId,
      pickupId: recipient.establishmentId,
      pickupFrom: pickupTimeWindow.start.toDate(),
      pickupTo: pickupTimeWindow.end.toDate(),
      pickupNote:
        "Vyzvednutí obalů\n" +
        updateNoteWithPhoneNumbers(
          recipient.noteForDriver || "",
          recipient.phone,
          donor.phone,
        ),
      deliverId: donor.establishmentId,
      deliverAddress: `${donor.street} ${donor.houseNumber} ${donor.city} ${donor.postalCode}`,
      deliverFrom: deliveryTimeWindow.start.toDate(),
      deliverTo: deliveryTimeWindow.end.toDate(),
      deliverNote:
        "Doručení obalů\n" +
        updateNoteWithPhoneNumbers(
          donor.noteForDriver || "",
          recipient.phone,
          donor.phone,
        ),
      customerName: donor.responsiblePerson,
      customerPhone: donor.phone,
    };

    const orderCreated = await createDodoOrder(order, dodoToken);

    if (orderCreated) {
      logger.debug(`|${loggerDeliveryNumber}| -> Order created successfully`);

      logger.info(
        `|${loggerDeliveryNumber}| ->  Box delivery in state OFFERED - moving to IN_DELIVERY state`,
      );

      await updateBoxDelivery(
        delivery.ref,
        "IN_DELIVERY",
        deliveryIdentifier,
        deliveryDate,
        pickupTimeWindow,
        deliveryTimeWindow,
        entityPair.boxReturnCarrierId,
      );

      logger.info(
        `|${loggerDeliveryNumber}| -> Successfully moved box delivery ${delivery.deliveryIdentifier} to IN_DELIVERY state`,
      );
    } else {
      logger.error(`|${loggerDeliveryNumber}| -> Failed to create order`);
    }
  }
}

/**
 * Core logic for checking orders - processes today's deliveries.
 * @return {Promise<void>}
 */
export async function checkOrders(): Promise<void> {
  let dodoToken: DodoToken | null = null;
  let entityPairs: EntityPair[] = [];
  let entities: Entity[] = [];

  try {
    logger.info("Starting checkOrders function");

    // Get DODO OAuth token
    dodoToken = await getDodoToken();

    // Load entities and entity pairs (cached after first call)
    entityPairs = await getEntityPairs();
    entities = await getEntities();

    // Get today's deliveries in states that need processing
    const deliveries = await getTodaysDeliveries([
      "PREPARED",
      "OFFERED",
      "ACCEPTED",
    ]);
    logger.info(
      `Found ${deliveries.length} deliveries in PREPARED/OFFERED/ACCEPTED states`,
    );

    let handledOrdersCount = 0;

    // Process each delivery
    for (const delivery of deliveries) {
      try {
        logger.info(
          `|${handledOrdersCount}| Handling delivery ${delivery.deliveryIdentifier}/FBID: ${delivery.ref.id}`,
        );

        if (
          !delivery.pickupTimeWindow.start ||
          !delivery.pickupTimeWindow.end
        ) {
          logger.error(
            `|${handledOrdersCount}| Pickup time window is not defined for delivery ${delivery.deliveryIdentifier}`,
          );
          handledOrdersCount++;
          continue;
        }

        const minutesBeforePickup = getMinutesConfirmedBeforePickup(delivery);
        logger.info(
          `|${handledOrdersCount}| Minutes before pickup: ${minutesBeforePickup}`,
        );

        // Handle based on current state
        if (delivery.state === "PREPARED") {
          await handlePreparedDelivery(delivery, handledOrdersCount);
        } else if (
          delivery.state === "OFFERED" ||
          delivery.state === "ACCEPTED"
        ) {
          await handleOfferedOrAcceptedDelivery(
            delivery,
            handledOrdersCount,
            dodoToken,
            entityPairs,
            entities,
          );
        }
      } catch (error) {
        logger.error(
          `|${handledOrdersCount}| Failed to process delivery ${delivery.deliveryIdentifier}:`,
          error,
        );
      }

      handledOrdersCount++;
    }

    logger.info(
      `Script finished, ${handledOrdersCount} orders(s) have been handled`,
    );
  } catch (error) {
    logger.error("Food deliveries processing failed:", error);
  }

  // Always process box return deliveries, even if food delivery processing failed
  try {
    if (dodoToken && entityPairs.length > 0 && entities.length > 0) {
      await checkBoxReturnDeliveries(dodoToken, entityPairs, entities);
    } else {
      logger.warn(
        "Skipping box return deliveries check due to missing prerequisites",
      );
    }
  } catch (error) {
    logger.error("Box deliveries processing failed:", error);
  }
}

/**
 * Scheduled function that runs every 7-8 minutes during business hours on weekdays.
 * Alternating intervals: 0,7,15,22,30,37,45,52 minutes (7-8 min gaps).
 */
export const checkOrdersFunction = onSchedule(
  {
    schedule: "0,7,15,22,30,37,45,52 9-17 * * 1-5",
    timeZone: "Europe/Prague",
  },
  async () => {
    await checkOrders();
  },
);
