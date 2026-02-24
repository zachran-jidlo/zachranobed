import { onSchedule } from "firebase-functions/v2/scheduler";
import { logger } from "firebase-functions/v2";
import { DateTime } from "luxon";
import { getDeliveriesByDateAndStates, updateDeliveryState } from "../services/deliveryService";

/**
 * Core logic for finalizing deliveries at end of day.
 * @param {Date} date - Date to finalize (defaults to today)
 * @return {Promise<void>}
 */
export async function finalizeDeliveries(date?: Date): Promise<void> {
  const targetDate = date ?? DateTime.now().setZone("Europe/Prague").toJSDate();

  logger.info(`finalizeDeliveries: processing date ${targetDate.toISOString()}`);

  // Pass 1: DELIVERED → DONE
  const delivered = await getDeliveriesByDateAndStates(targetDate, ["DELIVERED"]);
  logger.info(`finalizeDeliveries: ${delivered.length} DELIVERED deliveries to finalize`);
  let doneCount = 0;

  for (const delivery of delivered) {
    await updateDeliveryState(delivery.ref, "DONE");
    doneCount++;
  }
  logger.info(`finalizeDeliveries: transitioned ${doneCount} deliveries DELIVERED → DONE`);

  // Pass 2: Safety net — PREPARED → NOT_USED (Cloud Task missed or never scheduled)
  const prepared = await getDeliveriesByDateAndStates(targetDate, ["PREPARED"]);
  logger.info(`finalizeDeliveries: ${prepared.length} stuck PREPARED deliveries`);
  let notUsedCount = 0;

  for (const delivery of prepared) {
    await updateDeliveryState(delivery.ref, "NOT_USED");
    notUsedCount++;
  }
  logger.info(`finalizeDeliveries: safety net transitioned ${notUsedCount} deliveries PREPARED → NOT_USED`);

  // Pass 3: Warning — ACCEPTED past delivery window end (donor accepted too late)
  const now = new Date();
  const accepted = await getDeliveriesByDateAndStates(targetDate, ["ACCEPTED"]);
  const stuckAccepted = accepted.filter(
    (d) => d.deliveryTimeWindow && d.deliveryTimeWindow.end.toDate() < now,
  );

  if (stuckAccepted.length > 0) {
    logger.warn(
      `finalizeDeliveries: ${stuckAccepted.length} ACCEPTED deliveries past delivery window end — human review needed. IDs: ${stuckAccepted.map((d) => d.ref.id).join(", ")}`,
    );
  }

  logger.info(
    `finalizeDeliveries: complete — DONE: ${doneCount}, NOT_USED (safety net): ${notUsedCount}, stuck ACCEPTED: ${stuckAccepted.length}`,
  );
}

/**
 * Scheduled function that runs at midnight Prague time daily.
 * Transitions DELIVERED → DONE and catches stuck states as safety net.
 */
export const finalizeDeliveriesFunction = onSchedule(
  {
    schedule: "0 0 * * *",
    timeZone: "Europe/Prague",
  },
  async () => {
    await finalizeDeliveries();
  },
);
