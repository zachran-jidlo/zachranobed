# Tasks: GitHub Actions Migration to Firebase Cloud Functions

**Input**: Design documents from `/specs/001-github-actions-migration/`
**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/dodo-api.yaml, quickstart.md

**Tests**: Tests are NOT explicitly requested in the feature specification, so test tasks are omitted. Focus is on functional migration with manual testing via Firebase Emulator.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

Single project structure: `src/` at repository root (functions/)

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Install dependencies and configure Firebase secrets

- [X] T001 Install zod dependency: `npm install zod`
- [X] T002 [P] Set DODO_CLIENT_ID secret in Firebase: `firebase functions:secrets:set DODO_CLIENT_ID`
- [X] T003 [P] Set DODO_CLIENT_SECRET secret in Firebase: `firebase functions:secrets:set DODO_CLIENT_SECRET`
- [X] T004 [P] Set DODO_OAUTH_URI secret in Firebase: `firebase functions:secrets:set DODO_OAUTH_URI`
- [X] T005 [P] Set DODO_SCOPE secret in Firebase: `firebase functions:secrets:set DODO_SCOPE`
- [X] T006 [P] Set DODO_ORDERS_API secret in Firebase: `firebase functions:secrets:set DODO_ORDERS_API`

**Checkpoint**: Dependencies installed and secrets configured

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core models, utilities, and secrets configuration that ALL user stories depend on

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [X] T007 [P] Create Entity model with zod schema in src/models/Entity.ts
- [X] T008 [P] Create EntityPair model with zod schema in src/models/EntityPair.ts
- [X] T009 [P] Create Delivery model with zod schemas (DeliveryState, DeliveryType, DeliveryTimeWindow, CarrierOrder) in src/models/Delivery.ts
- [X] T010 [P] Create DodoToken model with zod schema in src/models/DodoToken.ts
- [X] T011 [P] Create DodoOrder model with zod schema in src/models/DodoOrder.ts
- [X] T012 Create barrel export file for models in src/models/index.ts
- [X] T013 [P] Add DODO secret definitions to src/config/firebase.ts using defineString()
- [X] T014 [P] Implement getNextBusinessDay() utility in src/utils/dateUtils.ts
- [X] T015 [P] Implement getDateInFuture() utility in src/utils/dateUtils.ts
- [X] T016 [P] Implement formatCzechDate() utility in src/utils/dateUtils.ts
- [X] T017 [P] Implement getMinutesBeforePickup() utility in src/utils/dateUtils.ts

**Checkpoint**: Foundation ready - all models and utilities available - user story implementation can now begin in parallel

---

## Phase 3: User Story 1 - Automated Daily Delivery Creation (Priority: P1) 🎯 MVP

**Goal**: System automatically creates delivery documents each weekday morning for next business day, enabling charities to receive meal donations

**Independent Test**: After function triggers at 7:00 AM UTC (or manual trigger in emulator), verify delivery documents exist in Firestore for all active entity pairs with correct delivery date (next business day), PREPARED state, and FOOD_DELIVERY type

### Implementation for User Story 1

- [X] T018 [P] [US1] Implement getEntities() in src/services/entityService.ts to load all entities from Firestore
- [X] T019 [P] [US1] Implement getEntityPairs() in src/services/entityService.ts to load active entity pairs (carrierId != 'disabled')
- [X] T020 [US1] Implement createDeliveryDocument() in src/services/deliveryService.ts to save delivery to Firestore with PREPARED state
- [X] T021 [US1] Implement sendOrders() core logic in src/functions/sendOrdersFunction.ts: load entity pairs, load entities, create deliveries for tomorrow (skip weekends)
- [X] T022 [US1] Wrap sendOrders() with onSchedule trigger (cron: "0 7 * * 1-5", timeZone: "UTC") in src/functions/sendOrdersFunction.ts
- [X] T023 [US1] Add conditional export for sendOrdersFunction in src/index.ts (only for project "zachran-obed")
- [X] T024 [US1] Test User Story 1 in Firebase Emulator: manually trigger sendOrders and verify deliveries created with correct date, state, and identifier format

**Checkpoint**: At this point, User Story 1 should be fully functional - delivery documents are created daily for active pairs

---

