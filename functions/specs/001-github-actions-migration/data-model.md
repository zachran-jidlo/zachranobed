# Data Model: GitHub Actions Migration

**Date**: 2026-01-16
**Feature**: 001-github-actions-migration

## Overview

This document defines the Firestore data models and DODO API contracts using zod schemas for runtime validation. All models represent existing Firestore collections or external API structures.

## Firestore Collections

### 1. Entity (Collection: `entities`)

Represents a donor or recipient location with establishment details, address, and contact information.

**Schema**:

```typescript
import { z } from "zod";
import { Timestamp, DocumentReference } from "firebase-admin/firestore";

export const EntityTypeSchema = z.enum(["DONOR", "RECIPIENT"]);

export const EntitySchema = z.object({
  /** Firestore document reference (added at runtime) */
  ref: z.instanceof(DocumentReference),
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
  postalCode: z.string(),
  /** Optional note for delivery driver */
  noteForDriver: z.string().optional(),
});

export type EntityType = z.infer<typeof EntityTypeSchema>;
export type Entity = z.infer<typeof EntitySchema>;
```

**Validation Rules**:

- Email must be valid format
- All required fields must be non-empty strings
- Phone should include country code (enforced by app, not schema)

**Relationships**:

- Referenced by EntityPair via `donorId` and `recipientId`
- One Entity can be donor in multiple EntityPairs
- One Entity can be recipient in multiple EntityPairs

---

### 2. EntityPair (Collection: `entityPairs`)

Represents a connection between a donor and recipient with carrier configuration and time windows.

**Schema**:

```typescript
import { z } from "zod";
import { DocumentReference } from "firebase-admin/firestore";

export const TimeWindowSchema = z.object({
  /** Start time in HH:MM format (e.g., "16:30") */
  start: z.string().regex(/^\d{2}:\d{2}$/),
  /** End time in HH:MM format (e.g., "17:00") */
  end: z.string().regex(/^\d{2}:\d{2}$/),
});

export const OrderStatusSchema = z.enum(["WAITING", "CONFIRMED", "CANCELED"]);

export const EntityPairSchema = z.object({
  /** Firestore document reference (added at runtime) */
  ref: z.instanceof(DocumentReference),
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
```

**Validation Rules**:

- Time windows must be in HH:MM format (e.g., "16:30")
- At least one pickup and one delivery time window required (enforced by app)
- `carrierId != 'disabled'` for active pairs (filtering rule, not schema)
- `confirmationTime` if set must be positive integer (minutes)

**Relationships**:

- References Entity via `donorId` and `recipientId`
- Used to create Delivery documents
- Each EntityPair can generate one Delivery per day

---

### 3. Delivery (Collection: `deliveries`)

Represents a food or box delivery transaction with state machine tracking.

**Schema**:

```typescript
import { z } from "zod";
import { Timestamp, DocumentReference } from "firebase-admin/firestore";

export const DeliveryStateSchema = z.enum([
  "PREPARED",
  "OFFERED",
  "ACCEPTED",
  "IN_DELIVERY",
  "DELIVERED",
  "NOT_USED",
]);

export const DeliveryTypeSchema = z.enum(["FOOD_DELIVERY", "BOX_DELIVERY"]);

export const DeliveryTimeWindowSchema = z.object({
  /** Start timestamp */
  start: z.instanceof(Timestamp),
  /** End timestamp */
  end: z.instanceof(Timestamp),
});

export const CarrierOrderSchema = z.object({
  /** Timestamp when order was created with carrier */
  createdAt: z.instanceof(Timestamp),
});

export const DeliverySchema = z.object({
  /** Firestore document reference (added at runtime) */
  ref: z.instanceof(DocumentReference),
  /** Carrier ID: 'dodo', 'personal', or 'disabled' */
  carrierId: z.string(),
  /** Donor entity ID */
  donorId: z.string(),
  /** Recipient entity ID */
  recipientId: z.string(),
  /** Delivery date (date only, time is 00:00) */
  deliveryDate: z.instanceof(Timestamp),
  /** Current state in delivery lifecycle */
  state: DeliveryStateSchema,
  /** Type of delivery */
  type: DeliveryTypeSchema,
  /** Unique identifier for carrier system */
  deliveryIdentifier: z.string(),
  /** Time window for pickup from donor */
  pickupTimeWindow: DeliveryTimeWindowSchema,
  /** Time window for delivery to recipient */
  deliveryTimeWindow: DeliveryTimeWindowSchema,
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
```

**Validation Rules**:

- `deliveryIdentifier` format: `{donorEstablishmentId}-{recipientEstablishmentId}-{date}` (Czech locale)
- `pickupTimeWindow.start` must be before `pickupTimeWindow.end`
- `deliveryTimeWindow.start` must be after `pickupTimeWindow.end`
- `state` transitions follow state machine rules (see State Machine section)
- `carrierOrder.createdAt` set only when DODO order successfully created

**Relationships**:

- Created from EntityPair data
- References Entity via `donorId` and `recipientId`
- One Delivery per EntityPair per day

**State Machine**:

```
┌──────────┐  deadline    ┌──────────┐
│ PREPARED │─────passed───>│ NOT_USED │
└────┬─────┘              └──────────┘
     │ confirmed
     │ by app
     v
┌─────────┐ create order  ┌──────────────┐ pickup    ┌─────────────┐
│ OFFERED │──────────────>│ OFFERED +    │─passed───>│ IN_DELIVERY │
└─────────┘               │ carrierOrder │           └─────────────┘
                          └──────────────┘

┌──────────┐ create order  ┌──────────────┐ pickup    ┌─────────────┐
│ ACCEPTED │──────────────>│ ACCEPTED +   │─passed───>│ IN_DELIVERY │
└──────────┘               │ carrierOrder │           └─────────────┘
                           └──────────────┘
```

