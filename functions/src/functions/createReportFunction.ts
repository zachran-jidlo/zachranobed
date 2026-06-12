import { onSchedule } from "firebase-functions/v2/scheduler";
import { logger } from "firebase-functions/v2";
import { DateTime } from "luxon";
import {
  buildReport,
  groupByEmail,
  groupByEntity,
  sendReportEmail,
} from "../services/reportService";
import {
  clearEntityCache,
  getEntities,
} from "../services/entityService";
import { TIMEZONE } from "../config/constants";

export async function createReport(refDate?: Date): Promise<void> {
  const ref = DateTime.fromJSDate(refDate ?? new Date()).setZone(TIMEZONE);
  const periodStart = ref.minus({ months: 1 }).startOf("month");
  const periodEnd = ref.startOf("month");
  const periodLabel = periodStart.setLocale("cs").toFormat("MMMM yyyy");
  const periodSlug = periodStart.toFormat("yyyy-MM");

  logger.info(`createReport: building report for ${periodSlug}`);

  const entities = await getEntities();
  const rows = await buildReport(
    periodStart.toJSDate(),
    periodEnd.toJSDate(),
    entities,
  );
  const buckets = groupByEntity(rows);
  const byEmail = groupByEmail(buckets, entities);

  logger.info(
    `createReport: ${rows.length} rows, ${buckets.size} entities with deliveries, sending ${byEmail.size} emails`,
  );

  for (const [email, entries] of byEmail) {
    try {
      await sendReportEmail(email, entries, periodLabel, periodSlug);
    } catch (err) {
      logger.error(
        `createReport: failed to send report to ${email}`,
        err,
      );
    }
  }

  clearEntityCache();
  logger.info("createReport: complete");
}

export const createReportFunction = onSchedule(
  {
    // 08:00 Prague time on the 3rd of every month
    schedule: "0 8 3 * *",
    timeZone: TIMEZONE,
  },
  async () => {
    await createReport();
  },
);
