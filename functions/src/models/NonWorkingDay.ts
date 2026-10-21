import { z } from "zod";
import { Timestamp } from "firebase-admin/firestore";

export const NonWorkingDaySchema = z.object({
  /**
   * The day without donations and box returns. Admins edit it as a Rowy Date
   * field. It is checked at runtime, so a bad document is skipped on its own.
   */
  date: z.instanceof(Timestamp),
  /** Optional label for admins, for example "Štědrý den" */
  name: z.string().optional(),
});

export type NonWorkingDay = z.infer<typeof NonWorkingDaySchema>;
