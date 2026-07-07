import { logger } from "firebase-functions/v2";
import { DateTime } from "luxon";
import { buildReport } from "../services/reportService";
import {
  DonationCount,
  getSheetsClient,
  upsertDailyDonations,
} from "../services/sheetsService";
import { clearEntityCache, getEntities } from "../services/entityService";
import {
  donationsSheetId,
  donationsSheetTab,
  sheetsServiceAccountKey,
} from "../config/firebase";
import { TIMEZONE } from "../config/constants";

export interface SyncDonationsStats {
  date: string;
  donorsWithDonations: number;
  cellsWritten: number;
  missingColumns: number;
}

/**
 * Sum a day's donated meals per donor and write them to the donations sheet.
 *
 * Reuses the monthly report's aggregation so the sheet totals match the CSV
 * report exactly. Meant to run right after finalizeDeliveries, since buildReport
 * only counts DONE and IN_DELIVERY deliveries.
 *
 * @param {Date} date - Day to sync. Defaults to yesterday in Prague time.
 * @return {Promise<SyncDonationsStats>} What was written.
 */
export async function syncDonationsToSheet(
  date?: Date,
): Promise<SyncDonationsStats> {
  const day = date ?
    DateTime.fromJSDate(date).setZone(TIMEZONE).startOf("day") :
    DateTime.now().setZone(TIMEZONE).minus({ days: 1 }).startOf("day");
  const dateIso = day.toISODate() ?? "";

  logger.info(`syncDonationsToSheet: syncing ${dateIso}`);

  try {
    const entities = await getEntities();
    const donorById = new Map(
      entities
        .filter((e) => e.entityType === "DONOR")
        .map((e) => [e.id, e]),
    );

    const rows = await buildReport(
      day.toJSDate(),
      day.plus({ days: 1 }).toJSDate(),
      entities,
    );

    // Sum donated meals per donor for the day.
    const counts = new Map<string, DonationCount>();
    for (const row of rows) {
      const donor = donorById.get(row.donorId);
      if (!donor) {
        continue;
      }
      const existing = counts.get(row.donorId);
      if (existing) {
        existing.count += row.mealCount;
      } else {
        counts.set(row.donorId, {
          name: donor.establishmentName,
          count: row.mealCount,
        });
      }
    }

    logger.info(
      `syncDonationsToSheet: ${counts.size} donors with donations on ${dateIso}`,
    );

    const client = getSheetsClient(sheetsServiceAccountKey.value());
    const result = await upsertDailyDonations(
      client,
      donationsSheetId.value(),
      donationsSheetTab.value(),
      dateIso,
      counts,
    );

    logger.info(
      `syncDonationsToSheet: complete for ${dateIso} — ` +
        `written: ${result.written}, missing columns: ${result.missingColumns}, ` +
        `row appended: ${result.rowAppended}`,
    );

    return {
      date: dateIso,
      donorsWithDonations: counts.size,
      cellsWritten: result.written,
      missingColumns: result.missingColumns,
    };
  } finally {
    clearEntityCache();
  }
}
