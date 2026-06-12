import { Timestamp } from "firebase-admin/firestore";
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

export async function buildReport(
  start: Date,
  end: Date,
  entities: Entity[],
): Promise<ReportRow[]> {
  const entityById = new Map(entities.map((e) => [e.id, e]));
  const mealCache = new Map<string, MealDetails | null>();

  const snapshot = await db
    .collection("deliveries")
    .where("deliveryDate", ">=", Timestamp.fromDate(start))
    .where("deliveryDate", "<", Timestamp.fromDate(end))
    .where("type", "==", "FOOD_DELIVERY")
    .get();

  const rows: ReportRow[] = [];

  for (const doc of snapshot.docs) {
    const data = doc.data();
    const donorId = data.donorId as string;
    const recipientId = data.recipientId as string;
    const meals = (data.meals ?? []) as MealInDelivery[];
    const deliveryDate = (data.deliveryDate as Timestamp).toDate();

    const donor = entityById.get(donorId);
    const recipient = entityById.get(recipientId);

    for (const meal of meals) {
      const mealCount = meal.count ?? meal.packagesCount;
      if (mealCount === undefined || mealCount === null) {
        continue;
      }

      const details = await resolveMealDetails(meal.mealId, mealCache);
      if (!details) {
        continue;
      }

      rows.push({
        deliveryDate,
        donorId,
        recipientId,
        donorName: donor?.establishmentName ?? donorId,
        recipientName: recipient?.establishmentName ?? recipientId,
        mealCount,
        mealName: details.name,
        foodCategory: details.foodCategory,
      });
    }
  }

  rows.sort((a, b) => a.deliveryDate.getTime() - b.deliveryDate.getTime());

  return rows;
}

async function resolveMealDetails(
  mealId: string,
  cache: Map<string, MealDetails | null>,
): Promise<MealDetails | null> {
  if (cache.has(mealId)) {
    return cache.get(mealId) ?? null;
  }

  const docSnap = await db.collection("meals").doc(mealId).get();
  if (!docSnap.exists) {
    logger.warn(`Meal document not found: ${mealId}`);
    cache.set(mealId, null);
    return null;
  }

  const data = docSnap.data() ?? {};
  const details: MealDetails = {
    name: typeof data.name === "string" ? data.name : "",
    foodCategory:
      typeof data.foodCategory === "string" ? data.foodCategory : "",
  };
  cache.set(mealId, details);
  return details;
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
      logger.warn(
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
  periodLabel: string,
  periodSlug: string,
): Promise<void> {
  const message = {
    subject: `Měsíční report darování z ${periodLabel}`,
    html: `
  <p>Dobrý den,</p>

  <p>v příloze naleznete report z <strong>${periodLabel}</strong></p>

  <p>
    S pozdravem a přáním pěkného dne,
    <br>
    <strong>Tým projektu Zachraň oběd</strong>
  </p>`,
    attachments: entries.map((entry) => ({
      filename: `${slug(entry.entity.establishmentName)}-${periodSlug}.csv`,
      content: Buffer.from(entry.csv, "utf8").toString("base64"),
      encoding: "base64",
      contentType: "text/csv; charset=utf-8",
    })),
  };

  await db.collection("mails").add({
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
  return `"${value.replace(/"/g, "\"\"")}"`;
}

function slug(value: string): string {
  return value
    .normalize("NFD")
    .replace(/\p{Diacritic}/gu, "")
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-+|-+$/g, "");
}
