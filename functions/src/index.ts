// Import functions
import { notifyCharityAboutDonationV2 } from "./functions/foodDeliveryFunction";
import { notifyCanteenAboutBoxShippmentV2 } from "./functions/boxReturnFunction";
import { notifyCharityAboutLackOfBoxesAtCanteenV2 } from "./functions/lackOfBoxesFunction";
import { boxesMismatchNotification } from "./functions/mismatchFunction";
import { scheduledFunctionCrontab } from "./functions/checkDeliveriesInvocatorFunction";

// Export for Firebase Functions (CommonJS style)
exports.notifyCharityAboutDonationV2 = notifyCharityAboutDonationV2;
exports.notifyCanteenAboutBoxShippmentV2 = notifyCanteenAboutBoxShippmentV2;
exports.notifyCharityAboutLackOfBoxesAtCanteenV2 =
  notifyCharityAboutLackOfBoxesAtCanteenV2;
exports.boxesMismatchNotification = boxesMismatchNotification;

exports.scheduledFunctionCrontab = scheduledFunctionCrontab;
