// Deploy functions: firebase deploy --only functions
/* eslint-disable max-len */
import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

const db = admin.firestore();

export const setCanteenRole = functions.firestore.document("canteens/{id}").onUpdate((canteen, context) => {
  const uid = canteen.after.data().authUid;

  if (!uid) {
    return;
  }

  try {
    admin.auth().setCustomUserClaims(uid, {
      canteen: true,
    });

    console.log(`Custom claim set for user with UID: ${uid}`);
  } catch (error) {
    console.error("Error setting custom claim:", error);
  }
});

export const setCharityRole = functions.firestore.document("charities/{id}").onUpdate((charity, context) => {
  const uid = charity.after.data().authUid;

  if (!uid) {
    return;
  }

  try {
    admin.auth().setCustomUserClaims(uid, {
      charity: true,
    });

    console.log(`Custom claim set for user with UID: ${uid}`);
  } catch (error) {
    console.error("Error setting custom claim:", error);
  }
});

export const notifyCharityAboutDonation = functions.firestore
  .document("deliveries/{id}")
  .onUpdate((change, context) => {
    const newValue = change.after.data();
    const previousValue = change.before.data();

    if (newValue.state === "Potvrzeno" && newValue.state !== previousValue.state && isToday(newValue.pickUpFrom.toDate())) {
      const recipientId = newValue.recipientId;

      return admin.firestore().collection("fCMTokens").doc(recipientId).get()
        .then((tokenDoc) => {
          if (tokenDoc.exists) {
            const fcmToken = tokenDoc.data()?.token;

            const message = {
              notification: {
                title: "Delivery Confirmed",
                body: "Your delivery has been confirmed!",
              },
              token: fcmToken,
            };

            return admin.messaging().send(message);
          } else {
            console.log("FCM token not found for recipient:", recipientId);
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

export const moveBoxesFromCharityToCanteen = functions.firestore.document("shippingOfBoxes/{id}").onCreate(async (snapshot, context) => {
  const now = new Date();

  const data = snapshot.data();
  const donorId = data.charityId;
  const recipientId = data.canteenId;
  const boxType = data.boxType;
  const numberOfBoxes = data.numberOfBoxes;
  const weekNumber = `${now.getFullYear()}-${getCurrentWeekNumber()}`;
  const date = now;

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

export const updateBoxQuantitiesOnBoxMovement = functions.firestore
  .document("boxMovement/{id}")
  .onCreate(async (snapshot, context) => {
    const data = snapshot.data();
    const senderId = data.senderId;
    const recipientId = data.recipientId;
    const boxType = data.boxType;
    const numberOfBoxes = data.numberOfBoxes;

    const boxesQuery = db.collection("boxes")
      .where("canteenId", "==", senderId)
      .where("charityId", "==", recipientId)
      .where("boxType", "==", boxType);

    try {
      await db.runTransaction((transaction) => {
        return transaction.get(boxesQuery)
          .then((querySnapshot) => {
            if (!querySnapshot.empty) {
              const boxDocRef = querySnapshot.docs[0].ref;
              const boxData = querySnapshot.docs[0].data();

              const updatedCanteenQuantity = boxData.quantityAtCanteen - numberOfBoxes;

              const updatedCharityQuantity = boxData.quantityAtCharity + numberOfBoxes;

              transaction.update(boxDocRef, {
                quantityAtCanteen: updatedCanteenQuantity,
                quantityAtCharity: updatedCharityQuantity,
              });
            } else {
              console.error("Matching box not found for update.");
            }
            return null;
          });
      });
      console.log("Box quantities updated successfully in the \"boxes\" collection.");
      return null;
    } catch (error) {
      console.error("Error updating box quantities in \"boxes\" collection:", error);
      return null;
    }
  });

// eslint-disable-next-line require-jsdoc
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

// eslint-disable-next-line require-jsdoc
/** Returns current week number.
 * @return {number} - Current week number.
 */
function getCurrentWeekNumber(): number {
  const now = new Date();
  const from = new Date(now.getFullYear(), 0, 1);
  const to = new Date(now.getFullYear(), now.getMonth(), now.getDate());

  return Math.ceil((to.getTime() - from.getTime()) / (7 * 24 * 60 * 60 * 1000));
}
