import { google, sheets_v4 } from "googleapis";
import { logger } from "firebase-functions/v2";
import { DateTime } from "luxon";

const SHEETS_SCOPE = "https://www.googleapis.com/auth/spreadsheets";

// Sheet layout. Zero-based indexes.
const HEADER_ROW_INDEX = 4; // donor ids live in row 5
const DATE_COLUMN_INDEX = 1; // dates live in column B
// Czech date format, no leading zeros, e.g. 1.12.2025 or 23.12.2025.
const DATE_FORMAT = "d.M.yyyy";

/** Donated meal total for one donor on the synced day. */
export interface DonationCount {
  /** Establishment name, used only in log messages. */
  name: string;
  count: number;
}

export interface UpsertStats {
  /** Donors whose count was written to a cell. */
  written: number;
  /** Donors skipped because no header column matched their id. */
  missingColumns: number;
  /** True when a new row was appended for the day. */
  rowAppended: boolean;
}

/**
 * Build an authenticated Sheets client from a service account key.
 *
 * @param {string} rawKey - JSON key of the service account, as stored in the
 *   SHEETS_SA_KEY secret. The sheet must be shared with this account as editor.
 * @return {sheets_v4.Sheets} Ready-to-use Sheets v4 client.
 */
export function getSheetsClient(rawKey: string): sheets_v4.Sheets {
  const credentials = JSON.parse(rawKey);
  const auth = new google.auth.GoogleAuth({
    credentials,
    scopes: [SHEETS_SCOPE],
  });
  return google.sheets({ version: "v4", auth });
}

/**
 * Write each donor's daily total into the grid.
 *
 * Layout assumptions (flagged so a mismatch is easy to spot): donor ids sit in
 * row 5, dates sit in column B in Czech format (1.12.2025). Donors are matched
 * to a column by exact entity id. A donor without a matching header column is
 * logged and skipped, columns are never created. When the day has no row yet, a
 * new row is appended after the table with the date in column B.
 *
 * @param {sheets_v4.Sheets} client - Authenticated Sheets client.
 * @param {string} spreadsheetId - Target spreadsheet id.
 * @param {string} tab - Target sheet (tab) name.
 * @param {DateTime} day - Day to write (start of day).
 * @param {Map<string, DonationCount>} counts - Totals keyed by donor entity id.
 * @return {Promise<UpsertStats>} What was written.
 */
export async function upsertDailyDonations(
  client: sheets_v4.Sheets,
  spreadsheetId: string,
  tab: string,
  day: DateTime,
  counts: Map<string, DonationCount>,
): Promise<UpsertStats> {
  // Quote the tab name so names with spaces work in A1 references.
  const tabRef = `'${tab.replace(/'/g, "''")}'`;
  const targetIso = day.toISODate();
  const dateCz = day.toFormat(DATE_FORMAT);

  const grid = await withSheetsRetry(
    () =>
      client.spreadsheets.values.get({
        spreadsheetId,
        range: tabRef,
        valueRenderOption: "FORMATTED_VALUE",
      }),
    "read grid",
  );
  const values = (grid.data.values ?? []) as string[][];
  const header = values[HEADER_ROW_INDEX] ?? [];

  // Column index per entity id from the header row.
  const columnByEntityId = new Map<string, number>();
  header.forEach((cell, index) => {
    const id = (cell ?? "").trim();
    if (id) {
      columnByEntityId.set(id, index);
    }
  });

  // Find the day's row by parsing column B.
  let rowIndex = values.findIndex((row, index) => {
    if (index <= HEADER_ROW_INDEX) {
      return false;
    }
    // Strip spaces so "1. 12. 2025" also matches.
    const raw = (row[DATE_COLUMN_INDEX] ?? "").replace(/\s/g, "");
    if (!raw) {
      return false;
    }
    const parsed = DateTime.fromFormat(raw, DATE_FORMAT);
    return parsed.isValid && parsed.toISODate() === targetIso;
  });

  // Collect every cell to write, so one day is one write request. When the day
  // has no row yet, the next free row after the table also gets the date.
  const data: sheets_v4.Schema$ValueRange[] = [];
  let rowAppended = false;
  if (rowIndex === -1) {
    rowIndex = values.length;
    rowAppended = true;
    // Written as text in Czech format, deterministic regardless of locale.
    data.push({
      range: `${tabRef}!${colIndexToA1(DATE_COLUMN_INDEX)}${rowIndex + 1}`,
      values: [[dateCz]],
    });
  }

  let written = 0;
  let missingColumns = 0;
  for (const [entityId, { name, count }] of counts) {
    const columnIndex = columnByEntityId.get(entityId);
    if (columnIndex === undefined) {
      missingColumns++;
      logger.warn(
        `sheetsService: no column for donor ${name} (${entityId}) — skipped`,
      );
      continue;
    }
    data.push({
      range: `${tabRef}!${colIndexToA1(columnIndex)}${rowIndex + 1}`,
      values: [[count]],
    });
    written++;
  }

  if (data.length > 0) {
    await withSheetsRetry(
      () =>
        client.spreadsheets.values.batchUpdate({
          spreadsheetId,
          requestBody: { valueInputOption: "RAW", data },
        }),
      "write cells",
    );
  }

  return { written, missingColumns, rowAppended };
}

/** HTTP status of a Sheets API error, checking the shapes gaxios uses. */
function statusOf(error: unknown): number | undefined {
  const e = error as {
    code?: number | string;
    status?: number;
    response?: { status?: number };
  };
  const code = typeof e?.code === "string" ? Number(e.code) : e?.code;
  return code ?? e?.status ?? e?.response?.status;
}

/**
 * Retry a Sheets call on rate-limit (429) errors with exponential backoff.
 * Backfilling many days can otherwise trip the per-minute write quota.
 */
async function withSheetsRetry<T>(
  fn: () => Promise<T>,
  label: string,
): Promise<T> {
  const maxAttempts = 5;
  let delayMs = 2000;
  for (let attempt = 1; ; attempt++) {
    try {
      return await fn();
    } catch (error) {
      if (statusOf(error) !== 429 || attempt >= maxAttempts) {
        throw error;
      }
      logger.warn(
        `sheetsService: ${label} rate limited, retry ${attempt} in ${delayMs}ms`,
      );
      await new Promise((resolve) => setTimeout(resolve, delayMs));
      delayMs *= 2;
    }
  }
}

/** Convert a zero-based column index to an A1 column label (0 -> A, 26 -> AA). */
function colIndexToA1(index: number): string {
  let label = "";
  let n = index;
  do {
    label = String.fromCharCode(65 + (n % 26)) + label;
    n = Math.floor(n / 26) - 1;
  } while (n >= 0);
  return label;
}
