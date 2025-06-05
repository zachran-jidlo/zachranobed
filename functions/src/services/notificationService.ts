import * as admin from "firebase-admin";
import { db } from "../config/firebase";

/**
 * Creates a notification document in the entities/{entityId}/notifications subcollection
 */
async function createNotification(
  entityId: string,
  title: string,
  message: string,
  type: string,
  donorId?: string,
  recipientId?: string
): Promise<void> {
  const notificationRef = db
    .collection("entities")
    .doc(entityId)
    .collection("notifications")
    .doc();

  await notificationRef
    .set({
      id: notificationRef.id,
      title,
      message,
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
      read: false,
      donorId: donorId || null,
      recipientId: recipientId || null,
      type,
    })
    .then(() => {
      console.info("Notification successfully saved!");
    })
    .catch((error) => {
      console.error("Error writing document: ", error);
    });
}

/**
 * Removes invalid FCM tokens from an entity's fcmTokens object
 */
async function cleanupInvalidTokens(
  entityId: string,
  tokens: { [key: string]: string },
  results: admin.messaging.SendResponse[]
): Promise<void> {
  const invalidTokens: string[] = [];

  results.forEach((result, index) => {
    if (!result.success) {
      const token = Object.values(tokens)[index];
      if (token) {
        invalidTokens.push(token);
      }
    }
  });

  if (invalidTokens.length > 0) {
    const entityRef = db.collection("entities").doc(entityId);
    const entity = await entityRef.get();
    const fcmTokens = entity.data()?.fcmTokens || {};

    // Remove invalid tokens
    invalidTokens.forEach((token) => {
      const key = Object.keys(fcmTokens).find((k) => fcmTokens[k] === token);
      if (key) {
        delete fcmTokens[key];
      }
    });

    // Update entity with cleaned tokens
    await entityRef.update({ fcmTokens });
    console.info(
      `Removed ${invalidTokens.length} invalid tokens from entity ${entityId}`
    );
  }
}

/**
 * Sends push notifications and handles token cleanup
 */
export async function sendNotificationsAndCleanup(
  entityId: string,
  fcmTokens: { [key: string]: string },
  title: string,
  body: string,
  type: string,
  donorId?: string,
  recipientId?: string
): Promise<void> {
  // Create notification document
  await createNotification(entityId, title, body, type, donorId, recipientId);

  // Create message for all tokens of given entity
  const messages = Object.values(fcmTokens).map((token) => {
    return {
      notification: {
        title: title,
        body: body,
      },
      token: token as string,
    };
  });

  console.log(messages);
  // TODO: There is a problem with messaging/mismatched-credential - token is from the app registered to diffrent Firebase project - DEV vs PROD.
  const response = await admin.messaging().sendEach(messages);
  console.info(
    "Successfully sent " + response?.successCount + " push messages."
  );

  if (response) {
    await cleanupInvalidTokens(entityId, fcmTokens, response.responses);
  }
}
