import { onSchedule } from "firebase-functions/v2/scheduler";
import { logger } from "firebase-functions/v2";
import { DateTime } from "luxon";
import { getDeliveriesByDateAndStates, updateDeliveryState } from "../services/deliveryService";
import { syncDonationsToSheet } from "./syncDonationsToSheetFunction";
import { sheetsServiceAccountKey } from "../config/firebase";
import { TIMEZONE } from "../config/constants";

/**
 * Core logic for finalizing deliveries at end of day.
 * @param {Date} date - Date to finalize (defaults to today)
 * @return {Promise<void>}
 */
export async function finalizeDeliveries(date?: Date): Promise<void> {
  const targetDate = date ?? DateTime.now().setZone(TIMEZONE).minus({ days: 1 }).toJSDate();

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
  if (notUsedCount > 0) {
    logger.warn(
      `finalizeDeliveries: safety net activated for ${notUsedCount} PREPARED deliveries — Cloud Tasks may have failed`,
    );
  }

  // Pass 3: Warning — ACCEPTED past delivery window end (donor accepted too late)
  const now = new Date();
  const midDeliveryStates = await getDeliveriesByDateAndStates(targetDate, ["ACCEPTED", "ON_WAY_TO_PICK_UP", "IN_DELIVERY"]);
  const stuckMidDeliveryStates = midDeliveryStates.filter(
    (d) => d.deliveryTimeWindow && d.deliveryTimeWindow.end.toDate() < now,
  );

  if (stuckMidDeliveryStates.length > 0) {
    logger.warn(
      `finalizeDeliveries: ${stuckMidDeliveryStates.length} ACCEPTED, ON_WAY_TO_PICK_UP, IN_DELIVERY deliveries past delivery window end — human review needed. IDs: ${stuckMidDeliveryStates.map((d) => d.ref.id).join(", ")}`,
    );
  }

  logger.info(
    `finalizeDeliveries: complete — DONE: ${doneCount}, NOT_USED (safety net): ${notUsedCount}, stuck mid delivery: ${stuckMidDeliveryStates.length}`,
  );
}

/**
 * Scheduled function that runs at midnight Prague time daily.
 * Transitions DELIVERED → DONE and catches stuck states as safety net.
 * Then syncs the finalized day's donations to the Google Sheet.
 */
export const finalizeDeliveriesFunction = onSchedule(
  {
    schedule: "0 0 * * *",
    timeZone: TIMEZONE,
    secrets: [sheetsServiceAccountKey],
    timeoutSeconds: 300,
  },
  async () => {
    await finalizeDeliveries();

    // Runs on the just-finalized deliveries. A Sheets failure must not fail
    // the run, finalize has already succeeded.
    try {
      await syncDonationsToSheet();
    } catch (error) {
      logger.error("finalizeDeliveriesFunction: donation sheet sync failed", error);
    }
  },
);
