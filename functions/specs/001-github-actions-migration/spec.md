# Feature Specification: GitHub Actions Migration to Firebase Cloud Functions

**Feature Branch**: `001-github-actions-migration`
**Created**: 2026-01-16
**Status**: Draft
**Input**: User description: "Migrate GitHub Actions to Firebase Cloud Functions"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Automated Daily Delivery Creation (Priority: P1)

The system automatically creates delivery documents each weekday morning for the next business day, enabling charities to receive meal donations from their paired food providers. Each active donor-recipient pair gets a delivery document prepared with appropriate time windows.

**Why this priority**: This is the foundational operation that enables the entire meal donation workflow. Without daily delivery creation, no donations can occur.

**Independent Test**: Can be fully tested by verifying that after the morning trigger, delivery documents exist in Firestore for all active entity pairs with correct delivery date (next business day) and PREPARED state.

**Acceptance Scenarios**:

1. **Given** active entity pairs exist with carrierId not equal to 'disabled', **When** the daily creation process runs at 7:00 AM UTC on a weekday, **Then** a delivery document is created for each pair with state PREPARED, type FOOD_DELIVERY, and delivery date set to tomorrow (or Monday if tomorrow is weekend)
2. **Given** an entity pair exists with carrierId equal to 'disabled', **When** the daily creation process runs, **Then** no delivery document is created for that pair
3. **Given** today is Friday, **When** the daily creation process runs, **Then** delivery documents are created with delivery date set to Monday
4. **Given** a delivery document already exists for a donor-recipient pair for tomorrow, **When** the creation process runs, **Then** the existing document is overwritten with fresh data

---

### User Story 2 - State Transition: Unconfirmed to NOT_USED (Priority: P2)

Deliveries that remain in PREPARED state past the confirmation deadline are automatically marked as NOT_USED. This ensures donors know their food is not being collected and can make alternative arrangements.

**Why this priority**: Critical for operational integrity - prevents donors from preparing food that will never be picked up.

**Independent Test**: Can be tested by creating a PREPARED delivery with pickup time in the past and verifying it transitions to NOT_USED after the check process runs.

**Acceptance Scenarios**:

1. **Given** a delivery is in PREPARED state, **When** the confirmation deadline has passed (45 minutes before pickup for DODO carrier, 20 minutes for personal carrier), **Then** the delivery state changes to NOT_USED
2. **Given** a delivery is in PREPARED state, **When** the confirmation deadline has NOT passed, **Then** the delivery state remains PREPARED
3. **Given** a delivery has custom confirmationTime set (e.g., 60 minutes), **When** processing, **Then** the custom time is used instead of carrier defaults

---

### User Story 3 - DODO Order Creation for Confirmed Deliveries (Priority: P2)

When a delivery is confirmed (OFFERED or ACCEPTED state) before the deadline, the system creates a logistics order with the DODO carrier service, enabling physical pickup and delivery.

**Why this priority**: Essential for the logistics to actually happen - without order creation, confirmed donations cannot be transported.

**Independent Test**: Can be tested by creating an OFFERED delivery before the deadline and verifying a DODO API call is made with correct pickup/delivery locations and times.

**Acceptance Scenarios**:

1. **Given** a delivery is in OFFERED or ACCEPTED state with DODO carrier, **When** confirmation deadline has not passed and no carrier order exists, **Then** a DODO order is created via API and carrierOrder.createdAt is set on the delivery
2. **Given** a delivery already has carrierOrder.createdAt set, **When** the check process runs, **Then** no duplicate DODO order is created
3. **Given** a delivery uses 'personal' carrier, **When** the check process runs, **Then** no DODO API call is made
4. **Given** the DODO API returns an error, **When** creating an order, **Then** the error is logged and processing continues for remaining deliveries

---

### User Story 4 - State Transition: Order Created to IN_DELIVERY (Priority: P3)

After a DODO order is created and the pickup time window ends, the delivery automatically transitions to IN_DELIVERY state, reflecting that the carrier is en route.

**Why this priority**: Important for accurate status tracking but not critical for the donation to occur.

**Independent Test**: Can be tested by creating a delivery with carrierOrder.createdAt set and pickup end time in the past, then verifying it transitions to IN_DELIVERY.

**Acceptance Scenarios**:

1. **Given** a delivery has carrierOrder.createdAt set and pickup end time has passed, **When** the check process runs, **Then** the delivery state changes to IN_DELIVERY
2. **Given** a delivery has carrierOrder.createdAt set but pickup end time has NOT passed, **When** the check process runs, **Then** the delivery state remains unchanged

---

### User Story 5 - Box Return Delivery Processing (Priority: P3)

Food boxes that need returning from recipients back to donors are processed separately. When a BOX_DELIVERY type delivery is in OFFERED state, the system creates a reverse logistics order (pickup from recipient, deliver to donor).

**Why this priority**: Secondary workflow that supports the reusable box program but doesn't block primary food donations.

