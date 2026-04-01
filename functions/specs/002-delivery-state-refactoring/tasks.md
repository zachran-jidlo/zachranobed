# Tasks: ZOB-400 Delivery State Machine Refactoring

**Input**: Design documents from `/specs/002-delivery-state-refactoring/`
**Prerequisites**: plan.md

**Tests**: Not requested — no test tasks included.

**Organization**: Tasks grouped by functional user story derived from plan.md.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: US1=Cloud Task infrastructure, US2=Personal food delivery flow, US3=Box delivery flow, US4=Midnight finalize, US5=Cleanup

## User Stories (derived from plan)

- **US1** (P1): Cloud Task infrastructure — service + handler enabling all timed transitions
- **US2** (P2): Personal food delivery — sendOrdersFunction schedules Cloud Tasks for personal carriers
- **US3** (P3): Box delivery onCreate — Firestore trigger schedules Cloud Tasks for box deliveries
- **US4** (P4): Midnight finalize — DELIVERED → DONE + safety net for stuck states
- **US5** (P5): Cleanup — remove polling, update notifications, dead code removal

---

## Phase 1: Setup

**Purpose**: Dependencies and model/constant updates needed before any implementation

- [ ] T001 Install `@google-cloud/tasks` dependency via `npm install @google-cloud/tasks`
- [ ] T002 [P] Add `ON_WAY_TO_PICK_UP` and `DONE` states to Zod schema in `src/models/Delivery.ts` (keep `OFFERED` temporarily, mark deprecated)
- [ ] T003 [P] Add `CLOUD_TASKS_QUEUE` and `CLOUD_TASKS_LOCATION` as `defineString()` params in `src/config/firebase.ts`:
      `defineString("CLOUD_TASKS_QUEUE", { default: "delivery-state-transitions" })` and
      `defineString("CLOUD_TASKS_LOCATION", { default: "europe-west1" })`.
      Do NOT add to `constants.ts` — constitution requires `defineString()` for non-secret config params.

---

## Phase 2: Foundational — Delivery Service Updates

**Purpose**: Update shared delivery service that all stories depend on

**⚠️ CRITICAL**: Must complete before user story implementation

- [ ] T004 Add `getDeliveriesByDateAndStates(date, states)` method to `src/services/deliveryService.ts` for querying deliveries by date and multiple states
- [ ] T005 Update `getTodaysDeliveries()` in `src/services/deliveryService.ts` to include new states (`ON_WAY_TO_PICK_UP`, `DONE`) where appropriate

**Checkpoint**: Foundation ready — user story implementation can begin

---

## Phase 2.5: Infrastructure Prerequisites (manual, one-time per environment)

**Purpose**: GCP resources that must exist before Cloud Tasks can be deployed or tested. Manual step — not automated.

**⚠️ BLOCKER for Phase 3**: must be completed before deploying `cloudTaskHandler` to DEV.

- [ ] T005b [INFRA] Enable Cloud Tasks API and create the `delivery-state-transitions` queue on both GCP projects, then grant the service account the `roles/cloudfunctions.invoker` role on `cloudTaskHandler`. See Infrastructure Setup section in plan.md for exact `gcloud` commands.

---

## Phase 3: User Story 1 — Cloud Task Infrastructure (Priority: P1) 🎯 MVP

**Goal**: Create the Cloud Task service and HTTP handler that all timed transitions depend on

**Independent Test**: Deploy to DEV, manually create a Cloud Task via `gcloud tasks create-http-task`, verify handler receives payload and logs precondition check

### Implementation for User Story 1

- [ ] T006 [US1] Create `src/services/cloudTaskService.ts` with `scheduleStateTransition({ deliveryId, targetState, preconditionState, executeAt })`:
      - Uses `@google-cloud/tasks` CloudTasksClient
      - Queue: `CLOUD_TASKS_QUEUE.value()`, Location: `CLOUD_TASKS_LOCATION.value()` (`defineString` params, not constants)
      - Handler URL: `https://${CLOUD_TASKS_LOCATION.value()}-${process.env.GCLOUD_PROJECT}.cloudfunctions.net/cloudTaskHandler`
      - OIDC token: `{ serviceAccountEmail: process.env.FUNCTION_TARGET_SA ?? "", audience: handlerUrl }`
      - `scheduleTime`: set from `executeAt` param
- [ ] T007 [US1] Add `scheduleMultipleTransitions(tasks[])` convenience method to `src/services/cloudTaskService.ts` for scheduling all personal delivery tasks at once
- [ ] T008 [US1] Create `src/functions/cloudTaskHandlerFunction.ts` — `onRequest` HTTP Cloud Function (v2) that receives `{ deliveryId, targetState, preconditionState }`, loads delivery doc, guards on `state === preconditionState`, updates state or returns 200 no-op.
      Auth: IAM invoker policy only (no in-code JWT verification — do NOT grant `allUsers` invoker access).
      Errors: 400 for invalid/missing payload fields; 500 for Firestore errors (triggers Cloud Tasks retry).
