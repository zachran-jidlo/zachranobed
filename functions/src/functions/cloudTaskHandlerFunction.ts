import { onRequest } from "firebase-functions/v2/https";
import { logger } from "firebase-functions/v2";
import { db, currentServiceAccount } from "../config/firebase";
import { DeliverySchema, DeliveryStateSchema } from "../models";
import { updateDeliveryState } from "../services/deliveryService";

/**
 * HTTP Cloud Function invoked by Cloud Tasks to execute delivery state transitions.
 * Auth: IAM invoker policy — only the Cloud Tasks service account can call this.
 * The `invoker` option sets the Cloud Run IAM binding automatically on deploy.
 */
export const cloudTaskHandler = onRequest({ invoker: currentServiceAccount }, async (req, res) => {
  // Validate HTTP method
  if (req.method !== "POST") {
    res.status(405).send("Method Not Allowed");
    return;
  }

  const { deliveryId, targetState, preconditionState } = req.body ?? {};

  // Validate required fields
  if (!deliveryId || !targetState || !preconditionState) {
    logger.warn("cloudTaskHandler: missing required fields", req.body);
    res.status(400).json({ error: "Missing required fields: deliveryId, targetState, preconditionState" });
    return;
  }

  // Validate state values against the schema
  const targetParsed = DeliveryStateSchema.safeParse(targetState);
  const preconditionParsed = DeliveryStateSchema.safeParse(preconditionState);

  if (!targetParsed.success || !preconditionParsed.success) {
    res.status(400).json({ error: "Invalid state values" });
    return;
  }

  try {
    const docRef = db.collection("deliveries").doc(deliveryId);
    const doc = await docRef.get();

    if (!doc.exists) {
      logger.error(`cloudTaskHandler: delivery not found: ${deliveryId}`);
      // Return 200 to prevent Cloud Tasks retry for a permanently missing document
      res.status(200).json({ skipped: true, reason: "delivery not found" });
      return;
    }

    const result = DeliverySchema.safeParse({ ref: docRef, ...doc.data() });
    if (!result.success) {
      logger.error(`cloudTaskHandler: invalid delivery document ${deliveryId}`, result.error);
      res.status(500).json({ error: "Invalid delivery document" });
      return;
    }

    const delivery = result.data;

    // Precondition guard — only transition if current state matches expected
    if (delivery.state !== preconditionParsed.data) {
      logger.info(
        `cloudTaskHandler: skipping transition for ${deliveryId} — state is '${delivery.state}', expected '${preconditionParsed.data}'`,
      );
      res.status(200).json({ skipped: true, reason: `state mismatch: current=${delivery.state}` });
      return;
    }

    await updateDeliveryState(docRef, targetParsed.data);
    logger.info(`cloudTaskHandler: transitioned ${deliveryId} from ${preconditionParsed.data} to ${targetParsed.data}`);

    res.status(200).json({ success: true });
  } catch (error) {
    logger.error(`cloudTaskHandler: Firestore error for delivery ${deliveryId}`, error);
    // Return 500 so Cloud Tasks retries
    res.status(500).json({ error: "Internal error" });
  }
});