**Independent Test**: Can be tested by creating a BOX_DELIVERY in OFFERED state and verifying a DODO order is created with reversed pickup/delivery locations (recipient to donor).

**Acceptance Scenarios**:

1. **Given** a BOX_DELIVERY type delivery is in OFFERED state for today, **When** the check process runs, **Then** a DODO order is created with pickup from recipient and delivery to donor
2. **Given** the box return order is created successfully, **When** processing completes, **Then** the delivery state changes to IN_DELIVERY with updated time windows and delivery identifier
3. **Given** a BOX_DELIVERY is not in OFFERED state, **When** the check process runs, **Then** no order is created for that delivery

---

### Edge Cases

- What happens when donor or recipient entity is missing for an entity pair? The system logs an error and continues processing other pairs.
- What happens when DODO API credentials are invalid or expired? The OAuth token refresh should fail gracefully with logged error; processing continues for non-DODO deliveries.
- What happens when the scheduled function runs during daylight saving time transition? Time calculations use explicit timezone handling to avoid missed or duplicate runs.
- What happens when Firestore is temporarily unavailable? Function retries according to Cloud Functions default retry policy.
- What happens when a delivery has no pickup time window defined? The system logs an error and skips that delivery.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST create delivery documents daily at 7:00 AM UTC for all active entity pairs (carrierId != 'disabled') on weekdays
- **FR-002**: System MUST set delivery date to next business day (skip weekends to Monday)
- **FR-003**: System MUST assign delivery state PREPARED and type FOOD_DELIVERY to newly created deliveries
- **FR-004**: System MUST generate delivery identifier in format `{donorEstablishmentId}-{recipientEstablishmentId}-{date}`
- **FR-005**: System MUST copy time windows from entity pair configuration to delivery document
- **FR-006**: System MUST process delivery state transitions every 7-8 minutes during business hours (9:00-17:00 CET, weekdays)
- **FR-007**: System MUST mark PREPARED deliveries as NOT_USED when confirmation deadline passes (45 min before pickup for DODO, 20 min for personal)
- **FR-008**: System MUST respect custom confirmationTime from delivery document when set
- **FR-009**: System MUST create DODO logistics order for OFFERED/ACCEPTED deliveries before deadline when carrier is 'dodo'
- **FR-010**: System MUST add 30-minute buffer to DODO confirmation deadline for OFFERED/ACCEPTED state handling
- **FR-011**: System MUST record carrierOrder.createdAt timestamp when DODO order is created
- **FR-012**: System MUST NOT create duplicate DODO orders (skip if carrierOrder.createdAt exists)
- **FR-013**: System MUST skip DODO order creation for 'personal' carrier
- **FR-014**: System MUST transition delivery to IN_DELIVERY state when pickup end time passes and order exists
- **FR-015**: System MUST process BOX_DELIVERY type separately from FOOD_DELIVERY
- **FR-016**: System MUST create reverse logistics orders for BOX_DELIVERY (pickup from recipient, deliver to donor)
- **FR-017**: System MUST use fixed time windows for box returns (pickup 10:00-10:30, delivery 11:00-11:30)
- **FR-018**: System MUST continue processing remaining items if one delivery fails
- **FR-019**: System MUST authenticate with DODO API using OAuth2 client credentials flow
- **FR-020**: System MUST export scheduled functions only for production project (zachran-obed)

### Key Entities

- **Entity**: Location record (donor or recipient) with establishment details, address, contact info, and driver notes
- **EntityPair**: Connection between a donor and recipient with carrier configuration, time windows, and DODO location IDs
- **Delivery**: Transaction document tracking a food or box transfer with state machine (PREPARED -> OFFERED -> ACCEPTED -> IN_DELIVERY -> DELIVERED or NOT_USED)
- **CarrierOrder**: Nested object within Delivery tracking when logistics order was created with the carrier

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: All active entity pairs receive delivery documents by 7:15 AM UTC each weekday
- **SC-002**: Unconfirmed deliveries are marked NOT_USED within 15 minutes of deadline passing
- **SC-003**: DODO orders are created within 15 minutes of delivery confirmation
- **SC-004**: System processes all deliveries without manual intervention during normal operations
- **SC-005**: Individual delivery failures do not block processing of other deliveries (error isolation)
- **SC-006**: Migration maintains identical business logic as existing GitHub Actions (functional parity)
- **SC-007**: Existing Firebase Functions continue operating unchanged after migration

## Assumptions

- DODO API remains available with existing OAuth2 authentication mechanism
- Firestore collections (entities, entityPairs, deliveries) maintain their current schema
- Business hours remain 9:00-17:00 CET for order checking
- Production project ID remains "zachran-obed"
- DEV project ID remains "zachran-obed-dev"
- Time windows in entity pairs are provided in "HH:MM" format
- Delivery dates use Czech locale formatting for identifier generation
