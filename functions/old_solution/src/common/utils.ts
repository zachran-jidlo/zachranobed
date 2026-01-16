/**
 * Calculates the date after a specified number of days in the future, with a given time.
 * If the calculated date falls on a weekend, it is moved to the closest Monday.
 *
 * @param time - The time in HH:mm format. Defaults to '00:00'.
 * @param createdDeliveryDaysInFuture - The number of days in the future. Defaults to 1.
 * @returns The calculated date.
 */
export const getDateInFuture = (
  createdDeliveryDaysInFuture: number,
  time = '00:00'
): Date => {
  const date = new Date()
  const offset = date.getTimezoneOffset() / 60 // Minutes to hours

  date.setDate(date.getDate() + createdDeliveryDaysInFuture)
  const hours = parseInt(time.split(':')[0])
  const utcHours = hours + offset
  date.setUTCHours(utcHours)
  date.setUTCMinutes(parseInt(time.split(':')[1]))
  date.setUTCSeconds(0)

  // Move date to the closest Monday if it's a weekend
  if (date.getDay() === 0) {
    // Sunday
    date.setDate(date.getDate() + 1) // Move to Monday
  } else if (date.getDay() === 6) {
    // Saturday
    date.setDate(date.getDate() + 2) // Move to Monday
  }

  return date
}

// Helper methods

export function updateNoteWithWithPhoneNumbers(
  note: string,
  pickupPhoneNumber: string,
  deliveryPhoneNumber: string
): string {
  if (note.trim().length === 0) {
    return `Pickup Point tel. č. ${pickupPhoneNumber} \nDelivery Point tel. č. ${deliveryPhoneNumber}`
  } else {
    return `${note} \nPickup Point tel. č. ${pickupPhoneNumber} \nDelivery Point tel. č. ${deliveryPhoneNumber}`
  }
}
