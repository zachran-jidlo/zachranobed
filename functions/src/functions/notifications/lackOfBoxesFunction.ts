import { onDocumentUpdated } from "firebase-functions/v2/firestore";
import { db } from "../../config/firebase";
import { sendNotificationsAndCleanup } from "../../services/notificationService";
import { FoodBox } from "../../models/FoodBox";

/**
 * Function triggered when there is an update in the "entityPairs" collection in foodboxes list.
 * It notifies a charity about the lack of boxes at a canteen.
 *
 * @param change - The change event that triggered the function.
 * @returns A promise that resolves when the notification is sent successfully.
 */
export const notifyAboutLackOfBoxes = onDocumentUpdated(
  "entityPairs/{id}",
  async (event) => {
    console.info("notifyAboutLackOfBoxes triggered");

    // Add defensive checks for event data
    if (!event.data?.after?.data() || !event.data?.before?.data()) {
      console.error("Missing event data");
      return null;
    }

    const newBoxes = event.data.after.data().foodboxes;
    const oldBoxes = event.data.before.data().foodboxes;

    // Check if foodboxes arrays exist
    if (
      !newBoxes ||
      !oldBoxes ||
      !Array.isArray(newBoxes) ||
      !Array.isArray(oldBoxes)
    ) {
      console.error("Missing or invalid foodboxes arrays", {
        newBoxes,
        oldBoxes,
      });
      return null;
    }

    console.info("Processing foodboxes", {
      newBoxesCount: newBoxes.length,
      oldBoxesCount: oldBoxes.length,
    });

    const differenceMap: { [foodBoxId: string]: number } = {};
    newBoxes.forEach((newBox: FoodBox) => {
      const matchingOldBox = oldBoxes.find(
        (oldBox: FoodBox) => oldBox.foodBoxId === newBox.foodBoxId
      );

      if (matchingOldBox && newBox.donorCount < matchingOldBox.donorCount) {
        // TODO: Difference is used only for logging purposes. It can be deleted in future but leaving it here for now because of debugging.
        const difference = newBox.donorCount - matchingOldBox.donorCount;
        differenceMap[newBox.foodBoxId] = difference;
      }
    });

    // Stop if there are no changes
    if (Object.keys(differenceMap).length <= 0) {
      console.info("No changes detected, exiting");
      return null;
    }

    // TODO: Cache changes and send notification only once a day. Right now each change triggers a notification.

    const recipientId = event.data.after.data().recipientId;
    const donorId = event.data.after.data().donorId;

    // Check if IDs exist
    if (!recipientId || !donorId) {
      console.error("Missing recipientId or donorId", { recipientId, donorId });
      return null;
    }

    console.info("Fetching entities", { recipientId, donorId });

    try {
      const [recipientDoc, donorDoc, foodBoxesSnapshot] = await Promise.all([
        db.collection("entities").doc(recipientId).get(),
        db.collection("entities").doc(donorId).get(),
        db.collection("foodBoxes").get(),
      ]);

      const insufficentBoxes: string[] = [];

      // Create boxes array from insufficent boxes types
      Object.keys(differenceMap).forEach((foodBoxId: string) => {
        console.log(
          `Food box ${foodBoxId} has decreased by ${differenceMap[foodBoxId]}.`
        );

        if (
          newBoxes.find((box: FoodBox) => box.foodBoxId === foodBoxId)
            ?.donorCount >= 10
        ) {
          console.info(`Skipping ${foodBoxId} - donorCount >= 10`);
          return;
        }

        foodBoxesSnapshot.docs
          .filter((doc) => doc.id === foodBoxId)
          .forEach((doc) => {
            const foodBox = doc.data();
            insufficentBoxes.push(foodBox.name);
          });
      });

      console.info("Insufficient boxes found", {
        insufficentBoxes,
        recipientExists: recipientDoc.exists,
        donorExists: donorDoc.exists,
      });

      if (
        recipientDoc.exists &&
        donorDoc.exists &&
        insufficentBoxes.length > 0
      ) {
        const fcmTokens = recipientDoc.data()!.fcmTokens;
        const donor = donorDoc.data();

        const boxesString = insufficentBoxes.join(", ");
        const title = "Jídelně docházejí krabičky";
        const body = `V ${donor?.establishmentName} docházejí krabičky typu: ${boxesString}.`;

        console.info("Sending notification", { title, body, recipientId });

        return await sendNotificationsAndCleanup(
          recipientId,
          fcmTokens,
          title,
          body,
          "RECIPIENT_INSUFFICIENT_BOXES",
          donorId,
          recipientId
        );
      } else {
        console.error("Entity not found for recipientId:", recipientId);
        return null;
      }
    } catch (error) {
      console.error("Error sending push notification:", error);
      return null;
    }
  }
);
