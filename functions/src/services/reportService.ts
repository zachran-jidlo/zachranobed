import { Filter, Timestamp } from "firebase-admin/firestore";
import { logger } from "firebase-functions/v2";
import { DateTime } from "luxon";
import { db } from "../config/firebase";
import { TIMEZONE } from "../config/constants";
import { Entity } from "../models";

const CSV_BOM = "﻿";
const CSV_HEADER = "\"Datum darování\",\"Jídelna\",\"Charita\",\"Počet\",\"Název\",\"Kategorie\"";

interface MealInDelivery {
  mealId: string;
  count?: number;
  packagesCount?: number;
}

interface MealDetails {
  name: string;
  foodCategory: string;
}

export interface ReportRow {
  deliveryDate: Date;
  donorId: string;
  recipientId: string;
  donorName: string;
  recipientName: string;
  mealCount: number;
  mealName: string;
  foodCategory: string;
}

export interface EntityAttachment {
  entity: Entity;
  csv: string;
}

export interface ReportEmailContent {
  /** Full subject line of the report email. */
  subject: string;
  /** Period phrase inserted into the email body after the word report. */
  periodPhrase: string;
  /** Period part of the attachment file names. */
  periodSlug: string;
}

export async function buildReport(
  start: Date,
  end: Date,
  entities: Entity[],
  entityId?: string,
): Promise<ReportRow[]> {
  const entityById = new Map(entities.map((e) => [e.id, e]));

  let query = db
    .collection("deliveries")
    .where("deliveryDate", ">=", Timestamp.fromDate(start))
    .where("deliveryDate", "<", Timestamp.fromDate(end))
    .where("type", "==", "FOOD_DELIVERY")
    // Completed deliveries. Current deliveries finalize to DONE via the
    // daily job. Before 2.0.0 successful deliveries stayed in IN_DELIVERY
    // and were never finalized, so keep that state for historical data.
    .where("state", "in", ["DONE", "IN_DELIVERY"]);

  if (entityId) {
    query = query.where(
      Filter.or(
        Filter.where("donorId", "==", entityId),
        Filter.where("recipientId", "==", entityId),
      ),
    );
  }

  const snapshot = await query.get();

  const mealIds = new Set<string>();
  for (const doc of snapshot.docs) {
    const meals = (doc.data().meals ?? []) as MealInDelivery[];
    for (const meal of meals) {
      if (meal.mealId) {
        mealIds.add(meal.mealId);
      }
    }
  }
  const mealById = await fetchMealDetails([...mealIds]);

  const rows: ReportRow[] = [];

  for (const doc of snapshot.docs) {
    const data = doc.data();
    const donorId = data.donorId as string;
    const recipientId = data.recipientId as string;
    const meals = (data.meals ?? []) as MealInDelivery[];
    const deliveryDate = (data.deliveryDate as Timestamp).toDate();

    const donor = entityById.get(donorId);
    const recipient = entityById.get(recipientId);
    const donorName = donor?.establishmentName ?? donorId;
    const recipientName = recipient?.establishmentName ?? recipientId;

    const rowsBefore = rows.length;

    for (const meal of meals) {
      const mealCount = meal.count ?? meal.packagesCount;
      if (mealCount === undefined || mealCount === null) {
        continue;
      }

      const details = meal.mealId ? mealById.get(meal.mealId) : undefined;
      if (!details) {
        continue;
      }

      rows.push({
        deliveryDate,
        donorId,
        recipientId,
        donorName,
        recipientName,
        mealCount,
        mealName: details.name,
        foodCategory: details.foodCategory,
      });
    }

    // The delivery is completed but donated no meals (empty list, or no
    // meal with a usable count and details). Keep the day in the report
    // with a zero-count placeholder row.
    if (rows.length === rowsBefore) {
      rows.push({
        deliveryDate,
        donorId,
        recipientId,
        donorName,
        recipientName,
        mealCount: 0,
        mealName: "",
        foodCategory: "",
      });
    }
  }

  rows.sort((a, b) => a.deliveryDate.getTime() - b.deliveryDate.getTime());

  return rows;
}

