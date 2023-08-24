/* eslint-disable max-len */
import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

export const setDonorRole = functions.firestore.document("donors/{id}").onUpdate((donor, context) => {
  const uid = donor.after.data().authUid;

  if (!uid) {
    return;
  }

  try {
    admin.auth().setCustomUserClaims(uid, {
      donor: true,
    });

    console.log(`Custom claim set for user with UID: ${uid}`);
  } catch (error) {
    console.error("Error setting custom claim:", error);
  }
});

export const setRecipientRole = functions.firestore.document("prijemci/{id}").onUpdate((recipient, context) => {
  const uid = recipient.after.data().authUid;

  if (!uid) {
    return;
  }

  try {
    admin.auth().setCustomUserClaims(uid, {
      recipient: true,
    });

    console.log(`Custom claim set for user with UID: ${uid}`);
  } catch (error) {
    console.error("Error setting custom claim:", error);
  }
});

export const notifyRecipientAboutDonation = functions.firestore
  .document("rozvozy/{id}")
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
