import * as admin from "firebase-admin";
import { FieldValue } from "firebase-admin/firestore";
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
  recipientId?: string,
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
      timestamp: FieldValue.serverTimestamp(),
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
 * FCM error codes that mean a token is permanently unusable and should be
 * removed. Any other failure (for example server-unavailable or internal-error)
 * is transient. Removing tokens on transient failures would wrongly delete
 * valid devices during an FCM outage, so those are kept and retried next time.
 */
const PERMANENT_TOKEN_ERROR_CODES = new Set([
  // App was uninstalled or the token expired and is no longer registered.
  "messaging/registration-token-not-registered",
  // Token is malformed and could never have been valid.
  "messaging/invalid-registration-token",
  // Token belongs to a different Firebase project than this server's credentials.
  "messaging/mismatched-credential",
  // Token was issued for a different FCM sender ID than this project's.
  "messaging/sender-id-mismatch",
]);

/**
 * Removes invalid FCM tokens from an entity's fcmTokens object.
 *
 * Only tokens that failed with a permanent error are removed. Transient
 * failures are logged but kept, so a temporary FCM outage does not purge
 * valid tokens.
 */
async function cleanupInvalidTokens(
  entityId: string,
  tokens: { [key: string]: string },
  results: admin.messaging.SendResponse[],
): Promise<void> {
  const invalidTokens: string[] = [];

  results.forEach((result, index) => {
    if (result.success) {
      return;
    }

    const code = result.error?.code ?? "unknown";
    const message = result.error?.message ?? "no message";
    const token = Object.values(tokens)[index];
    const isPermanent = PERMANENT_TOKEN_ERROR_CODES.has(code);

    console.warn(
      `Entity ${entityId}: send failed for token ${token ?? "unknown"} ` +
        `(${isPermanent ? "permanent, removing" : "transient, kept"}). ` +
        `Code: ${code}. Message: ${message}`,
    );

    if (isPermanent && token) {
      invalidTokens.push(token);
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
      `Removed ${invalidTokens.length} invalid tokens from entity ${entityId}`,
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
  recipientId?: string,
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

  console.info(`Entity ${entityId}: generated ${messages.length} push notification messages.`);
  if (messages.length === 0) {
    console.info(`Entity ${entityId}: no tokens, nothing sent.`);
    return;
  }

  const response = await admin.messaging().sendEach(messages);

  console.info(
    `Entity ${entityId}: sent ${response.successCount} push messages, ${response.failureCount} failed.`,
  );

  await cleanupInvalidTokens(entityId, fcmTokens, response.responses);
}
