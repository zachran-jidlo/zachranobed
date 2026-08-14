import { logger } from "firebase-functions/v2";
import { DateTime } from "luxon";
import {
  SheetValue,
  appendRows,
  getSheetsClient,
  readColumn,
  safeSheetText,
} from "../services/sheetsService";
import { getDeliveriesByDateAndStates } from "../services/deliveryService";
import { clearEntityCache, getEntities } from "../services/entityService";
import { deliveriesSheetId, deliveriesSheetTab } from "../config/firebase";
import { TIMEZONE } from "../config/constants";
import { Delivery, Entity } from "../models";

/** Column holding the delivery id, which is what makes the sync idempotent. */
const ID_COLUMN = "B";

/** One meal entry embedded in a delivery. Both counts are mutually exclusive. */
interface MealInDelivery {
  count?: number | null;
  packagesCount?: number | null;
}

export interface SyncDeliveriesStats {
  date: string;
  deliveries: number;
  appended: number;
  skipped: number;
}

/**
 * Mirror one day of completed deliveries into the report sheet, one row per
 * delivery.
 *
 * Append-only and keyed on the delivery id, so re-running a date adds nothing.
 * A delivery edited after its row was written keeps the old row, rows are a
 * snapshot taken at finalize time rather than a live mirror.
 *
 * The tab is expected to already have its header row. Column order here has to
 * match it, nothing validates that.
 *
 * @param {Date} date - The day to sync.
 * @return {Promise<SyncDeliveriesStats>} What was written.
 */
export async function syncDeliveriesToSheet(
  date: Date,
): Promise<SyncDeliveriesStats> {
  const dateIso = DateTime.fromJSDate(date).setZone(TIMEZONE).toISODate() ?? "";
  const empty: SyncDeliveriesStats = {
    date: dateIso,
    deliveries: 0,
    appended: 0,
    skipped: 0,
  };

  const spreadsheetId = deliveriesSheetId.value();
  if (!spreadsheetId) {
    logger.warn(
      "syncDeliveriesToSheet: DELIVERIES_SHEET_ID is not set — skipped",
    );
    return empty;
  }
  const tab = deliveriesSheetTab.value();

  logger.info(`syncDeliveriesToSheet: syncing ${dateIso}`);

  try {
    const deliveries = (
      await getDeliveriesByDateAndStates(date, ["DONE"])
    ).filter((delivery) => delivery.type === "FOOD_DELIVERY");

    if (deliveries.length === 0) {
      logger.info(`syncDeliveriesToSheet: no deliveries on ${dateIso}`);
      return empty;
    }

    const entityById = new Map(
      (await getEntities()).map((entity) => [entity.id, entity]),
    );

    const rows = deliveries
      .map((delivery) => toRow(delivery, entityById))
      .sort(compareRows);

    const client = getSheetsClient();
    const idColumn = await readColumn(client, spreadsheetId, tab, ID_COLUMN);
    const knownIds = new Set(idColumn.filter((id) => id));

    const toAppend: SheetValue[][] = [];
    let skipped = 0;
    for (const row of rows) {
      if (knownIds.has(row.deliveryId)) {
        skipped++;
        continue;
      }
      toAppend.push(toSheetValues(row));
    }

    await appendRows(client, spreadsheetId, tab, toAppend);

    const appended = rows.length - skipped;
    logger.info(
      `syncDeliveriesToSheet: complete for ${dateIso} — deliveries: ${rows.length}, appended: ${appended}, skipped: ${skipped}`,
    );

    return {
      date: dateIso,
      deliveries: rows.length,
      appended,
      skipped,
    };
  } finally {
    clearEntityCache();
  }
}

/** One sheet row, before it is flattened into cells. */
interface DeliveryRow {
  date: string;
  deliveryId: string;
  donorId: string;
  recipientId: string;
  donorName: string;
  donorOrganization: string;
  donorCity: string;
  recipientName: string;
  carrierId: string;
  portions: number;
  packages: number;
}

/**
 * Build a row from a delivery.
 *
 * A delivery that recorded no meals still gets a row, with zeros. It is real
 * information, and dropping it would make the sheet disagree with Firestore
 * about how many deliveries happened.
 */
function toRow(
  delivery: Delivery,
  entityById: Map<string, Entity>,
): DeliveryRow {
  const donor = entityById.get(delivery.donorId);
  const recipient = entityById.get(delivery.recipientId);
  const meals = (delivery.meals ?? []) as MealInDelivery[];

  return {
    date:
      DateTime.fromJSDate(delivery.deliveryDate.toDate())
        .setZone(TIMEZONE)
        .toISODate() ?? "",
    deliveryId: delivery.ref.id,
    donorId: delivery.donorId,
    recipientId: delivery.recipientId,
    donorName: donor?.establishmentName ?? "",
    donorOrganization: donor?.organization ?? "",
    donorCity: donor?.city ?? "",
    recipientName: recipient?.establishmentName ?? "",
    carrierId: delivery.carrierId ?? "",
    portions: sumCounts(meals, (meal) => meal.count),
    packages: sumCounts(meals, (meal) => meal.packagesCount),
  };
}

function toSheetValues(row: DeliveryRow): SheetValue[] {
  return [
    row.date,
    row.deliveryId,
    row.donorId,
    row.recipientId,
    safeSheetText(row.donorName),
    safeSheetText(row.donorOrganization),
    safeSheetText(row.donorCity),
    safeSheetText(row.recipientName),
    row.carrierId,
    row.portions,
    row.packages,
  ];
}

/** Sum one of the meal counters, ignoring entries that do not use it. */
function sumCounts(
  meals: MealInDelivery[],
  pick: (meal: MealInDelivery) => number | null | undefined,
): number {
  return meals.reduce((total, meal) => {
    const value = pick(meal);
    return typeof value === "number" && Number.isFinite(value) ? total + value : total;
  }, 0);
}

/** Deterministic order, so a re-run of the same day produces the same rows. */
function compareRows(a: DeliveryRow, b: DeliveryRow): number {
  return a.date === b.date ?
    a.deliveryId.localeCompare(b.deliveryId) :
    a.date.localeCompare(b.date);
}
