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

  const grid = await client.spreadsheets.values.get({
    spreadsheetId,
    range: tabRef,
    valueRenderOption: "FORMATTED_VALUE",
  });
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

  // Find the day's row by parsing column B, or append one when missing.
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
  let rowAppended = false;
  if (rowIndex === -1) {
    // Append after the table. The date goes in column B, written as text in
    // Czech format so it is deterministic regardless of the sheet locale.
    const appended = await client.spreadsheets.values.append({
      spreadsheetId,
      range: `${tabRef}!B:B`,
      valueInputOption: "RAW",
      insertDataOption: "INSERT_ROWS",
      requestBody: { values: [[dateCz]] },
    });
    rowIndex = parseAppendedRowIndex(appended.data, values.length);
    rowAppended = true;
  }

  const updates: sheets_v4.Schema$ValueRange[] = [];
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
    const cell = `${tabRef}!${colIndexToA1(columnIndex)}${rowIndex + 1}`;
    updates.push({ range: cell, values: [[count]] });
  }

  if (updates.length > 0) {
    await client.spreadsheets.values.batchUpdate({
      spreadsheetId,
      requestBody: { valueInputOption: "RAW", data: updates },
    });
  }

  return { written: updates.length, missingColumns, rowAppended };
}

/**
 * Resolve the zero-based row index of an appended row from the API response.
 * Falls back to the previous row count when the response range is missing.
 */
function parseAppendedRowIndex(
  data: sheets_v4.Schema$AppendValuesResponse,
  previousRowCount: number,
): number {
  const range = data.updates?.updatedRange;
  const match = range?.match(/![A-Z]+(\d+)/);
  if (match) {
    return Number(match[1]) - 1;
  }
  return previousRowCount;
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