## Phase 4: User Story 2 - State Transition: Unconfirmed to NOT_USED (Priority: P2)

**Goal**: Deliveries remaining in PREPARED state past confirmation deadline are automatically marked as NOT_USED, ensuring donors know food won't be collected

**Independent Test**: Create a PREPARED delivery with pickup time in the past in Firestore, run checkOrders function, verify state transitions to NOT_USED

### Implementation for User Story 2

- [X] T025 [P] [US2] Implement getTodaysDeliveries() in src/services/deliveryService.ts to query deliveries in PREPARED/OFFERED/ACCEPTED states for today
- [X] T026 [P] [US2] Implement updateDeliveryState() in src/services/deliveryService.ts to update delivery state in Firestore
- [X] T027 [US2] Implement handlePreparedDelivery() logic in src/functions/checkOrdersFunction.ts: check deadline, mark as NOT_USED if passed
- [X] T028 [US2] Implement getMinutesConfirmedBeforePickup() helper in src/functions/checkOrdersFunction.ts using confirmationTime or carrier defaults (45 min DODO, 20 min personal)
- [X] T029 [US2] Test User Story 2 in Firebase Emulator: create PREPARED delivery with past deadline, trigger checkOrders, verify state changes to NOT_USED

**Checkpoint**: At this point, User Stories 1 AND 2 should both work independently - deliveries created and expired ones marked NOT_USED

---

## Phase 5: User Story 3 - DODO Order Creation for Confirmed Deliveries (Priority: P2)

**Goal**: When delivery confirmed (OFFERED/ACCEPTED state) before deadline, system creates logistics order with DODO carrier enabling physical transport

**Independent Test**: Create OFFERED delivery before deadline in Firestore, run checkOrders function, verify DODO API called and carrierOrder.createdAt set

### Implementation for User Story 3

- [X] T030 [P] [US3] Implement getDodoToken() in src/services/dodoService.ts using native fetch for OAuth2 token request
- [X] T031 [P] [US3] Implement createDodoOrder() in src/services/dodoService.ts using native fetch to post order to DODO API
- [X] T032 [US3] Implement updateDeliveryWithOrderCreationTime() in src/services/deliveryService.ts to set carrierOrder.createdAt timestamp
- [X] T033 [US3] Implement createDodoOrderFromDelivery() helper in src/functions/checkOrdersFunction.ts to build DodoOrderRequest payload from delivery/entities
- [X] T034 [US3] Implement handleOfferedOrAcceptedDelivery() logic in src/functions/checkOrdersFunction.ts: check if before deadline, create DODO order if carrier is 'dodo' and no existing carrierOrder
- [X] T035 [US3] Add 30-minute buffer for DODO confirmation deadline in handleDeliveryState() in src/functions/checkOrdersFunction.ts
- [X] T036 [US3] Implement error isolation: wrap order creation in try-catch, log errors, continue processing remaining deliveries
- [X] T037 [US3] Test User Story 3 in Firebase Emulator: create OFFERED delivery, trigger checkOrders, verify DODO API called (check logs) and carrierOrder.createdAt set

**Checkpoint**: At this point, User Stories 1, 2, AND 3 should work independently - deliveries created, expired ones marked NOT_USED, confirmed ones get DODO orders

---

## Phase 6: User Story 4 - State Transition: Order Created to IN_DELIVERY (Priority: P3)

**Goal**: After DODO order created and pickup time passes, delivery automatically transitions to IN_DELIVERY state reflecting carrier is en route

**Independent Test**: Create delivery with carrierOrder.createdAt set and pickup end time in past, run checkOrders function, verify state changes to IN_DELIVERY

### Implementation for User Story 4

- [X] T038 [US4] Implement handleAcceptedOrOfferedDeliveryAfterConfirmation() logic in src/functions/checkOrdersFunction.ts: check if pickup time passed, transition to IN_DELIVERY if carrierOrder exists
- [X] T039 [US4] Integrate US4 logic into main checkOrders flow in src/functions/checkOrdersFunction.ts
- [X] T040 [US4] Test User Story 4 in Firebase Emulator: create delivery with carrierOrder.createdAt and past pickup time, trigger checkOrders, verify state changes to IN_DELIVERY

**Checkpoint**: User Stories 1-4 independently functional - full food delivery lifecycle automated

