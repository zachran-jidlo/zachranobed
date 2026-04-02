import { onDocumentUpdated } from "firebase-functions/v2/firestore";
import { logger } from "firebase-functions/v2";
import { Timestamp } from "firebase-admin/firestore";
import { DeliverySchema } from "../models";
import { getEntityPairs, getEntities, clearEntityCache } from "../services/entityService";
import { updateDeliveryWithOrderCreationTime } from "../services/deliveryService";
import { getDodoToken, createDodoOrder, createFoodDeliveryOrder } from "../services/dodoService";
import {
  dodoClientId,
  dodoClientSecret,
  dodoOauthUri,
  dodoScope,
  dodoOrdersApi,
} from "../config/firebase";

/**
 * Firestore onDocumentUpdated trigger that creates a DODO carrier order
 * when a FOOD_DELIVERY transitions to ACCEPTED state.
 */
export const orderDeliveryService = onDocumentUpdated(
  {
    document: "deliveries/{id}",
    secrets: [dodoClientId, dodoClientSecret, dodoOauthUri, dodoScope, dodoOrdersApi],
  },
  async (event) => {
    const oldValue = event.data?.before?.data();
    const newValue = event.data?.after?.data();
    if (!oldValue || !newValue) return;

    // Guard: only react to transitions TO ACCEPTED
    if (oldValue.state === "ACCEPTED" || newValue.state !== "ACCEPTED") return;

    const docRef = event.data!.after.ref;
    const result = DeliverySchema.safeParse({ ref: docRef, ...newValue });
    if (!result.success) {
      logger.warn(`orderDeliveryService: invalid delivery document ${event.params.id}`, result.error);
      return;
    }

    const delivery = result.data;

    // Guard: only FOOD_DELIVERY with DODO carrier
    if (delivery.type !== "FOOD_DELIVERY") return;
    if (delivery.carrierId !== "dodo") return;

    // Guard: idempotency — skip if DODO order already created
    if (delivery.carrierOrder?.createdAt) {
      logger.info(`orderDeliveryService: carrierOrder already exists for ${event.params.id}, skipping`);
      return;
    }

    // Guard: required fields must be present (set by sendOrdersFunction)
    if (!delivery.deliveryIdentifier || !delivery.pickupTimeWindow || !delivery.deliveryTimeWindow) {
      logger.error(`orderDeliveryService: missing required fields on ${event.params.id}`);
      return;
    }

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
          `orderDeliveryService: no entity pair found for donor=${delivery.donorId} recipient=${delivery.recipientId}`,
        );
        return;
      }

      const donor = entities.find((e) => e.id === entityPair.donorId);
      const recipient = entities.find((e) => e.id === entityPair.recipientId);

      if (!donor || !recipient) {
        logger.error(
          `orderDeliveryService: donor or recipient entity not found for pair donor=${delivery.donorId} recipient=${delivery.recipientId}`,
        );
        return;
      }

      const pickupStart = delivery.pickupTimeWindow.start.toDate();
      const pickupEnd = delivery.pickupTimeWindow.end.toDate();
      const deliveryStart = delivery.deliveryTimeWindow.start.toDate();
      const deliveryEnd = delivery.deliveryTimeWindow.end.toDate();

      const dodoToken = await getDodoToken();
      const order = createFoodDeliveryOrder(
        entityPair, donor, recipient, delivery.deliveryIdentifier,
        pickupStart, pickupEnd, deliveryStart, deliveryEnd,
      );
      const orderCreated = await createDodoOrder(order, dodoToken);

      if (orderCreated) {
        await updateDeliveryWithOrderCreationTime(docRef, { createdAt: Timestamp.now() });
        logger.info(`orderDeliveryService: DODO order created for ${event.params.id}`);
      } else {
        logger.error(`orderDeliveryService: DODO order creation failed for ${event.params.id}`);
      }
    } finally {
      clearEntityCache();
    }
  },
);
