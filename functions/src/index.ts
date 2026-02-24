// Import functions
import { notifyCharityAboutDonationV2 } from "./functions/notifications/foodDeliveryFunction";
import { notifyCanteenAboutBoxShippmentV2 } from "./functions/notifications/boxReturnFunction";
import { notifyAboutLackOfBoxes } from "./functions/notifications/lackOfBoxesFunction";
import { boxesMismatchNotification } from "./functions/mismatchFunction";
import { monthlyBoxCheckupFunction } from "./functions/notifications/monthlyBoxCheckupFunction";
import { sendOrdersFunction, sendOrders } from "./functions/sendOrdersFunction";
import { cloudTaskHandler } from "./functions/cloudTaskHandlerFunction";
import { boxDeliveryCreated } from "./functions/boxDeliveryCreatedFunction";
import { finalizeDeliveriesFunction, finalizeDeliveries } from "./functions/finalizeDeliveriesFunction";
import {
  checkOrders,
  checkOrdersFunction,
} from "./functions/checkOrdersFunction";
import { onRequest } from "firebase-functions/v2/https";
import { ENVIRONMENTS } from "./config/constants";
import { DateTime } from "luxon";

// Export for Firebase Functions (CommonJS style)
exports.notifyCharityAboutDonationV2 = notifyCharityAboutDonationV2;
exports.notifyCanteenAboutBoxShippmentV2 = notifyCanteenAboutBoxShippmentV2;
exports.notifyAboutLackOfBoxes = notifyAboutLackOfBoxes;
exports.boxesMismatchNotification = boxesMismatchNotification;
exports.monthlyBoxCheckupFunction = monthlyBoxCheckupFunction;

// Get current project ID
const currentProjectId =
  process.env.GCLOUD_PROJECT || process.env.FIREBASE_PROJECT_ID;

// DEV ONLY: Manual HTTP triggers for testing scheduled functions
if (currentProjectId === ENVIRONMENTS.DEV) {
  exports.triggerSendOrders = onRequest(async (req, res) => {
    try {
      let deliveryDate: Date | undefined;

      // Parse date from query parameter or request body
      const dateStr = req.query.date as string || req.body?.date;

      if (dateStr) {
        // Parse date string in format YYYY-MM-DD
        const parsed = DateTime.fromISO(dateStr, { zone: "Europe/Prague" });

        if (!parsed.isValid) {
          res.status(400).json({
            status: "error",
            message: `Invalid date format. Use YYYY-MM-DD format. Error: ${parsed.invalidReason}`,
          });
          return;
        }

        deliveryDate = parsed.startOf("day").toJSDate();
      }

      await sendOrders(deliveryDate);

      res.json({
        status: "success",
        message: `sendOrders executed successfully${dateStr ? ` for date ${dateStr}` : ""}`,
      });
    } catch (error) {
      res.status(500).json({
        status: "error",
        message: error instanceof Error ? error.message : "Unknown error",
      });
    }
  });

  exports.triggerCheckOrders = onRequest(async (req, res) => {
    try {
      await checkOrders();
      res.json({
        status: "success",
        message: "checkOrders executed successfully",
      });
    } catch (error) {
      res.status(500).json({
        status: "error",
        message: error instanceof Error ? error.message : "Unknown error",
      });
    }
  });

  exports.triggerFinalizeDeliveries = onRequest(async (req, res) => {
    try {
      const dateStr = req.query.date as string || req.body?.date;
      let date: Date | undefined;

      if (dateStr) {
        const parsed = DateTime.fromISO(dateStr, { zone: "Europe/Prague" });
        if (!parsed.isValid) {
          res.status(400).json({ status: "error", message: `Invalid date format. Use YYYY-MM-DD. Error: ${parsed.invalidReason}` });
          return;
        }
        date = parsed.startOf("day").toJSDate();
      }

      await finalizeDeliveries(date);
      res.json({ status: "success", message: `finalizeDeliveries executed successfully${dateStr ? ` for date ${dateStr}` : ""}` });
    } catch (error) {
      res.status(500).json({ status: "error", message: error instanceof Error ? error.message : "Unknown error" });
    }
  });
}

// Export HTTP functions
exports.cloudTaskHandler = cloudTaskHandler;

// Export Firestore triggers
exports.boxDeliveryCreated = boxDeliveryCreated;

// Export scheduled functions
exports.sendOrdersFunction = sendOrdersFunction;
exports.checkOrdersFunction = checkOrdersFunction;

exports.finalizeDeliveriesFunction = finalizeDeliveriesFunction;
