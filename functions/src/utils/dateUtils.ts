/** Checks if the given date is today.
 * @param {Date} date - The date to check.
 * @return {Boolean} - True if the date is today, false otherwise.
 */
export function isToday(date: Date): boolean {
  const today = new Date();
  return (
    date.getFullYear() === today.getFullYear() &&
    date.getMonth() === today.getMonth() &&
    date.getDate() === today.getDate()
  );
}
