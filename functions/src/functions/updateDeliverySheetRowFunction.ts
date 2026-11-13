import { onDocumentUpdated } from "firebase-functions/v2/firestore";
import { logger } from "firebase-functions/v2";
import { DocumentData, DocumentSnapshot } from "firebase-admin/firestore";
import { getSheetsClient, readColumn, updateRow } from "../services/sheetsService";
import { clearEntityCache, getEntities } from "../services/entityService";
import { deliveriesSheetId, deliveriesSheetTab } from "../config/firebase";
import { Delivery, DeliverySchema, Entity } from "../models";
import { ID_COLUMN, DeliveryRow, toRow, toSheetValues } from "./syncDeliveriesToSheetFunction";

/** Used to compare rows by delivery fields only, without loading entities. */
const NO_ENTITIES = new Map<string, Entity>();

/**
 * Keep a delivery's sheet row in line with later edits, for example an admin
 * correcting meal counts in Rowy after the day was finalized.
 *
 * Only DONE to DONE updates count. The nightly finalize flips a whole day into
 * DONE, and those rows are written by syncDeliveriesToSheet in one batch.
 *
 * Only updates existing rows, never appends. An append here could race the
 * nightly sync and duplicate a row. A delivery without a row is skipped.
 *
 * maxInstances and concurrency are 1 so bulk edits in Rowy run one by one and
 * stay under the Sheets per-minute quota.
 */
export const updateDeliverySheetRow = onDocumentUpdated(
  {
    document: "deliveries/{id}",
    maxInstances: 1,
    concurrency: 1,
  },
  async (event) => {
    const before = event.data?.before;
    const after = event.data?.after;
    if (!before || !after || !isReported(before.data()) || !isReported(after.data())) {
      return;
    }

    const id = event.params.id;
    const beforeDelivery = parseDelivery(before);
    const afterDelivery = parseDelivery(after);
    if (!beforeDelivery || !afterDelivery) {
      logger.error(`updateDeliverySheetRow: invalid delivery document ${id}`);
      return;
    }

    // Rowy metadata and other triggers also write to DONE deliveries
    if (sameRow(toRow(beforeDelivery, NO_ENTITIES), toRow(afterDelivery, NO_ENTITIES))) {
      return;
    }

    const spreadsheetId = deliveriesSheetId.value();
    if (!spreadsheetId) {
      return;
    }

    // Events can arrive out of order. Write what the document holds now, not
    // what this event saw.
    const current = parseDelivery(await after.ref.get());
    if (!current || !isReported(current)) {
      logger.info(`updateDeliverySheetRow: ${id} is no longer a DONE food delivery, skipped`);
      return;
    }

    try {
      const client = getSheetsClient();
      const tab = deliveriesSheetTab.value();
      const ids = await readColumn(client, spreadsheetId, tab, ID_COLUMN);
      const index = ids.indexOf(id);
      if (index === -1) {
        logger.warn(`updateDeliverySheetRow: no row for ${id}, skipped`);
        return;
      }

      const entityById = new Map(
        (await getEntities()).map((entity) => [entity.id, entity]),
      );
      const rowNumber = index + 1;
      await updateRow(
        client,
        spreadsheetId,
        tab,
        rowNumber,
        toSheetValues(toRow(current, entityById)),
      );
      logger.info(`updateDeliverySheetRow: updated row ${rowNumber} for ${id}`);
    } catch (error) {
      logger.error(`updateDeliverySheetRow: failed to update row for ${id}`, error);
    } finally {
      clearEntityCache();
    }
  },
);

/** Whether the delivery belongs in the report sheet. */
function isReported(data: DocumentData | undefined): boolean {
  return data?.state === "DONE" && data?.type === "FOOD_DELIVERY";
}

function parseDelivery(snapshot: DocumentSnapshot): Delivery | undefined {
  const result = DeliverySchema.safeParse({ ref: snapshot.ref, ...snapshot.data() });
  return result.success ? result.data : undefined;
}

function sameRow(a: DeliveryRow, b: DeliveryRow): boolean {
  const aValues = toSheetValues(a);
  const bValues = toSheetValues(b);
  return aValues.every((value, i) => value === bValues[i]);
}
