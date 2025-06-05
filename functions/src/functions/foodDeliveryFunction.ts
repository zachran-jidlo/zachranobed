import { onDocumentUpdated } from "firebase-functions/v2/firestore";
import { db } from "../config/firebase";
import { sendNotificationsAndCleanup } from "../services/notificationService";
import { isToday } from "../utils/dateUtils";

/**
 * Function triggered when a document in the "deliveries" collection is updated.
 * Notifies the charity about a donation if the delivery state is "ACCEPTED" and it's the current day.
 *
 * @param change - The change object containing the new and old data of the document.
 * @returns A Promise that resolves when the push notifications are sent.
 */
export const notifyCharityAboutDonationV2 = onDocumentUpdated(
  "deliveries/{id}",
  (event) => {
    const newValue = event.data?.after?.data();
    const oldValue = event.data?.before?.data();

    // Not a valid state, do not continue with notification.
    if (!newValue || !oldValue) return null;

    if (
      (newValue.state === "ACCEPTED" || newValue.state === "NOT_USED") && // Filter out unnecesary loading from Firestore for other states
      newValue.state !== oldValue.state &&
      isToday(newValue.pickupTimeWindow.start.toDate())
    ) {
      const recipientId = newValue.recipientId;
      const donorId = newValue.donorId;

      return Promise.all([
        db.collection("entities").doc(recipientId).get(),
        db.collection("entities").doc(donorId).get(),
      ])
        .then((results) => {
          if (results[0].exists && results[1].exists) {
            const fcmTokens = results[0].data()!.fcmTokens;
            const donor = results[1].data();

            let title = "";
            let body = "";
            let type = "";

            if (newValue.state === "ACCEPTED") {
              title = "Potvrzení darování";
              body = `${donor?.establishmentName} vám dnes daruje pokrmy.`;
              type = "RECIPIENT_FOOD_DELIVERY_ACCEPTED";
            } else if (newValue.state === "NOT_USED") {
              title = "Dnes nezbylo jídlo";
              body = `V ${donor?.establishmentName} dnes nezbylo žádné jídlo.`;
              type = "RECIPIENT_FOOD_DELIVERY_NOT_USED";
            }

            return sendNotificationsAndCleanup(
              recipientId,
              fcmTokens,
              title,
              body,
              type,
              donorId,
              recipientId
            );
          } else {
            console.error(
              "Entity not found for recipientId:",
              recipientId,
              "or donorId:",
              donorId
            );
            return null;
          }
        })
        .catch((error) => {
          console.error("Error sending push notification:", error);
          return null;
        });
    }

    return null;
  }
);
