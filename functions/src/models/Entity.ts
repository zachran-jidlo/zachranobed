import { z } from "zod";
import { DocumentReference } from "firebase-admin/firestore";

export const EntityTypeSchema = z.enum(["DONOR", "RECIPIENT"]);

export const EntitySchema = z.object({
  /** Firestore document reference (added at runtime) */
  ref: z.any() as z.ZodType<DocumentReference>,
  /** Entity ID matching Firestore document ID */
  id: z.string(),
  /** Email address for contact */
  email: z.string().email(),
  /** Establishment display name */
  establishmentName: z.string(),
  /** Unique establishment identifier for DODO system */
  establishmentId: z.string(),
  /** Organization name */
  organization: z.string(),
  /** Entity type: DONOR or RECIPIENT */
  entityType: EntityTypeSchema,
  /** Contact phone number with country code */
  phone: z.string(),
  /** Responsible person's name */
  responsiblePerson: z.string(),
  /** City name */
  city: z.string(),
  /** Street name */
  street: z.string(),
  /** House/building number */
  houseNumber: z.string(),
  /** Postal code */
  postalCode: z.number(),
  /** Optional note for delivery driver */
  noteForDriver: z.string().optional(),
});

export type EntityType = z.infer<typeof EntityTypeSchema>;
export type Entity = z.infer<typeof EntitySchema>;
