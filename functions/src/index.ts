/* eslint-disable max-len */
import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

export const setDonorRole = functions.firestore.document("darci/{id}").onUpdate((donor, cont) => {
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

export const setRecipientRole = functions.firestore.document("prijemci/{id}").onUpdate((recipient, cont) => {
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