async function fetchMealDetails(
  mealIds: string[],
): Promise<Map<string, MealDetails>> {
  const result = new Map<string, MealDetails>();
  // Read in chunks to keep a single getAll request within
  // Firestore request-size limits.
  const chunkSize = 100;

  for (let i = 0; i < mealIds.length; i += chunkSize) {
    const refs = mealIds
      .slice(i, i + chunkSize)
      .map((id) => db.collection("meals").doc(id));
    const snapshots = await db.getAll(...refs);

    for (const docSnap of snapshots) {
      if (!docSnap.exists) {
        logger.warn(`Meal document not found: ${docSnap.id}`);
        continue;
      }
      const data = docSnap.data() ?? {};
      result.set(docSnap.id, {
        name: typeof data.name === "string" ? data.name : "",
        foodCategory: typeof data.foodCategory === "string" ? data.foodCategory : "",
      });
    }
  }

  return result;
}

export function groupByEntity(rows: ReportRow[]): Map<string, ReportRow[]> {
  const result = new Map<string, ReportRow[]>();
  for (const row of rows) {
    appendTo(result, row.donorId, row);
    appendTo(result, row.recipientId, row);
  }
  return result;
}

export function toCsv(rows: ReportRow[]): string {
  const lines = [CSV_HEADER];
  for (const row of rows) {
    const date =
      DateTime.fromJSDate(row.deliveryDate).setZone(TIMEZONE).toISODate() ?? "";
    lines.push(
      [
        date,
        row.donorName,
        row.recipientName,
        String(row.mealCount),
        row.mealName,
        row.foodCategory,
      ]
        .map(csvField)
        .join(","),
    );
  }
  return CSV_BOM + lines.join("\r\n") + "\r\n";
}

export function groupByEmail(
  entityBuckets: Map<string, ReportRow[]>,
  entities: Entity[],
): Map<string, EntityAttachment[]> {
  const result = new Map<string, EntityAttachment[]>();

  for (const entity of entities) {
    const rows = entityBuckets.get(entity.id);
    if (!rows || rows.length === 0) {
      continue;
    }

    const reporting = entity.reporting;
    if (!reporting?.enabled || reporting.emails.length === 0) {
      logger.info(
        `Entity ${entity.id} (${entity.establishmentName}) has deliveries in period but reporting is not enabled — skipped`,
      );
      continue;
    }

    const csv = toCsv(rows);
    const seenForEntity = new Set<string>();

    for (const email of reporting.emails) {
      const normalized = email.trim().toLowerCase();
      if (!normalized || seenForEntity.has(normalized)) {
        continue;
      }
      seenForEntity.add(normalized);
      appendTo(result, normalized, { entity, csv });
    }
  }

  return result;
}

export async function sendReportEmail(
  email: string,
  entries: EntityAttachment[],
  content: ReportEmailContent,
): Promise<void> {
  const usedNames = new Set<string>();
  const message = {
    subject: content.subject,
    html: `
  <p>Dobrý den,</p>

  <p>v příloze naleznete report <strong>${content.periodPhrase}</strong>.</p>

  <p>
    S pozdravem a přáním pěkného dne,
    <br>
    <strong>Tým projektu Zachraň oběd</strong>
  </p>`,
    attachments: entries.map((entry) => ({
      filename: `${uniqueSlug(entry.entity, usedNames)}-${content.periodSlug}.csv`,
      content: Buffer.from(entry.csv, "utf8").toString("base64"),
      encoding: "base64",
      contentType: "text/csv; charset=utf-8",
    })),
  };

  await db.collection("mails").add({
    createdAt: Timestamp.now(),
    to: [email],
    message,
  });
}

function appendTo<K, V>(map: Map<K, V[]>, key: K, value: V): void {
  const existing = map.get(key);
  if (existing) {
    existing.push(value);
  } else {
    map.set(key, [value]);
  }
}

function csvField(value: string): string {
  const escaped = value.replace(/"/g, "\"\"");
  // Values are user-entered text. A leading =, +, - or @ would run
  // as a formula when the CSV is opened in Excel. Prefix it with an
  // apostrophe so spreadsheets treat the value as plain text.
  const safe = /^[=+\-@]/.test(escaped) ? `'${escaped}` : escaped;
  return `"${safe}"`;
}

function slug(value: string): string {
  return value
    .normalize("NFD")
    .replace(/\p{Diacritic}/gu, "")
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-+|-+$/g, "");
}

/**
 * Attachment names only have to be unique within one email.
 * The slug is lossy, so similar establishment names can collide,
 * and a name without latin letters or digits slugs to an empty
 * string. Fall back to the entity id when the slug is empty and
 * add a counter when the name was already used in this email.
 */
function uniqueSlug(entity: Entity, used: Set<string>): string {
  const base = slug(entity.establishmentName) || entity.id;
  let name = base;
  for (let n = 2; used.has(name); n++) {
    name = `${base}-${n}`;
  }
  used.add(name);
  return name;
}
