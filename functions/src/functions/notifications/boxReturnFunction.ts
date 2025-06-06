import { onDocumentCreated } from "firebase-functions/v2/firestore";
import { db } from "../../config/firebase";
import { sendNotificationsAndCleanup } from "../../services/notificationService";

/**
 * Is triggered when a document is created in the "deliveries" collection.
 * Notifies the canteen about the shipment of boxes.
 *
 * @param {admin.firestore.DocumentSnapshot} snapshot - The snapshot of the created delivery document.
 * @returns {Promise<any>} A promise that resolves when the notification is sent.
 */
export const notifyCanteenAboutBoxShippmentV2 = onDocumentCreated(
  "deliveries/{id}",
  (event) => {
    const data = event.data;
    if (!data) {
      console.log("No data associated with the event");
      return;
    }
    const delivery = data.data();
    const donorId = delivery.donorId;

    if (delivery.type === "BOX_DELIVERY") {
      return db
        .collection("entities")
        .doc(donorId)
        .get()
        .then((entityDoc) => {
          if (entityDoc.exists) {
            const fcmTokens = entityDoc.data()!.fcmTokens;
            const title = "Potvrzení svozu krabiček";
            const body = "Charita Vám vrací krabičky.";

            return sendNotificationsAndCleanup(
              donorId,
              fcmTokens,
              title,
              body,
              "DONOR_BOX_DELIVERY",
              donorId,
              delivery.recipientId
            );
          } else {
            console.error("Entity not found for donorId:", donorId);
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
