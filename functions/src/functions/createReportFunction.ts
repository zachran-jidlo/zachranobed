import { onSchedule } from "firebase-functions/v2/scheduler";
import { logger } from "firebase-functions/v2";
import { DateTime } from "luxon";
import {
  buildReport,
  groupByEmail,
  groupByEntity,
  ReportEmailContent,
  sendReportEmail,
} from "../services/reportService";
import {
  clearEntityCache,
  getEntities,
} from "../services/entityService";
import { TIMEZONE } from "../config/constants";

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
  emailsSent: number;
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
      `createReport: ${rows.length} rows, ${buckets.size} entities with deliveries, sending ${byEmail.size} emails`,
    );

    // One failed recipient must not block the others.
    const results = await Promise.all(
      [...byEmail].map(([email, entries]) =>
        sendReportEmail(email, entries, content).then(
          () => true,
          (err) => {
            logger.error(
              `createReport: failed to send report to ${email}`,
              err,
            );
            return false;
          },
        ),
      ),
    );

    logger.info("createReport: complete");
    return {
      rows: rows.length,
      entitiesWithDeliveries: buckets.size,
      emailsSent: results.filter(Boolean).length,
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
