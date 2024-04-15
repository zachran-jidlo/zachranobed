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
 * Represents a delivery food box.
 * @param {string} foodBoxId - The ID of the food box.
 * @param {string} count - The total count of the food box.
 */
class DeliveryFoodBox {
  /**
   * Represents a food box.
   * @param {string} foodBoxId - The ID of the food box.
   * @param {string} count - The total count of the food box.
   */
  constructor(
    public foodBoxId: string,
    public count: number
  ) {}
}

/**
 * The ID of the disposable box.
 */
const disposableBoxId = "disposable";

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

/**
 * Moves boxes based on the type of delivery.
 *
 * @param change - The change event that triggered the function.
 * @param context - The context of the function execution.
 * @returns A Promise that resolves when the boxes are moved.
 */
export const moveBoxes = functions.firestore
  .document("deliveries/{id}")
  .onWrite((change, context) => {
    const newValue = change.after.data();
    const oldValue = change.before.data();

    // Do not process delete actions
    if (newValue == null) {
      return null;
    }

    if (newValue.type === "FOOD_DELIVERY") {
      return moveBoxesFromDonorToRecipient(newValue, oldValue);
    } else {
      return moveBoxesFromRecipientToDonor(newValue, oldValue);
    }
  });

/**
 * Moves food boxes from a donor to a recipient based on the changes in the delivery state.
 *
 * @param {admin.firestore.DocumentData} newValue - The new value of the delivery document.
 * @param {admin.firestore.DocumentData} oldValue - The previous value of the delivery document.
 */
function moveBoxesFromDonorToRecipient(
  newValue: admin.firestore.DocumentData,
  oldValue: admin.firestore.DocumentData | undefined
) {
  console.log("moveBoxesFromDonorToRecipient");
  // The change in the food boxes can occur multiple times in the multiple updates in the same state.
  // We dont take into account newly created delivery because process doesn't allow to create food delivery with alredy filled in boxes.
  // TODO: This doesn't take into account that donor removed all food boxes from the delivery.
  if (
    newValue.state === "OFFERED" &&
        newValue.foodBoxes.length > 0 &&
        oldValue != null
  ) {
    console.log("moveBoxesFromDonorToRecipient - updateEntityPairs");

    const diffArray: { [foodBoxId: string]: number } = {};

    newValue.foodBoxes.forEach((newBox: DeliveryFoodBox) => {
      if (newBox.foodBoxId == disposableBoxId) {
        return;
      }

      const matchingOldBox = oldValue.foodBoxes.find(
        (oldBox: DeliveryFoodBox) => oldBox.foodBoxId === newBox.foodBoxId
      );

      if (matchingOldBox && newBox.count !== matchingOldBox.count) {
        // Found old box with changed count
        const countDiff = newBox.count - matchingOldBox.count;
        diffArray[newBox.foodBoxId] = countDiff;
      } else if (!matchingOldBox) {
        // New box added
        diffArray[newBox.foodBoxId] = newBox.count;
      }
    });

    updateEntityPairs(diffArray, newValue);
  } else {
    console.log("moveBoxesFromDonorToRecipient - no action");
  }
}

/**
 * Moves food boxes from recipient to donor based on the changes in the provided values.
 *
 * @param {admin.firestore.DocumentData} newValue - The new value of the document.
 * @param {admin.firestore.DocumentData} oldValue - The previous value of the document.
 */
function moveBoxesFromRecipientToDonor(
  newValue: admin.firestore.DocumentData,
  oldValue: admin.firestore.DocumentData | undefined
) {
  console.log("moveBoxesFromRecipientToDonor");

  // Takes into account create and update actions
  if (newValue.foodBoxes.length > 0) {
    console.log("moveBoxesFromRecipientToDonor - updateEntityPairs");

    const diffArray: { [foodBoxId: string]: number } = {};

    newValue.foodBoxes.forEach((newBox: DeliveryFoodBox) => {
      if (newBox.foodBoxId == disposableBoxId) {
        return;
      }

      const matchingOldBox = oldValue?.foodBoxes.find(
        (oldBox: DeliveryFoodBox) => oldBox.foodBoxId === newBox.foodBoxId
      );

      if (matchingOldBox && newBox.count !== matchingOldBox.count) {
        // Found old box with changed count, its minus because we are moving boxes from recipient to donor
        const countDiff = newBox.count - matchingOldBox.count;
        diffArray[newBox.foodBoxId] = -countDiff;
      } else if (!matchingOldBox) {
        // New box added
        diffArray[newBox.foodBoxId] = -newBox.count;
      }
    });

    updateEntityPairs(diffArray, newValue);
  } else {
    console.log("moveBoxesFromRecipientToDonor - no action");
  }
}

/**
 * Updates the entity pairs by modifying the food box counts based on the provided diff array.
 * @param {admin.firestore.DocumentData} diffArray - An object representing the changes to be made to the food box counts.
 * @param {admin.firestore.DocumentData} newValue - The new value containing recipientId and donorId.
 * @return {Promise} A Promise that resolves to the updated entity pair document.
 */
function updateEntityPairs(
  diffArray: { [foodBoxId: string]: number },
  newValue: admin.firestore.DocumentData
) {
  console.log("updateEntityPairs" + diffArray);

  const recipientId = newValue.recipientId;
  const donorId = newValue.donorId;

  return db
    .collection("entityPairs")
    .where("recipientId", "==", recipientId)
    .where("donorId", "==", donorId)
    .get()
    .then((result) => {
      if (result.empty) {
        console.error(
          "EntityPair not found for recipientId:",
          recipientId,
          " and donorId:",
          donorId
        );
        return;
      }

      const entityPairDoc = result.docs[0];
      const foodBoxes = entityPairDoc.data().foodboxes;

      Object.keys(diffArray).forEach((foodBoxId: string) => {
        const foodBox = foodBoxes.find(
          (box: FoodBox) => box.foodBoxId === foodBoxId
        );

        if (foodBox) {
          foodBox.donorCount -= diffArray[foodBoxId];
          foodBox.recipientCount += diffArray[foodBoxId];
        } else {
          // TODO: Should we add the new type of food box to the entityPair?
          console.error("FoodBox not found for foodBoxId:", foodBoxId);
        }
      });

      return entityPairDoc.ref.update({
        foodboxes: foodBoxes,
      });
    });
}

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