---

## Phase 7: User Story 5 - Box Return Delivery Processing (Priority: P3)

**Goal**: Food boxes needing return from recipients to donors are processed separately with reverse logistics orders

**Independent Test**: Create BOX_DELIVERY in OFFERED state in Firestore, run checkOrders function, verify DODO order created with reversed pickup/delivery locations (recipient to donor)

### Implementation for User Story 5

- [X] T041 [P] [US5] Implement getTodaysBoxDeliveries() in src/services/deliveryService.ts to query BOX_DELIVERY type deliveries for today in OFFERED state
- [X] T042 [P] [US5] Implement updateBoxDelivery() in src/services/deliveryService.ts to update box delivery with new state, identifier, time windows, and carrierId
- [X] T043 [US5] Implement checkBoxReturnDeliveries() logic in src/functions/checkOrdersFunction.ts: load box deliveries, create reverse DODO order (pickup from recipient, delivery to donor), fixed time windows (10:00-10:30 pickup, 11:00-11:30 delivery)
- [X] T044 [US5] Integrate checkBoxReturnDeliveries() into main checkOrders flow after food delivery processing
- [X] T045 [US5] Wrap checkOrders() with onSchedule trigger (cron: "0,7,15,22,30,37,45,52 9-17 * * 1-5" alternating 7-8 min intervals, timeZone: "Europe/Prague") in src/functions/checkOrdersFunction.ts
- [X] T046 [US5] Add conditional export for checkOrdersFunction in src/index.ts (only for project "zachran-obed")
- [X] T047 [US5] Test User Story 5 in Firebase Emulator: create BOX_DELIVERY in OFFERED state, trigger checkOrders, verify DODO order with reversed locations and state changes to IN_DELIVERY

**Checkpoint**: All user stories should now be independently functional - full food and box delivery workflows automated

---

## Phase 8: Polish & Cross-Cutting Concerns

**Purpose**: Final integration, cleanup, and verification

- [X] T048 [P] Add lazy caching for entities and entity pairs in entityService.ts (module-level variables, check if null before fetching)
- [X] T049 [P] Add comprehensive error logging with delivery context (deliveryIdentifier, donorId, recipientId) throughout checkOrdersFunction.ts
- [X] T050 [P] Verify all functions follow double-quote string convention per ESLint config
- [X] T051 [P] Verify all functions have explicit return types per TypeScript strict mode
- [X] T052 Run npm run lint and fix any remaining issues
- [X] T053 Run npm run build and verify successful TypeScript compilation
- [X] T054 Update checkDeliveriesInvocatorFunction.ts: remove GitHub Actions trigger logic, add comment "Replaced by checkOrdersFunction - kept for reference"
- [X] T055 Test full workflow in Firebase Emulator following quickstart.md: sendOrders creates deliveries, checkOrders processes state transitions and creates DODO orders
- [X] T056 Test error isolation: Create delivery with missing entity reference, verify error logged and remaining deliveries process successfully
- [X] T057 Verify production-only export: Check src/index.ts exports sendOrdersFunction and checkOrdersFunction only when GCLOUD_PROJECT equals "zachran-obed"
- [X] T058 Deploy to DEV environment: `firebase use default && npm run deploy`
- [X] T059 Monitor DEV logs for 24 hours: `firebase functions:log --follow`
- [X] T060 Compare DEV results with GitHub Actions output for functional parity (run both in parallel)
- [X] T061 Document any deviations from old solution in specs/001-github-actions-migration/migration-notes.md

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Stories (Phase 3-7)**: All depend on Foundational phase completion
  - User stories CAN proceed in parallel (if staffed) after foundation ready
  - Or sequentially in priority order: US1 (P1) → US2 (P2) → US3 (P2) → US4 (P3) → US5 (P3)
- **Polish (Phase 8)**: Depends on all user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational (Phase 2) - No dependencies on other stories
- **User Story 2 (P2)**: Can start after Foundational (Phase 2) - No dependencies on other stories (independent)
- **User Story 3 (P2)**: Can start after Foundational (Phase 2) - No dependencies on other stories (independent)
- **User Story 4 (P3)**: Can start after Foundational (Phase 2) - Integrates with US3 but independently testable
- **User Story 5 (P3)**: Can start after Foundational (Phase 2) - No dependencies on other stories (separate workflow)

