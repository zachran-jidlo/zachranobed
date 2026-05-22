import {onDocumentUpdated} from "firebase-functions/v2/firestore";
import {logger} from "firebase-functions/v2";
import {z} from "zod";
import {db} from "../config/firebase";
import {DeliverySchema} from "../models";
import {getEntityPairs, clearEntityCache} from "../services/entityService";

/**
 * Schema for parsing individual food box items from the delivery's foodBoxes
 * array. The delivery stores these as z.array(z.any()), so we parse each
 * element explicitly.
 */
const DeliveryFoodBoxSchema = z.object({
  foodBoxId: z.string(),
  count: z.number(),
});

/**
 * Firestore onDocumentUpdated trigger that transfers box counts in the
 * EntityPair document when a delivery transitions to the DELIVERED state.
 *
 * For FOOD_DELIVERY (canteen → charity): donorCount decreases, recipientCount increases.
 * For BOX_DELIVERY (charity → canteen): donorCount increases, recipientCount decreases.
 *
 * Uses a Firestore transaction to prevent race conditions when multiple
 * deliveries for the same entity pair are delivered simultaneously.
 */
export const boxTransfer = onDocumentUpdated(
  "deliveries/{id}",
  async (event) => {
    const oldValue = event.data?.before?.data();
    const newValue = event.data?.after?.data();
    if (!oldValue || !newValue) return;

    // Guard: only react to transitions TO DELIVERED
    if (oldValue.state === "DELIVERED" || newValue.state !== "DELIVERED") return;

    // Guard: only process deliveries explicitly marked for server-side transfer.
    // - false  → new app created this delivery, Cloud Function should transfer
    // - true   → already transferred, skip
    // - absent → old app created this delivery and transferred client-side, skip
    if (newValue.foodBoxesTransferred !== false) {
      logger.info(`boxTransfer: skipping ${event.params.id} (foodBoxesTransferred=${newValue.foodBoxesTransferred})`);
      return;
    }

    const docRef = event.data!.after.ref;
    const result = DeliverySchema.safeParse({ ref: docRef, ...newValue });
    if (!result.success) {
      logger.error(`boxTransfer: invalid delivery document ${event.params.id}`, result.error);
      return;
    }

    const delivery = result.data;

    // Guard: skip deliveries without food boxes
    if (!delivery.foodBoxes || delivery.foodBoxes.length === 0) {
      logger.info(`boxTransfer: no foodBoxes on ${event.params.id}, skipping`);
      return;
    }

    // Parse delivery food boxes and build change map
    const changeMap: Record<string, number> = {};
    for (const item of delivery.foodBoxes) {
      const parsed = DeliveryFoodBoxSchema.safeParse(item);
      if (!parsed.success) {
        logger.warn(`boxTransfer: invalid foodBox item on ${event.params.id}`, parsed.error);
        continue;
      }
      const {foodBoxId, count} = parsed.data;
      changeMap[foodBoxId] = (changeMap[foodBoxId] || 0) + count;
    }

    if (Object.keys(changeMap).length === 0) {
      logger.warn(`boxTransfer: no valid foodBoxes on ${event.params.id}`);
      return;
    }

    // FOOD_DELIVERY: donor sends to recipient (donorCount -, recipientCount +)
    // BOX_DELIVERY: recipient returns to donor (donorCount +, recipientCount -)
    const direction = delivery.type === "FOOD_DELIVERY" ? 1 : -1;

    logger.info(
      `boxTransfer: processing ${event.params.id}, type=${delivery.type}, ` +
      `donor=${delivery.donorId}, recipient=${delivery.recipientId}`,
    );

    try {
      const entityPairs = await getEntityPairs();
      const entityPair = entityPairs.find(
        (pair) =>
          pair.donorId === delivery.donorId &&
          pair.recipientId === delivery.recipientId,
      );

      if (!entityPair) {
        logger.error(
          `boxTransfer: no EntityPair found for ` +
          `donor=${delivery.donorId} recipient=${delivery.recipientId}`,
        );
        return;
      }

      await db.runTransaction(async (transaction) => {
        const pairDoc = await transaction.get(entityPair.ref);
        if (!pairDoc.exists) {
          throw new Error(`EntityPair ${entityPair.ref.id} disappeared during transaction`);
        }

        const pairData = pairDoc.data()!;
        const foodboxes = pairData.foodboxes;

        if (!foodboxes || !Array.isArray(foodboxes)) {
          throw new Error(`EntityPair ${entityPair.ref.id} has no foodboxes array`);
        }

        const updatedFoodboxes = foodboxes.map(
          (box: Record<string, unknown>) => {
            const foodBoxId = box.foodBoxId as string;
            const changeCount = changeMap[foodBoxId] || 0;
            if (changeCount === 0) return box;

            return {
              ...box,
              donorCount: (box.donorCount as number) - direction * changeCount,
              recipientCount: (box.recipientCount as number) + direction * changeCount,
            };
          },
        );

        transaction.update(entityPair.ref, {foodboxes: updatedFoodboxes});
      });

      await docRef.update({foodBoxesTransferred: true});

      logger.info(`boxTransfer: successfully transferred boxes for ${event.params.id}`);
    } catch (error) {
      logger.error(`boxTransfer: failed for ${event.params.id}:`, error);
    } finally {
      clearEntityCache();
    }
  },
);
