import { onDocumentUpdated } from "firebase-functions/v2/firestore";
import { db } from "../../config/firebase";
import { DeliveryStateSchema, DeliveryTypeSchema } from "../../models";
import { sendNotificationsAndCleanup } from "../../services/notificationService";
import { isToday } from "../../utils/dateUtils";

/**
 * Notifies the charity when an external courier has picked up the donation and is on the way to deliver
 * it (delivery state transitions to IN_DELIVERY).
 */
export const notifyCharityAboutCourierIncoming = onDocumentUpdated(
  "deliveries/{id}",
  (event) => {
    const newValue = event.data?.after?.data();
    const oldValue = event.data?.before?.data();

    if (!newValue || !oldValue) return null;

    if (
      newValue.state === DeliveryStateSchema.enum.IN_DELIVERY &&
      newValue.state !== oldValue.state &&
      newValue.carrierId !== "personal" &&
      newValue.carrierId !== "disabled" &&
      newValue.type === DeliveryTypeSchema.enum.FOOD_DELIVERY &&
      newValue.pickupTimeWindow?.start &&
      isToday(newValue.pickupTimeWindow.start.toDate())
    ) {
      const recipientId = newValue.recipientId;

      return db.collection("entities").doc(recipientId).get()
        .then((recipientDoc) => {
          if (!recipientDoc.exists) {
            console.error("Entity not found for recipientId:", recipientId);
            return null;
          }

          const fcmTokens = recipientDoc.data()!.fcmTokens ?? {};

          return sendNotificationsAndCleanup(
            recipientId,
            fcmTokens,
            "Kurýr je na cestě k vám",
            "Kurýr právě vyjel s darovanými pokrmy z jídelny.",
            "RECIPIENT_COURIER_INCOMING",
            newValue.donorId,
            recipientId,
          );
        })
        .catch((error) => {
          console.error("Error sending charity courier incoming notification:", error);
          return null;
        });
    }

    return null;
  },
);
