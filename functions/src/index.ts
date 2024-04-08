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

    console.log("Catched change");

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

      if (results[0].exists && results[1].exists) {
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
            console.log("Entity doc", entityDoc);

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

              console.log(messages);

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
  
// /**
//  * Is triggered when a document is created in the "offeredFood" collection.
//  * Logs a box movement from the canteen to the charity in the "boxMovement" collection.
//  *
//  * @param snapshot - The snapshot of the created document.
//  * @param context - The context object containing metadata about the create event.
//  */
// export const moveBoxesFromCanteenToCharity = functions.firestore.document("offeredFood/{id}").onCreate(async (snapshot, context) => {
//   const data = snapshot.data();
//   const donorId = data.donorId;
//   const recipientId = data.recipientId;
//   const boxType = data.boxType;
//   const numberOfBoxes = data.numberOfBoxes;
//   const weekNumber = data.weekNumber;
//   const date = data.date;

//   if (boxType == "jednorázový obal") {
//     return;
//   }

//   const boxMovementData = {
//     senderId: donorId,
//     recipientId: recipientId,
//     boxType: boxType,
//     numberOfBoxes: numberOfBoxes,
//     weekNumber: weekNumber,
//     date: date,
//   };

//   try {
//     const docRef = await db.collection("boxMovement").add(boxMovementData);
//     console.log("New box movement document added with ID:", docRef.id);
//     return null;
//   } catch (error) {
//     console.error("Error creating box movement document:", error);
//     return null;
//   }
// });

// /**
//  * Is triggered when a document is created in the "boxMovement" collection.
//  * Updates box quantities in the "boxes" collection based on the box movement.
//  *
//  * @param snapshot - The snapshot of the created document.
//  * @param context - The context object containing metadata about the create event.
//  */
// export const updateBoxQuantitiesOnBoxMovement = functions.firestore
//   .document("boxMovement/{id}")
//   .onCreate(async (snapshot, context) => {
//     const data = snapshot.data();
//     const senderId = data.senderId;
//     const recipientId = data.recipientId;
//     const boxType = data.boxType;
//     const numberOfBoxes = data.numberOfBoxes;

//     const canteenQuery = db.collection("boxes")
//       .where("canteenId", "==", senderId)
//       .where("charityId", "==", recipientId)
//       .where("boxType", "==", boxType);

//     const charityQuery = db.collection("boxes")
//       .where("charityId", "==", senderId)
//       .where("canteenId", "==", recipientId)
//       .where("boxType", "==", boxType);

//     try {
//       await db.runTransaction(async (transaction) => {
//         const canteenSnapshot = await transaction.get(canteenQuery);
//         const charitySnapshot = await transaction.get(charityQuery);

//         if (!canteenSnapshot.empty) {
//           const canteenDocRef = canteenSnapshot.docs[0].ref;
//           const canteenData = canteenSnapshot.docs[0].data();

//           const updatedCanteenQuantity = canteenData.quantityAtCanteen - numberOfBoxes;
//           const updatedCharityQuantity = canteenData.quantityAtCharity + numberOfBoxes;

//           transaction.update(canteenDocRef, {
//             quantityAtCanteen: updatedCanteenQuantity,
//             quantityAtCharity: updatedCharityQuantity,
//           });
//         } else if (!charitySnapshot.empty) {
//           const charityDocRef = charitySnapshot.docs[0].ref;
//           const charityData = charitySnapshot.docs[0].data();

//           const updatedCanteenQuantity = charityData.quantityAtCanteen + numberOfBoxes;
//           const updatedCharityQuantity = charityData.quantityAtCharity - numberOfBoxes;

//           transaction.update(charityDocRef, {
//             quantityAtCanteen: updatedCanteenQuantity,
//             quantityAtCharity: updatedCharityQuantity,
//           });
//         } else {
//           console.error("Matching box not found for update.");
//         }
//       });

//       console.log("Box quantities updated successfully in the \"boxes\" collection.");
//       return null;
//     } catch (error) {
//       console.error("Error updating box quantities in \"boxes\" collection:", error);
//       return null;
//     }
//   });

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
