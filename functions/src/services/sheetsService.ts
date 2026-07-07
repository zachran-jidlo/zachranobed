import { google, sheets_v4 } from "googleapis";
import { logger } from "firebase-functions/v2";

const SHEETS_SCOPE = "https://www.googleapis.com/auth/spreadsheets";

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
 * Layout assumptions (flagged so a mismatch is easy to spot): row 1 is the
 * header and holds entity ids, column A holds dates formatted as YYYY-MM-DD.
 * Donors are matched to a column by exact entity id. A donor without a matching
 * header column is logged and skipped, columns are never created. When the day
 * has no row yet, a new row is appended with the date in column A.
 *
 * @param {sheets_v4.Sheets} client - Authenticated Sheets client.
 * @param {string} spreadsheetId - Target spreadsheet id.
 * @param {string} tab - Target sheet (tab) name.
 * @param {string} dateIso - Day to write, formatted YYYY-MM-DD.
 * @param {Map<string, DonationCount>} counts - Totals keyed by donor entity id.
 * @return {Promise<UpsertStats>} What was written.
 */
export async function upsertDailyDonations(
  client: sheets_v4.Sheets,
  spreadsheetId: string,
  tab: string,
  dateIso: string,
  counts: Map<string, DonationCount>,
): Promise<UpsertStats> {
  // Quote the tab name so names with spaces work in A1 references.
  const tabRef = `'${tab.replace(/'/g, "''")}'`;

  const grid = await client.spreadsheets.values.get({
    spreadsheetId,
    range: tabRef,
    valueRenderOption: "FORMATTED_VALUE",
  });
  const values = (grid.data.values ?? []) as string[][];
  const header = values[0] ?? [];

  // Column index per entity id from the header row.
  const columnByEntityId = new Map<string, number>();
  header.forEach((cell, index) => {
    const id = (cell ?? "").trim();
    if (id) {
      columnByEntityId.set(id, index);
    }
  });

  // Find the day's row, or append one when it does not exist yet.
  let rowIndex = values.findIndex(
    (row, index) => index > 0 && (row[0] ?? "").trim() === dateIso,
  );
  let rowAppended = false;
  if (rowIndex === -1) {
    const appended = await client.spreadsheets.values.append({
      spreadsheetId,
      range: `${tabRef}!A:A`,
      valueInputOption: "RAW",
      insertDataOption: "INSERT_ROWS",
      requestBody: { values: [[dateIso]] },
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
