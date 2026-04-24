import { onRequest } from "firebase-functions/v2/https";
import { logger } from "firebase-functions/v2";
import { db, currentServiceAccount } from "../../config/firebase";
import { DeliverySchema, DeliveryStateSchema } from "../../models";
import { sendNotificationsAndCleanup } from "../../services/notificationService";

/**
 * HTTP Cloud Function invoked by Cloud Tasks to send a confirmation reminder
 * to the donor few minutes before the confirmation time expires.
 *
 * Only sends the notification if the delivery is still in PREPARED state
 * (the donor hasn't confirmed yet).
 *
 * Auth: IAM invoker policy — only the Cloud Tasks service account can call this.
 * The `invoker` option sets the Cloud Run IAM binding automatically on deploy.
 */
export const confirmationReminderHandler = onRequest({ invoker: currentServiceAccount }, async (req, res) => {
    if (req.method !== "POST") {
      res.status(405).send("Method Not Allowed");
      return;
    }

    const { deliveryId } = req.body ?? {};

    if (!deliveryId) {
      logger.warn("confirmationReminderHandler: missing deliveryId", req.body);
      res.status(400).json({ error: "Missing required field: deliveryId" });
      return;
    }

    try {
      const docRef = db.collection("deliveries").doc(deliveryId);
      const doc = await docRef.get();

      if (!doc.exists) {
        logger.info(`confirmationReminderHandler: delivery not found: ${deliveryId}`);
        res.status(200).json({ skipped: true, reason: "delivery not found" });
        return;
      }

      const result = DeliverySchema.safeParse({ ref: docRef, ...doc.data() });
      if (!result.success) {
        logger.error(`confirmationReminderHandler: invalid delivery document ${deliveryId}`, result.error);
        res.status(200).json({ skipped: true, reason: "invalid delivery document" });
        return;
      }

      const delivery = result.data;

      // Only remind if the donor hasn't confirmed yet
      const expectedState = DeliveryStateSchema.enum.PREPARED;
      if (delivery.state !== expectedState) {
        logger.info(
          `confirmationReminderHandler: skipping reminder for ${deliveryId} — state is '${delivery.state}', expected '${expectedState}'`,
        );
        res.status(200).json({ skipped: true, reason: `state mismatch: current=${delivery.state}` });
        return;
      }

      // Load donor entity to get FCM tokens and name
      const donorDoc = await db.collection("entities").doc(delivery.donorId).get();

      if (!donorDoc.exists) {
        logger.error(`confirmationReminderHandler: donor entity not found: ${delivery.donorId}`);
        res.status(200).json({ skipped: true, reason: "donor entity not found" });
        return;
      }

      const donor = donorDoc.data()!;
      const fcmTokens = donor.fcmTokens ?? {};

      await sendNotificationsAndCleanup(
        delivery.donorId,
        fcmTokens,
        "Blíží se konec odpočtu",
        "Zbývá vám dnes jídlo? Máte 10 minut do konce času pro potvrzení darování.",
        "DONOR_CONFIRMATION_REMINDER",
        delivery.donorId,
        delivery.recipientId,
      );

      logger.info(`confirmationReminderHandler: sent reminder for delivery ${deliveryId}`);
      res.status(200).json({ success: true });
    } catch (error) {
      logger.error(`confirmationReminderHandler: error for delivery ${deliveryId}`, error);
      res.status(500).json({ error: "Internal error" });
    }
  },
);
