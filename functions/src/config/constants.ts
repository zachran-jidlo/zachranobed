/**
 * Application-wide constants for business rules and configuration.
 */

/**
 * Confirmation time requirements in minutes before pickup.
 */
export const CONFIRMATION_MINUTES = {
  DODO: 45, // 45 minutes for DODO carrier
  PERSONAL: 20, // 20 minutes for personal carrier
  BUFFER: 30, // 30-minute buffer for DODO to account for cron timing
} as const;

/**
 * Fixed time windows for box return deliveries.
 */
export const BOX_RETURN_SCHEDULE = {
  PICKUP: { start: "10:00", end: "10:30" },
  DELIVERY: { start: "11:00", end: "11:30" },
} as const;

/**
 * Czech text prefixes for delivery notes.
 */
export const NOTE_PREFIXES = {
  BOX_PICKUP: "Vyzvednutí obalů\n",
  BOX_DELIVERY: "Doručení obalů\n",
} as const;

/**
 * Timezone for all date/time calculations.
 */
export const TIMEZONE = "Europe/Prague";

/**
 * Firebase project IDs for different environments.
 */
export const ENVIRONMENTS = {
  DEV: "zachran-obed-dev",
  PROD: "zachran-obed",
} as const;
