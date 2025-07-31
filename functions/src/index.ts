// Import functions
import { notifyCharityAboutDonationV2 } from "./functions/notifications/foodDeliveryFunction";
import { notifyCanteenAboutBoxShippmentV2 } from "./functions/notifications/boxReturnFunction";
import { notifyAboutLackOfBoxes } from "./functions/notifications/lackOfBoxesFunction";
import { boxesMismatchNotification } from "./functions/mismatchFunction";
import { scheduledFunctionCrontab } from "./functions/checkDeliveriesInvocatorFunction";
import { monthlyBoxCheckupFunction } from "./functions/notifications/monthlyBoxCheckupFunction";

// Export for Firebase Functions (CommonJS style)
exports.notifyCharityAboutDonationV2 = notifyCharityAboutDonationV2;
exports.notifyCanteenAboutBoxShippmentV2 = notifyCanteenAboutBoxShippmentV2;
exports.notifyAboutLackOfBoxes = notifyAboutLackOfBoxes;
exports.boxesMismatchNotification = boxesMismatchNotification;
exports.monthlyBoxCheckupFunction = monthlyBoxCheckupFunction;

// Only export the scheduled function for the specific project
const currentProjectId =
  process.env.GCLOUD_PROJECT || process.env.FIREBASE_PROJECT_ID;
const allowedProjectId = "zachran-obed"; // Replace with your target project ID

if (currentProjectId === allowedProjectId) {
  exports.scheduledFunctionCrontab = scheduledFunctionCrontab;
}
