import { DateTime } from "luxon";
import { TIMEZONE } from "../config/constants";

/** Checks if the given date is today.
 * @param {Date} date - The date to check.
 * @return {boolean} - True if the date is today, false otherwise.
 */
export function isToday(date: Date): boolean {
  const pragueNow = DateTime.now().setZone(TIMEZONE).startOf("day");
  const pragueDate = DateTime.fromJSDate(date).setZone(TIMEZONE).startOf("day");
  return pragueNow.equals(pragueDate);
}

/**
 * Format the Prague calendar day of a date as a "yyyy-MM-dd" key.
 * Non-working days are stored and compared by this key.
 * @param {Date} date - The date to format
 * @return {string} - Date key, for example "2026-12-24"
 */
export function toPragueDateKey(date: Date): string {
  return dateKey(DateTime.fromJSDate(date).setZone(TIMEZONE));
}

/**
 * Get the first day after the given date that is Monday to Friday.
 * Non-working days are not skipped here.
 * @param {Date} from - The reference time (default: now)
 * @return {Date} - The next weekday at midnight Prague time
 */
export function getNextWeekday(from: Date = new Date()): Date {
  return nextWeekday(DateTime.fromJSDate(from).setZone(TIMEZONE)).toJSDate();
}

/**
 * Get the day the daily donation run creates deliveries for. It is the next
 * weekday (Monday for a Friday run). When that day is a non-working day, no
 * deliveries are created and null is returned. The run does not move on to a
 * later day, because the next run covers it.
 * @param {ReadonlySet<string>} nonWorkingDays - "yyyy-MM-dd" Prague date keys
 * @param {Date} from - The reference time (default: now)
 * @return {Date | null} - The target day at midnight Prague time, or null
 */
export function getDonationTargetDay(
  nonWorkingDays: ReadonlySet<string>,
  from: Date = new Date(),
): Date | null {
  const target = getNextWeekday(from);
  return nonWorkingDays.has(toPragueDateKey(target)) ? null : target;
}

/**
 * Get the first working day after the given date. A working day is Monday to
 * Friday and is not listed in the non-working days.
 * @param {ReadonlySet<string>} nonWorkingDays - "yyyy-MM-dd" Prague date keys
 * @param {Date} from - The reference time (default: now)
 * @return {Date} - The next working day at midnight Prague time
 */
export function getNextWorkingDay(
  nonWorkingDays: ReadonlySet<string>,
  from: Date = new Date(),
): Date {
  let day = nextWeekday(DateTime.fromJSDate(from).setZone(TIMEZONE));
  while (nonWorkingDays.has(dateKey(day))) {
    day = nextWeekday(day);
  }
  return day.toJSDate();
}

/**
 * Format a Prague DateTime as a "yyyy-MM-dd" key.
 * @param {DateTime} date - The date in Prague timezone
 * @return {string} - Date key
 */
function dateKey(date: DateTime): string {
  return date.toFormat("yyyy-MM-dd");
}

/**
 * Get midnight of the first Monday to Friday day after the given date.
 * @param {DateTime} date - The reference date in Prague timezone
 * @return {DateTime} - The next weekday at midnight
 */
function nextWeekday(date: DateTime): DateTime {
  let day = date.plus({ days: 1 }).startOf("day");
  while (day.weekday > 5) {
    day = day.plus({ days: 1 });
  }
  return day;
}

/**
 * Format date in Czech locale for delivery identifier.
 * Uses Prague timezone to ensure consistency with deliveryDate field.
 * @param {Date} date - The date to format
 * @return {string} - Date string in format "d.m.yyyy"
 */
export function formatCzechDate(date: Date): string {
  const pragueDate = DateTime.fromJSDate(date).setZone(TIMEZONE);
  return `${pragueDate.day}.${pragueDate.month}.${pragueDate.year}`;
}

/**
 * Create a Date object for a specific date with a given time.
 * Time is interpreted as Prague timezone.
 * @param {Date} baseDate - The base date (midnight)
 * @param {string} time - The time in HH:MM format in Prague timezone
 * @return {Date} - The date with the specified time in Prague timezone
 */
export function createDateWithTime(baseDate: Date, time: string): Date {
  const [hours, minutes] = time.split(":").map(Number);

  const pragueDate = DateTime.fromJSDate(baseDate)
    .setZone(TIMEZONE)
    .set({ hour: hours, minute: minutes, second: 0, millisecond: 0 });

  return pragueDate.toJSDate();
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
