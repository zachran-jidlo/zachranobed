// Deploy functions: firebase deploy --only functions
/* eslint-disable max-len */
import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

const db = admin.firestore();

/**
 * Is triggered when a document in the "deliveries" collection is updated.
 * Notifies the charity about a donation when the delivery is confirmed for today.
 *
 * @param change - The updated delivery document snapshot.
 * @param context - The context object containing metadata about the update event.
 * @returns A promise that resolves when the notification is sent, or null if conditions are not met.
 */
export const notifyCharityAboutDonation = functions.firestore
  .document("deliveries/{id}")
  .onUpdate((change, context) => {
    const newValue = change.after.data();
    const previousValue = change.before.data();

    if (newValue.state === "Potvrzeno" && newValue.state !== previousValue.state && isToday(newValue.pickUpFrom.toDate())) {
      const charityId = newValue.recipientId;

      return admin.firestore().collection("fCMTokens").doc(charityId).get()
        .then((tokenDoc) => {
          if (tokenDoc.exists) {
            const fcmToken = tokenDoc.data()?.token;

            const message = {
              notification: {
                title: "Potvrzení doručování",
                body: "Dnes vám budou doručovány darované pokrmy.",
              },
              token: fcmToken,
            };

            return admin.messaging().send(message);
          } else {
            console.log("FCM token not found for recipient:", charityId);
            return null;
          }
        })
        .catch((error) => {
          console.error("Error sending push notification:", error);
          return null;
        });
    }

    return null;
  });

/**
 * Is triggereed when a document in the "boxes" collection is updated.
 * Notifies the charity when the quantity of a certain box type at the canteen is below 10.
 *
 * @param change - The updated box document snapshot.
 * @param context - The context object containing metadata about the update event.
 * @returns A promise that resolves when the notification is sent, or null if conditions are not met.
 */
export const notifyCharityAboutLackOfBoxesAtCanteen = functions.firestore
  .document("boxes/{id}")
  .onUpdate((change, context) => {
    const data = change.after.data();
    const numberOfBoxes = data.quantityAtCanteen;
    const charityId = data.charityId;
    const boxType = data.boxType;

    if (numberOfBoxes < 10) {
      return admin.firestore().collection("fCMTokens").doc(charityId).get()
        .then((tokenDoc) => {
          if (tokenDoc.exists) {
            const fcmToken = tokenDoc.data()?.token;

            const message = {
              notification: {
                title: "Jídelně docházejí krabičky",
                body: `Objednejte prosím svoz krabiček typu "${boxType}" do jídelny`,
              },
              token: fcmToken,
            };

            return admin.messaging().send(message);
          } else {
            console.log("FCM token not found for recipient:", charityId);
            return null;
          }
        })
        .catch((error) => {
          console.error("Error sending push notification:", error);
          return null;
        });
    }

    return null;
  });

/**
 * Is triggered when a document is created in the "shippingOfBoxes" collection.
 * Notifies the canteen about the shipment of boxes.
 *
 * @param snapshot - The snapshot of the created document.
 * @param context - The context object containing metadata about the create event.
 * @returns A promise that resolves when the notification is sent, or null if conditions are not met.
 */
export const notifyCanteenAboutBoxShippment = functions.firestore
  .document("shippingOfBoxes/{id}")
  .onCreate((snapshot, context) => {
    const data = snapshot.data();
    const canteenId = data.canteenId;

    return admin.firestore().collection("fCMTokens").doc(canteenId).get()
      .then((tokenDoc) => {
        if (tokenDoc.exists) {
          const fcmToken = tokenDoc.data()?.token;

          const message = {
            notification: {
              title: "Potvrzení svozu krabiček",
              body: "Charita vám posílá krabičky.",
            },
            token: fcmToken,
          };

          return admin.messaging().send(message);
        } else {
          console.log("FCM token not found for recipient:", canteenId);
          return null;
        }
      })
      .catch((error) => {
        console.error("Error sending push notification:", error);
        return null;
      });
  });

/**
 * Is triggered when a document is created in the "offeredFood" collection.
 * Logs a box movement from the canteen to the charity in the "boxMovement" collection.
 *
 * @param snapshot - The snapshot of the created document.
 * @param context - The context object containing metadata about the create event.
 */
export const moveBoxesFromCanteenToCharity = functions.firestore.document("offeredFood/{id}").onCreate(async (snapshot, context) => {
  const data = snapshot.data();
  const donorId = data.donorId;
  const recipientId = data.recipientId;
  const boxType = data.boxType;
  const numberOfBoxes = data.numberOfBoxes;
  const weekNumber = data.weekNumber;
  const date = data.date;

  if (boxType == "jednorázový obal") {
    return;
  }

  const boxMovementData = {
    senderId: donorId,
    recipientId: recipientId,
    boxType: boxType,
    numberOfBoxes: numberOfBoxes,
    weekNumber: weekNumber,
    date: date,
  };

  try {
    const docRef = await db.collection("boxMovement").add(boxMovementData);
    console.log("New box movement document added with ID:", docRef.id);
    return null;
  } catch (error) {
    console.error("Error creating box movement document:", error);
    return null;
  }
});

/**
 * Is triggered when a document is created in the "boxMovement" collection.
 * Updates box quantities in the "boxes" collection based on the box movement.
 *
 * @param snapshot - The snapshot of the created document.
 * @param context - The context object containing metadata about the create event.
 */
export const updateBoxQuantitiesOnBoxMovement = functions.firestore
  .document("boxMovement/{id}")
  .onCreate(async (snapshot, context) => {
    const data = snapshot.data();
    const senderId = data.senderId;
    const recipientId = data.recipientId;
    const boxType = data.boxType;
    const numberOfBoxes = data.numberOfBoxes;

    const canteenQuery = db.collection("boxes")
      .where("canteenId", "==", senderId)
      .where("charityId", "==", recipientId)
      .where("boxType", "==", boxType);

    const charityQuery = db.collection("boxes")
      .where("charityId", "==", senderId)
      .where("canteenId", "==", recipientId)
      .where("boxType", "==", boxType);

    try {
      await db.runTransaction(async (transaction) => {
        const canteenSnapshot = await transaction.get(canteenQuery);
        const charitySnapshot = await transaction.get(charityQuery);

        if (!canteenSnapshot.empty) {
          const canteenDocRef = canteenSnapshot.docs[0].ref;
          const canteenData = canteenSnapshot.docs[0].data();

          const updatedCanteenQuantity = canteenData.quantityAtCanteen - numberOfBoxes;
          const updatedCharityQuantity = canteenData.quantityAtCharity + numberOfBoxes;

          transaction.update(canteenDocRef, {
            quantityAtCanteen: updatedCanteenQuantity,
            quantityAtCharity: updatedCharityQuantity,
          });
        } else if (!charitySnapshot.empty) {
          const charityDocRef = charitySnapshot.docs[0].ref;
          const charityData = charitySnapshot.docs[0].data();

          const updatedCanteenQuantity = charityData.quantityAtCanteen + numberOfBoxes;
          const updatedCharityQuantity = charityData.quantityAtCharity - numberOfBoxes;

          transaction.update(charityDocRef, {
            quantityAtCanteen: updatedCanteenQuantity,
            quantityAtCharity: updatedCharityQuantity,
          });
        } else {
          console.error("Matching box not found for update.");
        }
      });

      console.log("Box quantities updated successfully in the \"boxes\" collection.");
      return null;
    } catch (error) {
      console.error("Error updating box quantities in \"boxes\" collection:", error);
      return null;
    }
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
