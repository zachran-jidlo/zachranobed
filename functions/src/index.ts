// Deploy functions: firebase deploy --only functions
/* eslint-disable max-len */
import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

const db = admin.firestore();

class FoodBox {
  constructor(
    public foodBoxId: string,
    public count: number,
    public donorCount: number,
    public recipientCount: number
  ) {}
}

class DeliveryFoodBox {
  constructor(
    public foodBoxId: string,
    public count: number
  ) {}
}

const disposableBoxId = "disposable"

/**
 * Function triggered when a document in the "deliveries" collection is updated.
 * Notifies the charity about a donation if the delivery state is "ACCEPTED" and it's the current day.
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
      var insufficentBoxes: string[] = [];

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
   * Is triggered when a document is created in the "shippingOfBoxes" collection.
   * Notifies the canteen about the shipment of boxes.
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
            return null;
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
