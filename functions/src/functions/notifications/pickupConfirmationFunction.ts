import { onDocumentUpdated } from "firebase-functions/v2/firestore";
import { db } from "../../config/firebase";
import { sendNotificationsAndCleanup } from "../../services/notificationService";
import { isToday } from "../../utils/dateUtils";

/**
 * Function triggered when a document in the "deliveries" collection is updated.
 * Notifies the canteen (donor) once the charity confirms it will pick the
 * donation up. Fires only on the moment `pickupConfirmedAt` is first set, for a
 * today delivery in the ACCEPTED state.
 *
 * @param event - The change object containing the new and old data of the document.
 * @returns A Promise that resolves when the push notifications are sent.
 */
export const notifyCanteenAboutPickupConfirmed = onDocumentUpdated(
  "deliveries/{id}",
  (event) => {
    const newValue = event.data?.after?.data();
    const oldValue = event.data?.before?.data();

    // Not a valid state, do not continue with notification.
    if (!newValue || !oldValue) return null;

    const oldConfirmed = oldValue.pickupConfirmation?.pickupConfirmedAt;
    const newConfirmed = newValue.pickupConfirmation?.pickupConfirmedAt;

    if (
      newValue.state === "ACCEPTED" && // Filter out unnecessary loading from Firestore for other states
      !oldConfirmed && newConfirmed && // Fire only when pickup is confirmed for the first time
      isToday(newValue.pickupTimeWindow.start.toDate())
    ) {
      const donorId = newValue.donorId;
      const recipientId = newValue.recipientId;

      return Promise.all([
        db.collection("entities").doc(donorId).get(),
        db.collection("entities").doc(recipientId).get(),
      ])
        .then((results) => {
          if (results[0].exists && results[1].exists) {
            const fcmTokens = results[0].data()!.fcmTokens;
            const recipient = results[1].data();

            const title = "Charita potvrdila vyzvednutí";
            const body =
              `Charita ${recipient?.establishmentName} potvrdila vyzvednutí, ` +
              "pro darované pokrmy si přijde ve stanoveném čase.";
            const type = "DONOR_PICKUP_CONFIRMED";

            return sendNotificationsAndCleanup(
              donorId,
              fcmTokens,
              title,
              body,
              type,
              donorId,
              recipientId
            );
          } else {
            console.error(
              "Entity not found for donorId:",
              donorId,
              "or recipientId:",
              recipientId
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
