import { onSchedule } from "firebase-functions/v2/scheduler";
import { db } from "../../config/firebase";
import { sendNotificationsAndCleanup } from "../../services/notificationService";

/**
 * Function that runs every Friday at 9AM and checks if it's the first Friday of the month.
 * If it is, sends notifications to entities that manage food boxes.
 *
 * Only entities linked to at least one entity pair with boxes (count > 0) receive
 * a notification. Each entity receives at most one notification regardless of how
 * many pairs it belongs to.
 */
export const monthlyBoxCheckupFunction = onSchedule(
  {
    schedule: "0 9 * * 5", // Every Friday at 9:00 AM
    timeZone: "Europe/Prague",
  },
  async (event) => {
    const now = new Date();

    // Check if it's the first Friday (day between 1-7)
    if (now.getDate() > 7) {
      console.info("Not the first Friday of the month, skipping notifications");
      return;
    }

    console.info("It's the first Friday of the month, sending notifications");

    // Get all entity pairs and collect entity IDs that have boxes
    const entityPairsSnapshot = await db.collection("entityPairs").get();
    const entityIdsWithBoxes = new Set<string>();

    for (const doc of entityPairsSnapshot.docs) {
      const data = doc.data();
      const foodboxes = data.foodboxes ?? [];
      const hasBoxes = foodboxes.some(
        (box: { count?: number }) => (box.count ?? 0) > 0,
      );

      if (hasBoxes) {
        entityIdsWithBoxes.add(data.donorId);
        entityIdsWithBoxes.add(data.recipientId);
      }
    }

    if (entityIdsWithBoxes.size === 0) {
      console.info("No entities with boxes found, skipping notifications");
      return;
    }

    console.info(
      `Found ${entityIdsWithBoxes.size} entities with boxes, sending notifications`,
    );

    // Fetch entity docs and send notifications
    const notificationPromises = Array.from(entityIdsWithBoxes).map(
      async (entityId) => {
        const entityDoc = await db.collection("entities").doc(entityId).get();
        if (!entityDoc.exists) {
          console.warn(`Entity ${entityId} not found, skipping`);
          return;
        }

        const entity = entityDoc.data()!;
        const fcmTokens = entity.fcmTokens || {};

        return sendNotificationsAndCleanup(
          entityId,
          fcmTokens,
          "Kontrola krabiček",
          "Proveďte měsíční kontrolu stavu krabiček",
          "ALL_FOOD_BOXES_CHECKUP",
        );
      },
    );

    try {
      await Promise.all(notificationPromises);
      console.info("Monthly box checkup notifications sent successfully");
    } catch (error) {
      console.error(
        "Error while sending monthly box checkup notifications",
        error,
      );
    }
  },
);
