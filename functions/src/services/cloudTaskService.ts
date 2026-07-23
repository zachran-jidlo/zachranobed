import { CloudTasksClient } from "@google-cloud/tasks";
import { cloudTasksQueue, cloudTasksLocation, currentServiceAccount } from "../config/firebase";
import { DeliveryState } from "../models";
import { ReportMailPayload } from "./reportService";
import { logger } from "firebase-functions/v2";

export interface ScheduleTransitionParams {
  deliveryId: string;
  targetState: DeliveryState;
  preconditionState: DeliveryState;
  executeAt: Date;
}

const client = new CloudTasksClient();

/**
 * Schedule an HTTP Cloud Task with a JSON payload.
 * @param {string} functionName - Cloud Function name to invoke
 * @param {Record<string, unknown>} payload - JSON payload
 * @param {Date} executeAt - When to execute
 * @param {string} logLabel - Label for log messages
 * @return {Promise<string>} - Cloud Task name
 */
async function scheduleCloudTask(
  functionName: string,
  payload: Record<string, unknown>,
  executeAt: Date,
  logLabel: string,
): Promise<string> {
  const project = process.env.GCLOUD_PROJECT;
  const location = cloudTasksLocation.value();
  const queue = cloudTasksQueue.value();
  const handlerUrl = `https://${location}-${project}.cloudfunctions.net/${functionName}`;

  const parent = client.queuePath(project!, location, queue);

  let response;
  try {
    [response] = await client.createTask({
      parent,
      task: {
        httpRequest: {
          httpMethod: "POST",
          url: handlerUrl,
          headers: { "Content-Type": "application/json" },
          body: Buffer.from(JSON.stringify(payload)).toString("base64"),
          oidcToken: {
            serviceAccountEmail: currentServiceAccount,
            audience: handlerUrl,
          },
        },
        scheduleTime: {
          seconds: Math.floor(executeAt.getTime() / 1000),
        },
      },
    });
  } catch (error) {
    const message = error instanceof Error ? error.message : String(error);
    logger.error(
      `Failed to schedule Cloud Task | ${logLabel} at=${executeAt.toISOString()} error=${message}`,
    );
    throw new Error(
      `Cloud Tasks API error (${logLabel}): ${message}`,
    );
  }

  const taskName = response.name ?? "unknown";
  logger.info(
    `Scheduled Cloud Task: ${taskName} | ${logLabel} at=${executeAt.toISOString()}`,
  );
  return taskName;
}

/**
 * Schedule a single delivery state transition via Cloud Tasks.
 * @param {ScheduleTransitionParams} params - Transition parameters
 * @return {Promise<string>} - Cloud Task name
 */
export async function scheduleStateTransition(
  params: ScheduleTransitionParams,
): Promise<string> {
  return scheduleCloudTask(
    "cloudTaskHandler",
    {
      deliveryId: params.deliveryId,
      targetState: params.targetState,
      preconditionState: params.preconditionState,
    },
    params.executeAt,
    `delivery=${params.deliveryId} target=${params.targetState}`,
  );
}

/**
 * Schedule multiple delivery state transitions at once.
 * @param {ScheduleTransitionParams[]} tasks - Array of transition params
 * @return {Promise<string[]>} - Array of Cloud Task names
 */
export async function scheduleMultipleTransitions(
  tasks: ScheduleTransitionParams[],
): Promise<string[]> {
  return Promise.all(tasks.map((t) => scheduleStateTransition(t)));
}

/**
 * Schedule a confirmation reminder notification via Cloud Tasks.
 * @param {string} deliveryId - Delivery identifier
 * @param {Date} executeAt - When to send the reminder
 * @return {Promise<string>} - Cloud Task name
 */
export async function scheduleConfirmationReminder(
  deliveryId: string,
  executeAt: Date,
): Promise<string> {
  return scheduleCloudTask(
    "confirmationReminderHandler",
    { deliveryId },
    executeAt,
    `confirmationReminder delivery=${deliveryId}`,
  );
}

/** A Date the given number of seconds from now. */
function inSeconds(seconds: number): Date {
  return new Date(Date.now() + seconds * 1000);
}

/**
 * Schedule the worker that writes one report email into the mails collection.
 * Callers stagger delaySeconds to pace the sends.
 * @param {string} runId - Report mail run identifier
 * @param {ReportMailPayload} payload - The mail to write
 * @param {number} delaySeconds - Seconds from now to write the mail
 * @return {Promise<string>} - Cloud Task name
 */
export async function scheduleReportMailSend(
  runId: string,
  payload: ReportMailPayload,
  delaySeconds: number,
): Promise<string> {
  return scheduleCloudTask(
    "reportMailSendHandler",
    { runId, to: payload.to, message: payload.message },
    inSeconds(delaySeconds),
    `reportMailSend run=${runId}`,
  );
}

/**
 * Schedule a paced resend of an existing failed report mail.
 * @param {string} mailId - The mails document to resend
 * @param {number} delaySeconds - Seconds from now to resend it
 * @return {Promise<string>} - Cloud Task name
 */
export async function scheduleReportMailRetry(
  mailId: string,
  delaySeconds: number,
): Promise<string> {
  return scheduleCloudTask(
    "reportMailSendHandler",
    { mailId },
    inSeconds(delaySeconds),
    `reportMailRetry mail=${mailId}`,
  );
}

/**
 * Schedule the sweep that retries the failed report emails of a run.
 * @param {string} runId - Report mail run identifier
 * @param {number} delaySeconds - Seconds from now to run the sweep
 * @return {Promise<string>} - Cloud Task name
 */
export async function scheduleReportMailSweep(
  runId: string,
  delaySeconds: number,
): Promise<string> {
  return scheduleCloudTask(
    "reportMailSweepHandler",
    { runId },
    inSeconds(delaySeconds),
    `reportMailSweep run=${runId}`,
  );
}