- [ ] T009 [US1] Export `cloudTaskHandler` in `src/index.ts` (add alongside existing exports, do not remove anything yet)

**Checkpoint**: Cloud Task infrastructure deployed and callable — all other stories can now schedule tasks

---

## Phase 4: User Story 2 — Personal Food Delivery Cloud Tasks (Priority: P2)

**Goal**: sendOrdersFunction schedules Cloud Tasks when creating food deliveries, replacing the polling-based checkOrdersFunction for personal carriers

**Independent Test**: Run `triggerSendOrders` on DEV, verify Cloud Tasks appear in GCP Console with correct schedule times. Simulate ACCEPTED state in Firestore, verify tasks fire and transition states.

### Implementation for User Story 2

- [ ] T010 [US2] Refactor `src/functions/sendOrdersFunction.ts` — after creating each food delivery, schedule NOT_USED Cloud Task at `pickupStart - confirmationMinutes` (precondition: PREPARED) for ALL carriers (dodo + personal). Use `confirmationMinutes` from entityPair.confirmationTime or defaults from constants (DODO=45, PERSONAL=20)
- [ ] T011 [US2] In `src/functions/sendOrdersFunction.ts` — for personal carrier only, additionally schedule: ON_WAY_TO_PICK_UP at `pickupTimeWindow.start` (precondition: ACCEPTED), IN_DELIVERY at `pickupTimeWindow.end` (precondition: ON_WAY_TO_PICK_UP), DELIVERED at `deliveryTimeWindow.end` (precondition: IN_DELIVERY)

**Checkpoint**: Personal food deliveries fully driven by Cloud Tasks — no polling needed

---

## Phase 5: User Story 3 — Box Delivery onCreate Trigger (Priority: P3)

**Goal**: When the mobile app creates a box delivery document, a Firestore trigger schedules the appropriate Cloud Tasks

**Independent Test**: Create a box delivery document in Firestore emulator/DEV with `type=BOX_DELIVERY` and `carrierId=personal`, verify Cloud Tasks are scheduled. Create one with `carrierId=dodo`, verify only NOT_USED task is scheduled.

### Implementation for User Story 3

- [ ] T012 [US3] Create `src/functions/boxDeliveryCreatedFunction.ts` — Firestore `onDocumentCreated` trigger on `deliveries/{id}`, only processes `type === "BOX_DELIVERY"`. For personal carrier: schedules NOT_USED, ON_WAY_TO_PICK_UP, IN_DELIVERY, DELIVERED Cloud Tasks. For dodo carrier: schedules only NOT_USED Cloud Task.
- [ ] T013 [US3] Export `boxDeliveryCreated` in `src/index.ts`

**Checkpoint**: Box deliveries (personal + dodo) get Cloud Tasks automatically on creation

---

## Phase 6: User Story 4 — Midnight Finalize Function (Priority: P4)

**Goal**: End-of-day function transitions DELIVERED → DONE and catches stuck states as safety net

**Independent Test**: Manually set a delivery to DELIVERED state, run `triggerFinalizeDeliveries` on DEV, verify it transitions to DONE. Set a delivery to PREPARED, verify safety net transitions to NOT_USED.

### Implementation for User Story 4

- [ ] T014 [US4] Create `src/functions/finalizeDeliveriesFunction.ts` — scheduled at `0 0 * * *` (midnight, timezone: `Europe/Prague`, daily). Three passes (all date-filtered to today only):
      1. DELIVERED → DONE
      2. Safety net: PREPARED → NOT_USED (Cloud Task missed)
      3. Warning log: ACCEPTED deliveries where `deliveryTimeWindow.end < now` — log IDs, no auto-transition
      Logs count of each transition made.
- [ ] T015 [US4] Export `finalizeDeliveries` in `src/index.ts` **conditionally** (production-only):
      `if (process.env.GCLOUD_PROJECT === "zachran-obed") { exports.finalizeDeliveries = ... }`
      Same pattern used by `sendOrdersFunction`.
- [ ] T016 [US4] Add `triggerFinalizeDeliveries` dev HTTP trigger in `src/index.ts` (DEV environment only, similar to existing `triggerSendOrders`)

**Checkpoint**: Full delivery lifecycle works end-to-end: PREPARED → ... → DELIVERED → DONE

---

## Phase 7: User Story 5 — Cleanup & Migration (Priority: P5)

**Goal**: Remove deprecated polling function, update notification triggers, remove dead code

