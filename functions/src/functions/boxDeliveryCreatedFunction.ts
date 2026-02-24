import { onDocumentCreated } from "firebase-functions/v2/firestore";
import { logger } from "firebase-functions/v2";
import { Timestamp } from "firebase-admin/firestore";
import { DeliverySchema } from "../models";
import { getEntityPairs, getEntities, clearEntityCache } from "../services/entityService";
import {
  initializeBoxDelivery,
  updateDeliveryState,
  updateDeliveryWithOrderCreationTime,
} from "../services/deliveryService";
import { getDodoToken, createDodoOrder, createBoxReturnOrder } from "../services/dodoService";
import { scheduleMultipleTransitions, ScheduleTransitionParams } from "../services/cloudTaskService";
import { getDateInFuture, formatCzechDate } from "../utils/dateUtils";
import { BOX_RETURN_SCHEDULE } from "../config/constants";
import {
  dodoClientId,
  dodoClientSecret,
  dodoOauthUri,
  dodoScope,
  dodoOrdersApi,
} from "../config/firebase";

/**
 * Firestore onCreate trigger for new box delivery documents.
 * Mirrors the old checkOrdersFunction.processBoxDelivery logic but transitions to ACCEPTED
 * instead of IN_DELIVERY, letting Cloud Tasks drive the remaining state transitions.
 */
export const boxDeliveryCreated = onDocumentCreated(
  {
    document: "deliveries/{id}",
    secrets: [dodoClientId, dodoClientSecret, dodoOauthUri, dodoScope, dodoOrdersApi],
  },
  async (event) => {
    const snap = event.data;
    if (!snap) return;

    const docRef = snap.ref;
    const result = DeliverySchema.safeParse({ ref: docRef, ...snap.data() });

    if (!result.success) {
      logger.warn(`boxDeliveryCreated: invalid delivery document ${snap.id}`, result.error);
      return;
    }

    const delivery = result.data;

    // Only process box deliveries
    if (delivery.type !== "BOX_DELIVERY") {
      return;
    }

    // Time windows, date and identifier are not set by the mobile app —
    // derived from predefined constants (same as old checkOrdersFunction logic).
    const deliveryDate = getDateInFuture(1);
    const pickupStart = getDateInFuture(1, BOX_RETURN_SCHEDULE.PICKUP.start);
    const pickupEnd = getDateInFuture(1, BOX_RETURN_SCHEDULE.PICKUP.end);
    const deliveryStart = getDateInFuture(1, BOX_RETURN_SCHEDULE.DELIVERY.start);
    const deliveryEnd = getDateInFuture(1, BOX_RETURN_SCHEDULE.DELIVERY.end);

    try {
      const [entityPairs, entities] = await Promise.all([
        getEntityPairs(),
        getEntities(),
      ]);

      const entityPair = entityPairs.find(
        (pair) =>
          pair.donorId === delivery.donorId &&
          pair.recipientId === delivery.recipientId,
      );

      if (!entityPair) {
        logger.error(
          `boxDeliveryCreated: no entity pair found for donor=${delivery.donorId} recipient=${delivery.recipientId}`,
        );
        return;
      }

      const donor = entities.find((e) => e.id === entityPair.donorId);
      const recipient = entities.find((e) => e.id === entityPair.recipientId);

      if (!donor || !recipient) {
        logger.error(
          `boxDeliveryCreated: donor or recipient entity not found for pair donor=${delivery.donorId} recipient=${delivery.recipientId}`,
        );
        return;
      }

      const carrierId = entityPair.boxReturnCarrierId;

      if (carrierId === "disabled") {
        logger.info(`boxDeliveryCreated: box return carrier disabled for pair, skipping ${snap.id}`);
        return;
      }

      // Mirror the identifier format from checkOrdersFunction.processBoxDelivery
      const deliveryIdentifier = `${recipient.establishmentId}-${donor.establishmentId}-${formatCzechDate(deliveryDate)}`
        .toLowerCase()
        .replace(/ /g, "");

      // Persist all server-calculated fields to the delivery document
      await initializeBoxDelivery(
        docRef,
        deliveryIdentifier,
        deliveryDate,
        pickupStart,
        pickupEnd,
        deliveryStart,
        deliveryEnd,
        carrierId,
      );

      // Create DODO order or mark personal carrier as confirmed, then transition to ACCEPTED
      if (carrierId === "dodo") {
        const dodoToken = await getDodoToken();
        const order = createBoxReturnOrder(entityPair, donor, recipient, deliveryIdentifier);
        const orderCreated = await createDodoOrder(order, dodoToken);

        if (orderCreated) {
          await updateDeliveryWithOrderCreationTime(docRef, { createdAt: Timestamp.now() });
          await updateDeliveryState(docRef, "ACCEPTED");
          logger.info(`boxDeliveryCreated: DODO order created, transitioned ${snap.id} → ACCEPTED`);
        } else {
          logger.error(`boxDeliveryCreated: DODO order creation failed for ${snap.id}, staying PREPARED`);
          return;
        }
      } else {
        // Personal carrier — confirm immediately and transition to ACCEPTED
        await updateDeliveryWithOrderCreationTime(docRef, { createdAt: Timestamp.now() });
        await updateDeliveryState(docRef, "ACCEPTED");
        logger.info(`boxDeliveryCreated: personal carrier confirmed, transitioned ${snap.id} → ACCEPTED`);
      }

      // Schedule Cloud Tasks from ACCEPTED onwards
      // Box deliveries are auto-accepted by this trigger — no NOT_USED path.
      // Personal carrier: schedule all state transitions from ACCEPTED onwards.
      // DODO carrier: webhook handles state transitions (separate branch).
      const tasks: ScheduleTransitionParams[] = [];

      if (carrierId === "personal") {
        tasks.push(
          {
            deliveryId: snap.id,
            targetState: "ON_WAY_TO_PICK_UP",
            preconditionState: "ACCEPTED",
            executeAt: pickupStart,
          },
          {
            deliveryId: snap.id,
            targetState: "IN_DELIVERY",
            preconditionState: "ON_WAY_TO_PICK_UP",
            executeAt: pickupEnd,
          },
          {
            deliveryId: snap.id,
            targetState: "DELIVERED",
            preconditionState: "IN_DELIVERY",
            executeAt: deliveryEnd,
          },
        );
      }

      await scheduleMultipleTransitions(tasks);

      logger.info(
        `boxDeliveryCreated: scheduled ${tasks.length} Cloud Task(s) for ${snap.id} (carrier=${carrierId})`,
      );
    } finally {
      clearEntityCache();
    }
  },
);
