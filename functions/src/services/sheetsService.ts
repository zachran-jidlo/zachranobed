import { auth, sheets, sheets_v4 } from "@googleapis/sheets";
import { logger } from "firebase-functions/v2";

const SHEETS_SCOPE = "https://www.googleapis.com/auth/spreadsheets";

/** A single cell value. Numbers stay numbers so the sheet can sum them. */
export type SheetValue = string | number;

/**
 * Build an authenticated Sheets client from the runtime service account.
 *
 * @return {sheets_v4.Sheets} Ready-to-use Sheets v4 client.
 */
export function getSheetsClient(): sheets_v4.Sheets {
  const credentials = new auth.GoogleAuth({ scopes: [SHEETS_SCOPE] });
  return sheets({ version: "v4", auth: credentials });
}

/**
 * Read one whole column as trimmed strings.
 *
 * Index 0 is row 1. Trailing empty rows are not returned, so an empty result
 * means the tab has no content in that column at all.
 *
 * @param {sheets_v4.Sheets} client - Authenticated Sheets client.
 * @param {string} spreadsheetId - Target spreadsheet id.
 * @param {string} tab - Target sheet (tab) name.
 * @param {string} column - A1 column label, for example "B".
 * @return {Promise<string[]>} Cell values, top to bottom.
 */
export async function readColumn(
  client: sheets_v4.Sheets,
  spreadsheetId: string,
  tab: string,
  column: string,
): Promise<string[]> {
  const response = await withSheetsRetry(
    () =>
      client.spreadsheets.values.get({
        spreadsheetId,
        range: `${quoteTab(tab)}!${column}:${column}`,
        majorDimension: "COLUMNS",
        valueRenderOption: "UNFORMATTED_VALUE",
      }),
    `read column ${column}`,
  );

  return (response.data.values?.[0] ?? []).map((value) =>
    String(value ?? "").trim(),
  );
}

/**
 * Append rows after the last row of the table.
 *
 * The A1 anchor lets the API resolve the table server-side, so there is no
 * read-then-write race on a computed row index, and INSERT_ROWS never
 * overwrites content parked below the table.
 *
 * @param {sheets_v4.Sheets} client - Authenticated Sheets client.
 * @param {string} spreadsheetId - Target spreadsheet id.
 * @param {string} tab - Target sheet (tab) name.
 * @param {SheetValue[][]} rows - Rows to append, outer array is rows.
 * @return {Promise<void>}
 */
export async function appendRows(
  client: sheets_v4.Sheets,
  spreadsheetId: string,
  tab: string,
  rows: SheetValue[][],
): Promise<void> {
  if (rows.length === 0) {
    return;
  }

  await withSheetsRetry(
    () =>
      client.spreadsheets.values.append({
        spreadsheetId,
        range: `${quoteTab(tab)}!A1`,
        valueInputOption: "USER_ENTERED",
        insertDataOption: "INSERT_ROWS",
        requestBody: { values: rows },
      }),
    `append ${rows.length} rows`,
  );
}

/**
 * Make a text value safe for USER_ENTERED writes.
 *
 * A leading =, +, - or @ would run as a formula. Prefix it with an apostrophe
 * so the spreadsheet keeps the value as plain text. Same guard the CSV report
 * uses, see csvField in reportService.
 *
 * @param {string} value - Raw, possibly user-entered text.
 * @return {string} Value that cannot be interpreted as a formula.
 */
export function safeSheetText(value: string): string {
  return /^[=+\-@]/.test(value) ? `'${value}` : value;
}

/** Quote a tab name so names with spaces or apostrophes work in A1 ranges. */
function quoteTab(tab: string): string {
  return `'${tab.replace(/'/g, "''")}'`;
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

/** Worth another attempt: rate limit, or a server-side error on Google's end. */
function isTransient(status: number | undefined): boolean {
  return status === 429 || (status !== undefined && status >= 500);
}

/**
 * Retry a Sheets call on transient failures with exponential backoff.
 *
 * The caller has no recovery path, a failed write means the day never reaches
 * the sheet, so it is worth riding out a blip. Anything that is not transient
 * (a bad range, a sheet that is not shared with us) is rethrown immediately,
 * retrying it would only delay the error.
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
      const status = statusOf(error);
      if (!isTransient(status) || attempt >= maxAttempts) {
        throw error;
      }
      logger.warn(
        `sheetsService: ${label} failed with ${status}, retry ${attempt} in ${delayMs}ms`,
      );
      await new Promise((resolve) => setTimeout(resolve, delayMs));
      delayMs *= 2;
    }
  }
}