**Independent Test**: `npm run build` succeeds, `npm run lint` passes, no references to `checkOrdersFunction` or `OFFERED` (except deprecated Zod schema entry)

### Implementation for User Story 5

- [ ] T017 [US5] Review and update `src/functions/notifications/foodDeliveryFunction.ts` — remove any OFFERED state references, verify ACCEPTED/NOT_USED triggers still work with new flow
- [ ] T018 [P] [US5] Review and update remaining notification functions in `src/functions/notifications/` (boxReturnFunction.ts, lackOfBoxesFunction.ts, monthlyBoxCheckupFunction.ts) — remove OFFERED references if any
- [ ] T019 [US5] Remove `checkOrdersFunction` and `scheduledFunctionCrontab` exports from `src/index.ts`, remove `triggerCheckOrders` dev trigger
- [ ] T020 [US5] Delete `src/functions/checkOrdersFunction.ts`
- [ ] T021 [P] [US5] Delete `src/functions/checkDeliveriesInvocatorFunction.ts`
- [ ] T022 [US5] Remove OFFERED-specific logic from `src/services/deliveryService.ts` (remove old box delivery processing that was handled by checkOrders)
- [ ] T023 [US5] Remove dead imports across all modified files, run `npm run lint:fix` and `npm run build` to verify clean compilation
- [ ] T023b [POST-MIGRATION] After PROD validation: remove `OFFERED` from Zod schema in `src/models/Delivery.ts`.
      **Do NOT do this in the current PR.** Add `// TODO(post-migration): remove OFFERED` comment in T002 output as a reminder.

**Checkpoint**: Codebase clean, no dead code, build and lint pass

---

## Dependencies & Execution Order

### Phase Dependencies

- **Phase 1 (Setup)**: No dependencies — start immediately
- **Phase 2 (Foundational)**: Depends on T002 (model updates)
- **Phase 2.5 (Infrastructure)**: No code dependency — can be done in parallel with Phase 1/2, but must complete before deploying Phase 3
- **Phase 3 (US1 - Cloud Tasks)**: Depends on Phase 1 + Phase 2 + Phase 2.5 (T005b must be done in GCP before deploy)
- **Phase 4 (US2 - Food)**: Depends on Phase 3 (needs cloudTaskService + handler)
- **Phase 5 (US3 - Box)**: Depends on Phase 3 (needs cloudTaskService + handler)
- **Phase 6 (US4 - Finalize)**: Depends on Phase 2 (needs deliveryService queries)
- **Phase 7 (US5 - Cleanup)**: Depends on Phases 4, 5, 6 all complete

### Parallel Opportunities

- T002 + T003 can run in parallel (different files)
- T004 + T005 can run in parallel (same file but different methods)
- Phase 4 (US2) + Phase 5 (US3) + Phase 6 (US4) can run in parallel after Phase 3
- T017 + T018 can run in parallel (different notification files)
- T020 + T021 can run in parallel (independent file deletions)

```
Phase 1: T001 → T002 ─┐
                T003 ─┤
                      ▼
Phase 2: T004, T005
                      │
                      ▼
Phase 3: T006 → T007 → T008 → T009
                      │
              ┌───────┼───────┐
              ▼       ▼       ▼
Phase 4:   T010-T011  │    Phase 6: T014-T016
              │    T012-T013
              │       │       │
              ▼       ▼       ▼
Phase 7: T017 → T018 → T019 → T020/T021 → T022 → T023
```

---

## Implementation Strategy

### MVP First (US1 Only)

1. Complete Phase 1: Setup (T001-T003)
2. Complete Phase 2: Foundational (T004-T005)
3. Complete Phase 3: US1 Cloud Task Infrastructure (T006-T009)
4. **STOP and VALIDATE**: Deploy to DEV, test handler via HTTP

### Incremental Delivery

1. Setup + Foundational + US1 → Cloud Task infra ready
2. Add US2 (food delivery tasks) → Test with triggerSendOrders on DEV
3. Add US3 (box delivery trigger) → Test with manual Firestore doc creation
4. Add US4 (midnight finalize) → Test with triggerFinalizeDeliveries
5. Add US5 (cleanup) → Final build/lint validation
6. Each story adds value without breaking previous stories

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story
- Total tasks: 25 (23 implementation + T005b infrastructure + T023b post-migration)
- Tasks per story: US1=4, US2=2, US3=2, US4=3, US5=8, Setup=3, Foundational=2, Infra=1
- Infrastructure setup (GCP Cloud Tasks queue, IAM roles) is a manual prerequisite — see plan.md
- During migration: checkOrdersFunction can run alongside new Cloud Tasks (precondition guards prevent conflicts)
