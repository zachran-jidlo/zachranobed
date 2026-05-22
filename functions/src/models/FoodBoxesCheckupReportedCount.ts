/**
 * A single box-type entry submitted by the user when reporting a mismatch
 * during a food boxes checkup.
 *
 * @param {string} foodBoxId - Identifier of the food box type.
 * @param {number} realCount - The count the user actually has.
 * @param {number} systemCount - The count recorded in the system at the time of the report.
 */
export interface FoodBoxesCheckupReportedCount {
  foodBoxId: string;
  realCount: number;
  systemCount: number;
}
