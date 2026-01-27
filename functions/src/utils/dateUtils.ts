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
 * @param {number} daysInFuture - Number of days in the future (default: 1)
 * @return {Date} - The next business day
 */
export function getNextBusinessDay(daysInFuture: number = 1): Date {
  const date = new Date();
  date.setDate(date.getDate() + daysInFuture);
  date.setHours(0, 0, 0, 0);

  // Move date to the closest Monday if it's a weekend
  if (date.getDay() === 0) {
    // Sunday
    date.setDate(date.getDate() + 1); // Move to Monday
  } else if (date.getDay() === 6) {
    // Saturday
    date.setDate(date.getDate() + 2); // Move to Monday
  }

  return date;
}

/**
 * Calculates the date after a specified number of days in the future, with a given time.
 * If the calculated date falls on a weekend, it is moved to the closest Monday.
 * @param {number} daysInFuture - The number of days in the future
 * @param {string} time - The time in HH:MM format (default: "00:00")
 * @return {Date} - The calculated date
 */
export function getDateInFuture(
  daysInFuture: number,
  time: string = "00:00"
): Date {
  const date = new Date();
  const offset = date.getTimezoneOffset() / 60; // Minutes to hours

  date.setDate(date.getDate() + daysInFuture);
  const hours = parseInt(time.split(":")[0]);
  const utcHours = hours + offset;
  date.setUTCHours(utcHours);
  date.setUTCMinutes(parseInt(time.split(":")[1]));
  date.setUTCSeconds(0);

  // Move date to the closest Monday if it's a weekend
  if (date.getDay() === 0) {
    // Sunday
    date.setDate(date.getDate() + 1); // Move to Monday
  } else if (date.getDay() === 6) {
    // Saturday
    date.setDate(date.getDate() + 2); // Move to Monday
  }

  return date;
}

/**
 * Format date in Czech locale for delivery identifier.
 * @param {Date} date - The date to format
 * @return {string} - Date string in format "d. m. yyyy"
 */
export function formatCzechDate(date: Date): string {
  return date.toLocaleDateString("cs").toLowerCase().replace(/ /g, "");
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