### Within Each User Story

- Models before services (all models in Phase 2 Foundational)
- Services before function logic
- Core implementation before integration
- Story complete before moving to next priority

### Parallel Opportunities

- All Setup tasks marked [P] (T002-T006) can run in parallel
- All Foundational tasks marked [P] (T007-T011, T013-T017) can run in parallel (within Phase 2)
- Once Foundational phase completes, **User Stories 1-5 can start in parallel** (if team capacity allows)
- Within US1: T018-T019 can run in parallel
- Within US2: T025-T026 can run in parallel
- Within US3: T030-T031 can run in parallel
- Within US5: T041-T042 can run in parallel
- Polish tasks T048-T051 can run in parallel

---

## Parallel Example: Foundational Phase

```bash
# Launch all model creation tasks together:
Task: "Create Entity model with zod schema in src/models/Entity.ts"
Task: "Create EntityPair model with zod schema in src/models/EntityPair.ts"
Task: "Create Delivery model with zod schemas in src/models/Delivery.ts"
Task: "Create DodoToken model with zod schema in src/models/DodoToken.ts"
Task: "Create DodoOrder model with zod schema in src/models/DodoOrder.ts"

# Launch all utility functions together:
Task: "Implement getNextBusinessDay() utility in src/utils/dateUtils.ts"
Task: "Implement getDateInFuture() utility in src/utils/dateUtils.ts"
Task: "Implement formatCzechDate() utility in src/utils/dateUtils.ts"
Task: "Implement getMinutesBeforePickup() utility in src/utils/dateUtils.ts"
```

## Parallel Example: User Story 3

```bash
# Launch DODO service methods together:
Task: "Implement getDodoToken() in src/services/dodoService.ts using native fetch"
Task: "Implement createDodoOrder() in src/services/dodoService.ts using native fetch"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (CRITICAL - blocks all stories)
3. Complete Phase 3: User Story 1
4. **STOP and VALIDATE**: Test User Story 1 independently in emulator
5. Deploy to DEV if ready

### Incremental Delivery

1. Complete Setup + Foundational → Foundation ready
2. Add User Story 1 → Test independently → Deploy/Demo (MVP!) - Daily delivery creation working
3. Add User Story 2 → Test independently → Deploy/Demo - Expired deliveries marked NOT_USED
4. Add User Story 3 → Test independently → Deploy/Demo - DODO orders created for confirmed deliveries
5. Add User Story 4 → Test independently → Deploy/Demo - Deliveries transition to IN_DELIVERY
6. Add User Story 5 → Test independently → Deploy/Demo - Box returns automated
7. Each story adds value without breaking previous stories

### Parallel Team Strategy

With multiple developers:

1. Team completes Setup + Foundational together
2. Once Foundational is done:
   - Developer A: User Story 1 (sendOrders function)
   - Developer B: User Story 2 + User Story 3 (checkOrders food delivery logic)
   - Developer C: User Story 4 + User Story 5 (checkOrders additional workflows)
3. Stories complete and integrate independently

---

## Notes

- [P] tasks = different files, no dependencies within that phase
- [Story] label maps task to specific user story for traceability
- Each user story should be independently completable and testable
- Commit after each task or logical group
- Stop at any checkpoint to validate story independently
- Test strategy: Manual testing in Firebase Emulator following quickstart.md
- Avoid: vague tasks, same file conflicts, cross-story dependencies that break independence
- Migration maintains identical business logic to existing GitHub Actions (functional parity requirement)

---

## Task Count Summary

- **Total Tasks**: 61
- **Phase 1 (Setup)**: 6 tasks
- **Phase 2 (Foundational)**: 11 tasks
- **Phase 3 (US1)**: 7 tasks
- **Phase 4 (US2)**: 5 tasks
- **Phase 5 (US3)**: 8 tasks
- **Phase 6 (US4)**: 3 tasks
- **Phase 7 (US5)**: 7 tasks
- **Phase 8 (Polish)**: 14 tasks

**Parallel Opportunities**: 23 tasks marked [P] can run in parallel within their phases

**Suggested MVP Scope**: Phase 1 + Phase 2 + Phase 3 (User Story 1 only) = 24 tasks