---

## DODO API Models

### 4. DodoToken (OAuth2 Response)

Represents the OAuth2 access token response from DODO API.

**Schema**:

```typescript
import { z } from "zod";

export const DodoTokenSchema = z.object({
  /** Token type, always "Bearer" */
  token_type: z.literal("Bearer"),
  /** Token expiration in seconds */
  expires_in: z.number(),
  /** Extended expiration in seconds */
  ext_expires_in: z.number(),
  /** Access token for API requests */
  access_token: z.string(),
});

export type DodoToken = z.infer<typeof DodoTokenSchema>;
```

**Validation Rules**:

- `token_type` must be exactly "Bearer"
- `expires_in` must be positive integer
- `access_token` must be non-empty string

**Usage**:

```typescript
// Validate OAuth2 response
const response = await fetch(oauthUri, { ... });
const data = await response.json();
const token = DodoTokenSchema.parse(data); // Throws ZodError if invalid
```

---

### 5. DodoOrder (DODO API Request)

Represents the payload for creating a delivery order with DODO.

**Schema**:

```typescript
import { z } from "zod";

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
```

**Validation Rules**:

- `Identifier` must match `deliveryIdentifier` from Delivery document
- Timestamps must be ISO 8601 format with timezone (`.toISOString()`)
- `RequiredStart` must be before `RequiredEnd` for both Pickup and Drop
- `AddressRawValue` format: "{street} {houseNumber} {city} {postalCode}"
- `Price` always 0 for charity donations

**Usage**:

```typescript
// Create and validate order payload
const orderRequest: DodoOrderRequest = {
  Identifier: delivery.deliveryIdentifier,
  Pickup: {
    BranchIdentifier: donor.establishmentId,
    RequiredStart: delivery.pickupTimeWindow.start.toDate().toISOString(),
    RequiredEnd: delivery.pickupTimeWindow.end.toDate().toISOString(),
    Note: `${donor.noteForDriver || ""}\nDonor: ${donor.phone}\nRecipient: ${
      recipient.phone
    }`,
  },
  Drop: {
    AddressRawValue: `${recipient.street} ${recipient.houseNumber} ${recipient.city} ${recipient.postalCode}`,
    RequiredStart: delivery.deliveryTimeWindow.start.toDate().toISOString(),
    RequiredEnd: delivery.deliveryTimeWindow.end.toDate().toISOString(),
    Note: `${recipient.noteForDriver || ""}\nDonor: ${
      donor.phone
    }\nRecipient: ${recipient.phone}`,
  },
  CustomerName: recipient.responsiblePerson,
  CustomerPhone: recipient.phone,
  Price: 0,
};

// Validate before sending
DodoOrderRequestSchema.parse(orderRequest);
```

---

## Utility Types

### Date Utilities

```typescript
/**
 * Get the next business day, skipping weekends
 */
export function getNextBusinessDay(daysInFuture: number = 1): Date;

/**
 * Get a date in the future with optional time string
 * @param days - Number of days in future
 * @param timeString - Optional time in HH:MM format
 */
export function getDateInFuture(days: number, timeString?: string): Date;

/**
 * Format date in Czech locale for delivery identifier
 * @returns Date string in format "d. m. yyyy"
 */
export function formatCzechDate(date: Date): string;
```

### Service Interfaces

```typescript
/**
 * Load all entities from Firestore (with lazy caching)
 */
export async function getEntities(): Promise<Entity[]>;

/**
 * Load active entity pairs (carrierId != 'disabled')
 */
export async function getEntityPairs(): Promise<EntityPair[]>;

/**
 * Load today's deliveries in specified states
 */
export async function getTodaysDeliveries(
  states: DeliveryState[]
): Promise<Delivery[]>;

/**
 * Update delivery state in Firestore
 */
export async function updateDeliveryState(
  deliveryRef: DocumentReference,
  state: DeliveryState
): Promise<void>;

/**
 * Get DODO OAuth2 token
 */
export async function getDodoToken(): Promise<DodoToken>;

/**
 * Create DODO delivery order
 */
export async function createDodoOrder(
  order: DodoOrderRequest,
  token: DodoToken
): Promise<void>;
```

---

## File Organization

```
src/models/
├── index.ts              # Barrel export: export * from "./Entity"; etc.
├── Entity.ts             # Entity schema and type
├── EntityPair.ts         # EntityPair schema and type
├── Delivery.ts           # Delivery, DeliveryState, DeliveryType schemas
├── DodoToken.ts          # DodoToken schema and type
└── DodoOrder.ts          # DodoOrderRequest schema and type
```

**Import Pattern**:

```typescript
// Import from barrel
import { Delivery, DeliveryState, Entity, EntityPair } from "../models";

// Or individual imports
import { Delivery } from "../models/Delivery";
```

---

## Schema Validation Strategy

1. **Firestore Data**: No validation when reading (trusted source from app/Rowy)
2. **DODO API Responses**: Always validate with `.parse()` (untrusted external source)
3. **Internal Construction**: Validate before sending to DODO API to catch bugs early
4. **Error Handling**: Catch `ZodError` and log validation failures with context

**Example**:

```typescript
try {
  const token = DodoTokenSchema.parse(responseData);
  // Use validated token
} catch (error) {
  if (error instanceof z.ZodError) {
    console.error("DODO token validation failed:", error.format());
  }
  throw error;
}
```
