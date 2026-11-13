import { logger } from "firebase-functions/v2";
import { db } from "../config/firebase";
import { NonWorkingDaySchema } from "../models";
import { toPragueDateKey } from "../utils/dateUtils";

/**
 * Load the non-working days (public holidays and other closed days) as
 * "yyyy-MM-dd" Prague date keys. Read fresh on every call, so admin changes
 * apply to the next run.
 *
 * Fails open. If the read fails, the error is logged and an empty set is
 * returned, so only weekends are skipped, as before this list existed.
 * @return {Promise<Set<string>>} - Non-working day keys
 */
export async function getNonWorkingDays(): Promise<Set<string>> {
  try {
    const snapshot = await db.collection("nonWorkingDays").get();
    const days = new Set<string>();

    for (const doc of snapshot.docs) {
      const result = NonWorkingDaySchema.safeParse(doc.data());
      if (!result.success) {
        logger.warn(`Invalid non-working day document ${doc.id}:`, result.error);
        continue;
      }
      days.add(toPragueDateKey(result.data.date.toDate()));
    }

    logger.info(`Loaded ${days.size} non-working days`);
    return days;
  } catch (error) {
    logger.error("Failed to load non-working days, skipping weekends only:", error);
    return new Set();
  }
}
