import { onDocumentUpdated } from "firebase-functions/v2/firestore";
import { db } from "../../config/firebase";
import { DeliveryStateSchema, DeliveryTypeSchema } from "../../models";
import { sendNotificationsAndCleanup } from "../../services/notificationService";
import { isToday } from "../../utils/dateUtils";

/**
 * Notifies the donor when an external courier is on the way to pick up the donation (delivery state
 * transitions to ON_WAY_TO_PICK_UP).
 */
export const notifyCanteenAboutCourierIncoming = onDocumentUpdated(
  "deliveries/{id}",
  (event) => {
    const newValue = event.data?.after?.data();
    const oldValue = event.data?.before?.data();

    if (!newValue || !oldValue) return null;

    if (
      newValue.state === DeliveryStateSchema.enum.ON_WAY_TO_PICK_UP &&
      newValue.state !== oldValue.state &&
      newValue.carrierId !== "personal" &&
      newValue.carrierId !== "disabled" &&
      newValue.type === DeliveryTypeSchema.enum.FOOD_DELIVERY &&
      newValue.pickupTimeWindow?.start &&
      isToday(newValue.pickupTimeWindow.start.toDate())
    ) {
      const donorId = newValue.donorId;

      return db.collection("entities").doc(donorId).get()
        .then((donorDoc) => {
          if (!donorDoc.exists) {
            console.error("Entity not found for donorId:", donorId);
            return null;
          }

          const fcmTokens = donorDoc.data()!.fcmTokens ?? {};

          return sendNotificationsAndCleanup(
            donorId,
            fcmTokens,
            "Kurýr vyjel do jídelny",
            "Kurýr je na cestě k vám.",
            "DONOR_COURIER_INCOMING",
            donorId,
            newValue.recipientId,
          );
        })
        .catch((error) => {
          console.error("Error sending courier dispatched notification:", error);
          return null;
        });
    }

    return null;
  },
);
