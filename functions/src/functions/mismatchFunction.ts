import { onDocumentUpdated } from "firebase-functions/v2/firestore";
import { constructAndSendEmail } from "../utils/emailUtils";

export const boxesMismatchNotification = onDocumentUpdated(
  "entityPairs/{id}",
  async (event) => {
    console.info("boxesMismatchNotification triggered");

    // Check if data exists and the specific field 'foodboxesCheckup' has been updated
    if (!event.data) {
      console.error("No data associated with the event");
      return;
    }

    const newValue = event.data.after.data();
    const oldValue = event.data.before.data();

    // Only respond to changes in the 'foodboxesCheckup' field
    if (newValue.foodboxesCheckup === oldValue.foodboxesCheckup) {
      console.info("'foodboxesCheckup' field has not been updated");
      return;
    }

    const oldDonorStatus = oldValue?.foodboxesCheckup?.donor?.status;
    const oldRecipientStatus = oldValue?.foodboxesCheckup?.recipient?.status;
    const newDonorStatus = newValue?.foodboxesCheckup?.donor?.status;
    const newRecipientStatus = newValue?.foodboxesCheckup?.recipient?.status;

    // DONOR
    if (newDonorStatus === "MISMATCH" && oldDonorStatus !== "MISMATCH") {
      console.info("Donor status is MISMATCH");

      await constructAndSendEmail(newValue.donorId, newValue, true);
    }

    // RECIPIENT
    if (
      newRecipientStatus === "MISMATCH" &&
      oldRecipientStatus !== "MISMATCH"
    ) {
      console.info("Recipient status is MISMATCH");

      await constructAndSendEmail(newValue.recipientId, newValue, false);
    }
  }
);
