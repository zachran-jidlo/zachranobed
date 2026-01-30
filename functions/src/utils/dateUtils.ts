import { DateTime } from "luxon";

/** Checks if the given date is today.
 * @param {Date} date - The date to check.
 * @return {boolean} - True if the date is today, false otherwise.
 */
export function isToday(date: Date): boolean {
  const today = new Date();
  return (
    date.getFullYear() === today.getFullYear() &&
    date.getMonth() === today.getMonth() &&
    date.getDate() === today.getDate()
  );
}

/**
 * Get the next business day, skipping weekends.
 * Returns midnight Prague time for the target date.
 * @param {number} daysInFuture - Number of days in the future (default: 1)
 * @return {Date} - The next business day at midnight Prague time
 */
export function getNextBusinessDay(daysInFuture: number = 1): Date {
  let pragueDate = DateTime.now()
    .setZone("Europe/Prague")
    .plus({ days: daysInFuture })
    .startOf("day"); // Midnight Prague time

  // Move to Monday if weekend
  if (pragueDate.weekday === 6) {
    // Saturday
    pragueDate = pragueDate.plus({ days: 2 });
  } else if (pragueDate.weekday === 7) {
    // Sunday
    pragueDate = pragueDate.plus({ days: 1 });
  }

  return pragueDate.toJSDate();
}

/**
 * Calculates the date after a specified number of days in the future, with a given time.
 * If the calculated date falls on a weekend, it is moved to the closest Monday.
 * Time is interpreted as Prague timezone.
 * @param {number} daysInFuture - The number of days in the future
 * @param {string} time - The time in HH:MM format in Prague timezone (default: "00:00")
 * @return {Date} - The calculated date with proper UTC representation of Prague time
 */
export function getDateInFuture(
  daysInFuture: number,
  time: string = "00:00"
): Date {
  const [hours, minutes] = time.split(":").map(Number);

  let pragueDate = DateTime.now()
    .setZone("Europe/Prague")
    .plus({ days: daysInFuture })
    .set({ hour: hours, minute: minutes, second: 0, millisecond: 0 });

  // Move to Monday if weekend
  if (pragueDate.weekday === 6) {
    // Saturday
    pragueDate = pragueDate.plus({ days: 2 });
  } else if (pragueDate.weekday === 7) {
    // Sunday
    pragueDate = pragueDate.plus({ days: 1 });
  }

  return pragueDate.toJSDate();
}

/**
 * Format date in Czech locale for delivery identifier.
 * Uses Prague timezone to ensure consistency with deliveryDate field.
 * @param {Date} date - The date to format
 * @return {string} - Date string in format "d.m.yyyy"
 */
export function formatCzechDate(date: Date): string {
  const pragueDate = DateTime.fromJSDate(date).setZone("Europe/Prague");
  return `${pragueDate.day}.${pragueDate.month}.${pragueDate.year}`;
}

/**
 * Get minutes before pickup time for confirmation.
 * @param {Date} pickupTime - The pickup time
 * @return {number} - Minutes before pickup
 */
export function getMinutesBeforePickup(pickupTime: Date): number {
  const now = new Date();
  const diff = pickupTime.getTime() - now.getTime();
  return Math.floor(diff / (1000 * 60));
}
