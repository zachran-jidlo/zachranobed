import { onSchedule } from "firebase-functions/v2/scheduler";
import { db } from "../../config/firebase";
import { sendNotificationsAndCleanup } from "../../services/notificationService";

/**
 * Function that runs every Friday at 9AM and checks if it's the first Friday of the month.
 * If it is, sends notifications to all entities about checking their food boxes.
 */
export const monthlyBoxCheckupFunction = onSchedule(
  "0 9 * * 5", // Every Friday at 9:00 AM
  async (event) => {
    const now = new Date();

    // Check if it's the first Friday (day between 1-7)
    if (now.getDate() >= 1 && now.getDate() <= 7) {
      console.info("It's the first Friday of the month, sending notifications");

      // Get all entities
      const entitiesSnapshot = await db.collection("entities").get();

      // Send notifications to all entities
      const notificationPromises = entitiesSnapshot.docs.map((doc) => {
        const entity = doc.data();
        const fcmTokens = entity.fcmTokens || {};

        return sendNotificationsAndCleanup(
          doc.id,
          fcmTokens,
          "Kontrola krabiček",
          "Proveďte měsíční kontrolu stavu krabiček",
          "ALL_FOOD_BOXES_CHECKUP"
        );
      });

      await Promise.all(notificationPromises);
      console.info("Monthly box checkup notifications sent successfully");
    } else {
      console.info("Not the first Friday of the month, skipping notifications");
    }
  }
);
