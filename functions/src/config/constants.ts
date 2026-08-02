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
 * Minutes before confirmation time to send a reminder to the donor.
 */
export const CONFIRMATION_REMINDER_MINUTES = 10;

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
 * Pacing and retry rules for monthly report emails.
 *
 * The mails collection is drained by the Trigger Email extension. Creating
 * many mail documents at once makes it send too fast and the provider blocks
 * the messages. Send one at a time, then retry failures in later rounds.
 */
export const REPORT_MAIL = {
  /** Delay between two consecutive report emails in one send round. */
  SEND_INTERVAL_SECONDS: 30,
  /** Delay after a send round before the failed ones are retried. */
  RETRY_DELAY_SECONDS: 60 * 60,
  /**
   * Give up on an email after this many send attempts total, counting the
   * initial send plus the retry rounds. The cap is enforced by the sweep
   * round counter, so a run ends even if the extension never reports SUCCESS.
   */
  MAX_ATTEMPTS: 5,
} as const;

/**
 * Firebase project IDs for different environments.
 */
export const ENVIRONMENTS = {
  DEV: "zachran-obed-dev",
  PROD: "zachran-obed",
} as const;
