// Deploy functions: firebase deploy --only functions
/* eslint-disable max-len */
import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

const db = admin.firestore();

/**
 * Represents a food box.
 * @param {string} foodBoxId - The ID of the food box.
 * @param {string} count - The total count of the food box.
 * @param {string} donorCount - The count of donors for the food box.
 * @param {string} recipientCount - The count of recipients for the food box.
 */
class FoodBox {
  /**
   * Creates a new instance of the FoodBox class.
   * @param {string} foodBoxId - The ID of the food box.
   * @param {string} count - The total count of the food box.
   * @param {string} donorCount - The count of boxes at donor side.
   * @param {string} recipientCount - The count boxes at recipient side.
   */
  constructor(
    public foodBoxId: string,
    public count: number,
    public donorCount: number,
    public recipientCount: number
  ) {}
}

/**
 * Function triggered when a document in the "deliveries" collection is updated.
 * Notifies the charity about a donation if the delivery state is "ACCEPTED" and it's the current day.
 *
 * @param change - The change object containing the new and old data of the document.
 * @param context - The context object containing metadata about the event.
 * @returns A Promise that resolves when the push notifications are sent.
 */
export const notifyCharityAboutDonation = functions.firestore
  .document("deliveries/{id}")
  .onUpdate((change, context) => {
    const newValue = change.after.data();
    const oldValue = change.before.data();

    if (
      newValue.state === "ACCEPTED" &&
      newValue.state !== oldValue.state &&
      isToday(newValue.pickupTimeWindow.start.toDate())
    ) {
      const recipientId = newValue.recipientId;

      return db
        .collection("entities")
        .doc(recipientId)
        .get()
        .then((entityDoc) => {
          if (entityDoc.exists) {
            const fcmTokens = entityDoc.data()!.fcmTokens;

            // Create message for all tokens of given entity
            const messages = Object.values(fcmTokens).map((token) => {
              return {
                notification: {
                  title: "Potvrzení doručování",
                  body: "Dnes vám budou doručovány darované pokrmy.",
                },
                token: token as string,
              };
            });

            return admin.messaging().sendEach(messages);
          } else {
            console.error("Entity not found for recipientId:", recipientId);
            return null;
          }
        })
        .then((response) => {
          console.info(
            "Successfully sent " + response?.successCount + " push messages."
          );
          // TODO: Go through success of each message and remove tokens that are not registered.
          // TODO: Thjere is a problem with messaging/mismatched-credential - token is from the app registered to diffrent Firebase project - DEV vs PROD.
        })
        .catch((error) => {
          console.error("Error sending push notification:", error);
          return null;
        });
    }

    return null;
  });

/**
 * Function triggered when there is an update in the "entityPairs" collection in foodboxes list.
 * It notifies a charity about the lack of boxes at a canteen.
 *
 * @param change - The change event that triggered the function.
 * @param context - The context of the function execution.
 * @returns A promise that resolves when the notification is sent successfully.
 */
export const notifyCharityAboutLackOfBoxesAtCanteen = functions.firestore
  .document("entityPairs/{id}")
  .onUpdate((change, context) => {
    const newBoxes = change.after.data().foodboxes;
    const oldBoxes = change.before.data().foodboxes;

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
      return null;
    }

    // TODO: Cache changes and send notification only once a day. Right now each change triggers a notification.

    const recipientId = change.after.data().recipientId;
    const donorId = change.after.data().donorId;

    return Promise.all([
      db.collection("entities").doc(recipientId).get(),
      db.collection("entities").doc(donorId).get(),
      db.collection("foodBoxes").get(),
    ]).then((results) => {
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
          return;
        }

        results[2].docs
          .filter((doc) => doc.id === foodBoxId)
          .forEach((doc) => {
            const foodBox = doc.data();
            insufficentBoxes.push(foodBox.name);
          });
      });

      if (
        results[0].exists &&
        results[1].exists &&
        insufficentBoxes.length > 0
      ) {
        const fcmTokens = results[0].data()!.fcmTokens;
        const donor = results[1].data();

        const boxesString = insufficentBoxes.join(", ");

        // Create message for all tokens of given entity
        const messages = Object.values(fcmTokens).map((token) => {
          return {
            notification: {
              title: "Jídelně docházejí krabičky",
              body: `Objednejte prosím svoz krabiček typu "${boxesString}" do jídelny "${donor?.establishmentName}"`,
            },
            token: token as string,
          };
        });

        console.log(messages);

        return admin.messaging().sendEach(messages);
      } else {
        console.error("Entity not found for recipientId:", recipientId);
        return null;
      }
    })
      .then((response) => {
        console.info(
          "Successfully sent " + response?.successCount + " push messages."
        );
      })
      .catch((error) => {
        console.error("Error sending push notification:", error);
        return null;
      });
  });

/**
 * Is triggered when a document is created in the "deliveries" collection.
 * Notifies the canteen about the shipment of boxes.
 *
 * @param {admin.firestore.DocumentSnapshot} snapshot - The snapshot of the created delivery document.
 * @param {functions.EventContext} context - The event context.
 * @returns {Promise<any>} A promise that resolves when the notification is sent.
 */
export const notifyCanteenAboutBoxShippment = functions.firestore
  .document("deliveries/{id}")
  .onCreate((snapshot, context) => {
    const data = snapshot.data();
    const donorId = data.donorId;

    if (data.type === "BOX_DELIVERY") {
      return db
        .collection("entities")
        .doc(donorId)
        .get()
        .then((entityDoc) => {
          if (entityDoc.exists) {
            const fcmTokens = entityDoc.data()!.fcmTokens;

            // Create message for all tokens of given entity
            const messages = Object.values(fcmTokens).map((token) => {
              return {
                notification: {
                  title: "Potvrzení svozu krabiček",
                  body: "Charita vám posílá krabičky.",
                },
                token: token as string,
              };
            });

            return admin.messaging().sendEach(messages);
          } else {
            console.error("Entity not found for donorId:", donorId);
            return null;
          }
        })
        .then((response) => {
          console.info(
            "Successfully sent " + response?.successCount + " push messages."
          );
        })
        .catch((error) => {
          console.error("Error sending push notification:", error);
          return null;
        });
    }

    return null;
  });

/** Checks if the given date is today.
 * @param {Date} date - The date to check.
 * @return {Boolean} - True if the date is today, false otherwise.
 */
function isToday(date: Date): boolean {
  const today = new Date();
  return (
    date.getFullYear() === today.getFullYear() &&
    date.getMonth() === today.getMonth() &&
    date.getDate() === today.getDate()
  );
}
