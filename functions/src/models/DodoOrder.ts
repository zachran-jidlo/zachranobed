import {z} from "zod";

export const DodoOrderRequestSchema = z.object({
  /** Unique identifier for order (matches deliveryIdentifier) */
  Identifier: z.string(),
  /** Pickup details */
  Pickup: z.object({
    /** DODO branch identifier for pickup location */
    BranchIdentifier: z.string(),
    /** Pickup window start (ISO 8601 format) */
    RequiredStart: z.string().datetime(),
    /** Pickup window end (ISO 8601 format) */
    RequiredEnd: z.string().datetime(),
    /** Note for driver at pickup */
    Note: z.string(),
  }),
  /** Delivery details */
  Drop: z.object({
    /** Full delivery address as single string */
    AddressRawValue: z.string(),
    /** Delivery window start (ISO 8601 format) */
    RequiredStart: z.string().datetime(),
    /** Delivery window end (ISO 8601 format) */
    RequiredEnd: z.string().datetime(),
    /** Note for driver at delivery */
    Note: z.string(),
  }),
  /** Customer name for contact */
  CustomerName: z.string(),
  /** Customer phone for contact */
  CustomerPhone: z.string(),
  /** Order price (always 0 for charity) */
  Price: z.literal(0),
});

export type DodoOrderRequest = z.infer<typeof DodoOrderRequestSchema>;

/**
 * Internal representation of DODO order with Date objects for easier manipulation.
 * Convert to DodoOrderRequest for API calls.
 */
export interface DodoOrder {
  /** Unique order identifier (matches deliveryIdentifier) */
  id: string;
  /** DODO branch identifier for pickup location */
  pickupDodoId: string;
  /** Pickup establishment ID */
  pickupId: string;
  /** Pickup window start */
  pickupFrom: Date;
  /** Pickup window end */
  pickupTo: Date;
  /** Note for driver at pickup */
  pickupNote: string;
  /** Delivery establishment ID */
  deliverId: string;
  /** Full delivery address */
  deliverAddress: string;
  /** Delivery window start */
  deliverFrom: Date;
  /** Delivery window end */
  deliverTo: Date;
  /** Note for driver at delivery */
  deliverNote: string;
  /** Customer contact name */
  customerName: string;
  /** Customer contact phone */
  customerPhone: string;
}
