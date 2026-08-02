import { onSchedule } from "firebase-functions/v2/scheduler";
import { logger } from "firebase-functions/v2";
import { DateTime } from "luxon";
import {
  buildReport,
  buildReportMail,
  groupByEmail,
  groupByEntity,
  ReportEmailContent,
} from "../services/reportService";
import {
  clearEntityCache,
  getEntities,
} from "../services/entityService";
import {
  scheduleReportMailSend,
  scheduleReportMailSweep,
} from "../services/cloudTaskService";
import { REPORT_MAIL, TIMEZONE } from "../config/constants";

/** Reported time range with the matching email texts. */
export interface ReportPeriod {
  start: DateTime;
  end: DateTime;
  content: ReportEmailContent;
}

export interface CreateReportOptions {
  /** Period to report on. Defaults to the previous calendar month. */
  period?: ReportPeriod;
  /** When set, only this entity's report is built and sent. */
  entityId?: string;
}

export interface CreateReportStats {
  rows: number;
  entitiesWithDeliveries: number;
  emailsQueued: number;
}

/** Build the period covering the calendar month of the given moment. */
function monthPeriod(moment: DateTime): ReportPeriod {
  const start = moment.startOf("month");
  const label = start.setLocale("cs").toFormat("MMMM yyyy");
  return {
    start,
    end: start.plus({ months: 1 }),
    content: {
      subject: `Měsíční report darování z ${label}`,
      periodPhrase: `z ${label}`,
      periodSlug: start.toFormat("yyyy-MM"),
    },
  };
}

/** Build the period covering the calendar year of the given moment. */
function yearPeriod(moment: DateTime): ReportPeriod {
  const start = moment.startOf("year");
  const year = start.toFormat("yyyy");
  return {
    start,
    end: start.plus({ years: 1 }),
    content: {
      subject: `Report darování za rok ${year}`,
      periodPhrase: `za rok ${year}`,
      periodSlug: year,
    },
  };
}

/**
 * Parse a requested period. Accepts YYYY-MM for one month and YYYY
 * for a whole year. Returns null when the value is not valid.
 */
export function parsePeriod(value: string): ReportPeriod | null {
  if (!/^\d{4}(-\d{2})?$/.test(value)) {
    return null;
  }
  const parsed = DateTime.fromISO(value, { zone: TIMEZONE });
  if (!parsed.isValid) {
    return null;
  }
  return value.length === 4 ? yearPeriod(parsed) : monthPeriod(parsed);
}

/**
 * Build a custom period from a YYYY-MM-DD range. Both ends are inclusive.
 * Returns null when a date is invalid or from is after to.
 */
export function parseRange(from: string, to: string): ReportPeriod | null {
  const start = DateTime.fromISO(from, { zone: TIMEZONE }).startOf("day");
  const toDay = DateTime.fromISO(to, { zone: TIMEZONE }).startOf("day");
  if (!start.isValid || !toDay.isValid || toDay < start) {
    return null;
  }
  const fromLabel = start.toFormat("d. M. yyyy");
  const toLabel = toDay.toFormat("d. M. yyyy");
  return {
    start,
    // The report query end is exclusive, so add a day to include the whole
    // "to" day.
    end: toDay.plus({ days: 1 }),
    content: {
      subject: `Report darování od ${fromLabel} do ${toLabel}`,
      periodPhrase: `od ${fromLabel} do ${toLabel}`,
      periodSlug: `${start.toISODate()}_${toDay.toISODate()}`,
    },
  };
}

export async function createReport(
  options: CreateReportOptions = {},
): Promise<CreateReportStats> {
  const period =
    options.period ??
    monthPeriod(DateTime.now().setZone(TIMEZONE).minus({ months: 1 }));
  const { content } = period;

  logger.info(
    `createReport: building report for ${content.periodSlug}` +
      (options.entityId ? ` scoped to entity ${options.entityId}` : ""),
  );

  try {
    const entities = await getEntities();
    const rows = await buildReport(
      period.start.toJSDate(),
      period.end.toJSDate(),
      entities,
      options.entityId,
    );
    let buckets = groupByEntity(rows);
    if (options.entityId) {
      // The scoped rows would also bucket under the counterparty
      // entities. Keep only the requested entity.
      const own = buckets.get(options.entityId);
      buckets = new Map(own ? [[options.entityId, own]] : []);
    }
    const byEmail = groupByEmail(buckets, entities);

    logger.info(
      `createReport: ${rows.length} rows, ${buckets.size} entities with deliveries, queueing ${byEmail.size} emails`,
    );

    // Sending is paced so the mail provider does not block us. Schedule one
    // Cloud Task per recipient, staggered by SEND_INTERVAL_SECONDS, each of
    // which writes a single mails document. Once the last one is sent, a
    // sweep runs to retry the failures. See reportMailWorkerFunction.
    if (byEmail.size > 0) {
      const runId = `${content.periodSlug}_${DateTime.now().toMillis()}`;
      const payloads = [...byEmail].map(([email, entries]) =>
        buildReportMail(email, entries, content),
      );

      for (let i = 0; i < payloads.length; i++) {
        await scheduleReportMailSend(
          runId,
          payloads[i],
          i * REPORT_MAIL.SEND_INTERVAL_SECONDS,
        );
      }

      await scheduleReportMailSweep(
        runId,
        1,
        payloads.length * REPORT_MAIL.SEND_INTERVAL_SECONDS + REPORT_MAIL.RETRY_DELAY_SECONDS,
      );

      logger.info(
        `createReport: queued ${payloads.length} emails for run ${runId}`,
      );
    }

    return {
      rows: rows.length,
      entitiesWithDeliveries: buckets.size,
      emailsQueued: byEmail.size,
    };
  } finally {
    // The entity cache is module-level. Clear it even on failure so
    // a later run on a warm instance does not reuse stale entities.
    clearEntityCache();
  }
}

export const createReportFunction = onSchedule(
  {
    // 08:00 Prague time on the 3rd of every month
    schedule: "0 8 3 * *",
    timeZone: TIMEZONE,
    timeoutSeconds: 300,
  },
  async () => {
    await createReport();
  },
);
