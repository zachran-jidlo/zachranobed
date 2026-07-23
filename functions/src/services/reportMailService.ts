import { Timestamp } from "firebase-admin/firestore";
import { logger } from "firebase-functions/v2";
import { db } from "../config/firebase";
import { ReportMailPayload } from "./reportService";

const MAILS_COLLECTION = "mails";

/**
 * Write one mails document. The Trigger Email extension picks it up, sends
 * it, and tracks the result in the delivery field. The reportRunId tag is
 * ignored by the extension and only used to find this run's mails later.
 * @return {Promise<string>} The new mails document id.
 */
export async function writeReportMail(
  runId: string,
  payload: ReportMailPayload,
): Promise<string> {
  const ref = await db.collection(MAILS_COLLECTION).add({
    createdAt: Timestamp.now(),
    to: payload.to,
    message: payload.message,
    reportRunId: runId,
  });
  logger.info(
    `reportMail: wrote mail ${ref.id} run=${runId} to=${payload.to.join(",")}`,
  );
  return ref.id;
}

/**
 * Trigger a resend of an existing mail by moving it back to RETRY. The
 * extension then sends it again and bumps delivery.attempts.
 * @return {Promise<void>}
 */
export async function retryReportMail(mailId: string): Promise<void> {
  await db
    .collection(MAILS_COLLECTION)
    .doc(mailId)
    .update({ "delivery.state": "RETRY" });
  logger.info(`reportMail: moved mail ${mailId} to RETRY`);
}

/**
 * Find the ids of this run's report emails whose delivery has not reached
 * SUCCESS. The extension retries a few times on its own, so after the wait
 * the state is settled and anything other than SUCCESS counts as a failure.
 * @return {Promise<string[]>} Ids of the failed mails.
 */
export async function findReportMailFailures(
  runId: string,
): Promise<string[]> {
  const snapshot = await db
    .collection(MAILS_COLLECTION)
    .where("reportRunId", "==", runId)
    .get();

  return snapshot.docs
    .filter((doc) => doc.data().delivery?.state !== "SUCCESS")
    .map((doc) => doc.id);
}
