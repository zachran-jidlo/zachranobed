import { CloudTasksClient } from "@google-cloud/tasks";
import { cloudTasksQueue, cloudTasksLocation } from "../config/firebase";
import { DeliveryState } from "../models";
import { logger } from "firebase-functions/v2";

export interface ScheduleTransitionParams {
  deliveryId: string;
  targetState: DeliveryState;
  preconditionState: DeliveryState;
  executeAt: Date;
}

const client = new CloudTasksClient();

/**
 * Schedule a single delivery state transition via Cloud Tasks.
 * @param {ScheduleTransitionParams} params - Transition parameters
 * @return {Promise<string>} - Cloud Task name
 */
export async function scheduleStateTransition(
  params: ScheduleTransitionParams,
): Promise<string> {
  const project = process.env.GCLOUD_PROJECT;
  const location = cloudTasksLocation.value();
  const queue = cloudTasksQueue.value();
  const handlerUrl = `https://${location}-${project}.cloudfunctions.net/cloudTaskHandler`;

  const parent = client.queuePath(project!, location, queue);

  const payload = JSON.stringify({
    deliveryId: params.deliveryId,
    targetState: params.targetState,
    preconditionState: params.preconditionState,
  });

  const [response] = await client.createTask({
    parent,
    task: {
      httpRequest: {
        httpMethod: "POST",
        url: handlerUrl,
        headers: { "Content-Type": "application/json" },
        body: Buffer.from(payload).toString("base64"),
        oidcToken: {
          serviceAccountEmail: process.env.FUNCTION_TARGET_SA ?? "",
          audience: handlerUrl,
        },
      },
      scheduleTime: {
        seconds: Math.floor(params.executeAt.getTime() / 1000),
      },
    },
  });

  const taskName = response.name ?? "unknown";
  logger.info(
    `Scheduled Cloud Task: ${taskName} | delivery=${params.deliveryId} target=${params.targetState} at=${params.executeAt.toISOString()}`,
  );
  return taskName;
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
