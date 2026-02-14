/**
 * Helper method to update note with phone numbers for driver.
 * @param {string} note - Original note
 * @param {string} pickupPhoneNumber - Pickup point phone
 * @param {string} deliveryPhoneNumber - Delivery point phone
 * @return {string} - Updated note with phone numbers
 */
export function updateNoteWithPhoneNumbers(
  note: string,
  pickupPhoneNumber: string,
  deliveryPhoneNumber: string
): string {
  if (note.trim().length === 0) {
    return `Pickup Point tel. č. ${pickupPhoneNumber} \nDelivery Point tel. č. ${deliveryPhoneNumber}`;
  } else {
    return `${note} \nPickup Point tel. č. ${pickupPhoneNumber} \nDelivery Point tel. č. ${deliveryPhoneNumber}`;
  }
}
