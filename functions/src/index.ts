// Import functions
import { notifyCharityAboutDonationV2 } from "./functions/notifications/foodDeliveryFunction";
import { notifyCanteenAboutBoxShippmentV2 } from "./functions/notifications/boxReturnFunction";
import { notifyAboutLackOfBoxes } from "./functions/notifications/lackOfBoxesFunction";
import { boxesMismatchNotification } from "./functions/mismatchFunction";
// import { scheduledFunctionCrontab } from "./functions/checkDeliveriesInvocatorFunction"; // DEPRECATED - replaced by checkOrdersFunction
import { monthlyBoxCheckupFunction } from "./functions/notifications/monthlyBoxCheckupFunction";
import { sendOrdersFunction, sendOrders } from "./functions/sendOrdersFunction";
import {
  checkOrders,
  checkOrdersFunction,
} from "./functions/checkOrdersFunction";
import { onRequest } from "firebase-functions/v2/https";

// Export for Firebase Functions (CommonJS style)
exports.notifyCharityAboutDonationV2 = notifyCharityAboutDonationV2;
exports.notifyCanteenAboutBoxShippmentV2 = notifyCanteenAboutBoxShippmentV2;
exports.notifyAboutLackOfBoxes = notifyAboutLackOfBoxes;
exports.boxesMismatchNotification = boxesMismatchNotification;
exports.monthlyBoxCheckupFunction = monthlyBoxCheckupFunction;

// Get current project ID
const currentProjectId =
  process.env.GCLOUD_PROJECT || process.env.FIREBASE_PROJECT_ID;
// const allowedProjectId = "zachran-obed"; // DEPRECATED - was used for scheduledFunctionCrontab PROD-only export

// DEV ONLY: Manual HTTP triggers for testing scheduled functions
if (currentProjectId === "zachran-obed-dev") {
  exports.triggerSendOrders = onRequest(async (req, res) => {
    try {
      await sendOrders();
      res.json({
        status: "success",
        message: "sendOrders executed successfully",
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
}

// PROD ONLY: Export scheduled functions (DEPRECATED - scheduledFunctionCrontab replaced by checkOrdersFunction)
// if (currentProjectId === allowedProjectId) {
//   exports.scheduledFunctionCrontab = scheduledFunctionCrontab;
// }
exports.sendOrdersFunction = sendOrdersFunction;
exports.checkOrdersFunction = checkOrdersFunction;
