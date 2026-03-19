import {z} from "zod";
import {Timestamp, DocumentReference} from "firebase-admin/firestore";

export const DeliveryStateSchema = z.enum([
  "PREPARED",
  /** @deprecated OFFERED state is being removed. Keep for reading legacy documents during migration. TODO(post-migration): remove OFFERED */
  "OFFERED",
  "ACCEPTED",
  "ON_WAY_TO_PICK_UP",
  "IN_DELIVERY",
  "DELIVERED",
  "DONE",
  "NOT_USED",
]);

export const DeliveryTypeSchema = z.enum(["FOOD_DELIVERY", "BOX_DELIVERY"]);

export const DeliveryTimeWindowSchema = z.object({
  /** Start timestamp */
  start: z.any() as z.ZodType<Timestamp>,
  /** End timestamp */
  end: z.any() as z.ZodType<Timestamp>,
});

export const CarrierOrderSchema = z.object({
  /** Timestamp when order was created with carrier */
  createdAt: z.any() as z.ZodType<Timestamp>,
});

export const DeliverySchema = z.object({
  /** Firestore document reference (added at runtime) */
  ref: z.any() as z.ZodType<DocumentReference>,
  /** Carrier ID: 'dodo', 'personal', or 'disabled' (optional for BOX_DELIVERY - set during processing) */
  carrierId: z.string().optional(),
  /** Box return carrier ID (for BOX_DELIVERY type) */
  boxReturnCarrierId: z.string().optional(),
  /** Donor entity ID */
  donorId: z.string(),
  /** Recipient entity ID */
  recipientId: z.string(),
  /** Delivery date (date only, time is 00:00) */
  deliveryDate: z.any() as z.ZodType<Timestamp>,
  /** Current state in delivery lifecycle */
  state: DeliveryStateSchema,
  /** Type of delivery */
  type: DeliveryTypeSchema,
  /** Unique identifier for carrier system (optional for BOX_DELIVERY - generated during processing) */
  deliveryIdentifier: z.string().optional(),
  /** Time window for pickup from donor (optional for BOX_DELIVERY - calculated during processing) */
  pickupTimeWindow: DeliveryTimeWindowSchema.optional(),
  /** Time window for delivery to recipient (optional for BOX_DELIVERY - calculated during processing) */
  deliveryTimeWindow: DeliveryTimeWindowSchema.optional(),
  /** Food boxes included (legacy field, empty array for migration) */
  foodBoxes: z.array(z.any()).default([]),
  /** Meals included (legacy field, empty array for migration) */
  meals: z.array(z.any()).default([]),
  /** Carrier order metadata (set when DODO order created) */
  carrierOrder: CarrierOrderSchema.optional(),
  /** Minutes before pickup to confirm (overrides carrier default) */
  confirmationTime: z.number().optional(),
});

export type DeliveryState = z.infer<typeof DeliveryStateSchema>;
export type DeliveryType = z.infer<typeof DeliveryTypeSchema>;
export type DeliveryTimeWindow = z.infer<typeof DeliveryTimeWindowSchema>;
export type CarrierOrder = z.infer<typeof CarrierOrderSchema>;
export type Delivery = z.infer<typeof DeliverySchema>;
