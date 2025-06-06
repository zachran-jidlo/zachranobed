// Import functions
import { notifyCharityAboutDonationV2 } from "./functions/notifications/foodDeliveryFunction";
import { notifyCanteenAboutBoxShippmentV2 } from "./functions/notifications/boxReturnFunction";
import { notifyCharityAboutLackOfBoxesAtCanteenV2 } from "./functions/notifications/lackOfBoxesFunction";
import { boxesMismatchNotification } from "./functions/mismatchFunction";

// Export for Firebase Functions (CommonJS style)
exports.notifyCharityAboutDonationV2 = notifyCharityAboutDonationV2;
exports.notifyCanteenAboutBoxShippmentV2 = notifyCanteenAboutBoxShippmentV2;
exports.notifyCharityAboutLackOfBoxesAtCanteenV2 =
  notifyCharityAboutLackOfBoxesAtCanteenV2;
exports.boxesMismatchNotification = boxesMismatchNotification;
