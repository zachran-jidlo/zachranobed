import { onDocumentUpdated } from "firebase-functions/v2/firestore";
import { db } from "../../config/firebase";
import { DeliveryStateSchema, DeliveryTypeSchema } from "../../models";
import { sendNotificationsAndCleanup } from "../../services/notificationService";
import { isToday } from "../../utils/dateUtils";

/**
 * Notifies the donor when the delivery transitions to IN_DELIVERY
 * (courier picked up and is heading to charity) but no meals have been entered.
 */
export const notifyCanteenAboutMissingMealInfo = onDocumentUpdated(
  "deliveries/{id}",
  (event) => {
    const newValue = event.data?.after?.data();
    const oldValue = event.data?.before?.data();

    if (!newValue || !oldValue) return null;

    if (
      newValue.state === DeliveryStateSchema.enum.IN_DELIVERY &&
      newValue.state !== oldValue.state &&
      newValue.type === DeliveryTypeSchema.enum.FOOD_DELIVERY &&
      (!newValue.meals || newValue.meals.length === 0) &&
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
            "Nezadali jste informace o daru",
            "Nezapomeňte zadat informace o darovaných pokrmech z dnešního dne.",
            "DONOR_MISSING_MEAL_INFO",
            donorId,
            newValue.recipientId,
          );
        })
        .catch((error) => {
          console.error("Error sending missing meal info notification:", error);
          return null;
        });
    }

    return null;
  },
);
