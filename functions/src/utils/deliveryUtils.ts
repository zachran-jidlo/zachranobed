import { CONFIRMATION_MINUTES } from "../config/constants";

/**
 * Get the number of minutes before pickup that confirmation is required.
 * Uses custom confirmationTime if set, otherwise defaults based on carrier.
 * @param {object} delivery - Object with carrierId and optional confirmationTime
 * @return {number} Minutes before pickup for confirmation deadline
 */
export function getConfirmationMinutes(delivery: {
  carrierId?: string;
  confirmationTime?: number;
}): number {
  if (delivery.confirmationTime !== undefined) {
    return delivery.confirmationTime;
  }
  return delivery.carrierId === "dodo"
    ? CONFIRMATION_MINUTES.DODO
    : CONFIRMATION_MINUTES.PERSONAL;
}
