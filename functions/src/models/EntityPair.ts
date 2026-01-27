import {z} from "zod";
import {DocumentReference} from "firebase-admin/firestore";

export const TimeWindowSchema = z.object({
  /** Start time in HH:MM format (e.g., "16:30") */
  start: z.string().regex(/^\d{2}:\d{2}$/),
  /** End time in HH:MM format (e.g., "17:00") */
  end: z.string().regex(/^\d{2}:\d{2}$/),
});

export const OrderStatusSchema = z.enum(["WAITING", "CONFIRMED", "CANCELED"]);

export const EntityPairSchema = z.object({
  /** Firestore document reference (added at runtime) */
  ref: z.any() as z.ZodType<DocumentReference>,
  /** Donor entity ID */
  donorId: z.string(),
  /** Recipient entity ID */
  recipientId: z.string(),
  /** Order status (legacy field, not used in migration) */
  orderStatus: OrderStatusSchema,
  /** DODO location ID for donor pickup */
  carrierDonorId: z.string(),
  /** DODO location ID for recipient delivery */
  carrierRecipientId: z.string(),
  /** Carrier type: 'dodo', 'personal', or 'disabled' */
  carrierId: z.string(),
  /** Carrier type for box returns: 'dodo', 'personal', or 'disabled' */
  boxReturnCarrierId: z.string(),
  /** Time windows for delivery to recipient */
  deliveryTimeWindows: z.array(TimeWindowSchema),
  /** Time windows for pickup from donor */
  pickupTimeWindows: z.array(TimeWindowSchema),
  /** Minutes before pickup to confirm (overrides carrier default) */
  confirmationTime: z.number().optional(),
});

export type TimeWindow = z.infer<typeof TimeWindowSchema>;
export type OrderStatus = z.infer<typeof OrderStatusSchema>;
export type EntityPair = z.infer<typeof EntityPairSchema>;
