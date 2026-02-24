# ZOB-400: Delivery State Machine Refactoring

## Summary

Refactor the delivery state machine in Firebase Cloud Functions to:
1. Remove the `OFFERED` state (PREPARED → ACCEPTED directly)
2. Add `ON_WAY_TO_PICK_UP` and `DONE` states
3. Replace polling (`checkOrdersFunction`) with event-driven architecture using Cloud Tasks and Firestore triggers
4. Support two distinct flows: **DODO** (external webhook writes to Firestore, handled in separate branch) and **Personal** (time-based Cloud Tasks)

## Scope

**In scope:** Firebase Cloud Functions only (backend)
**Out of scope:**
- Flutter app changes (tracked separately)
- DODO webhook/orders endpoint (handled in separate branch — do not implement here)
- DODO status trigger function (depends on webhook branch)

---

## New State Machine

### States

```
PREPARED → ACCEPTED → ON_WAY_TO_PICK_UP → IN_DELIVERY → DELIVERED → DONE
    ↓
 NOT_USED
```

### State Transition Responsibility Matrix

| State | Food+Personal | Food+DODO | Box+Personal | Box+DODO |
|-------|--------------|-----------|-------------|----------|
| PREPARED | Firebase Function (sendOrders) | Firebase Function (sendOrders) | Mobile app | Mobile app |
| NOT_USED | Cloud Task (pickupStart - confirmationMin) | Cloud Task (pickupStart - confirmationMin) | Cloud Task | Cloud Task |
| ACCEPTED | Mobile app | Mobile app | Mobile app | Mobile app |
| ON_WAY_TO_PICK_UP | Cloud Task (pickupStart) | Carrier webhook* | Cloud Task | Carrier webhook* |
| IN_DELIVERY | Cloud Task (pickupEnd) | Carrier webhook* | Cloud Task | Carrier webhook* |
| DELIVERED | Cloud Task (deliveryEnd) | Carrier webhook* | Cloud Task | Carrier webhook* |
| DONE | Firebase Function (midnight) | Firebase Function (midnight) | Firebase Function (midnight) | Firebase Function (midnight) |

*Carrier webhook = separate branch, not implemented here.

Cloud Tasks scheduled by:
- `sendOrdersFunction` → for Food deliveries (both carriers)
- `boxDeliveryCreatedFunction` (onCreate trigger) → for Box deliveries (both carriers)

### DODO Food Delivery Flow (state transitions managed by external webhook — out of scope)

```
16:00 day before: sendOrders (Firebase Function) creates delivery (PREPARED)
                  + schedules Cloud Task for NOT_USED at (pickupStart - confirmationMinutes)

User accepts:    PREPARED → ACCEPTED (mobile app)
                 Firestore trigger fires → creates DODO order via API (separate branch)

DODO webhook:    Updates delivery states via external endpoint (separate branch)
                 ON_WAY_TO_PICK_UP → IN_DELIVERY → DELIVERED

Midnight:        Firebase Function → DELIVERED → DONE
```

### DODO Box Return Flow (state transitions managed by external webhook — out of scope)

```
App creates box delivery on-demand (mobile app → PREPARED)
Firestore onCreate trigger → schedules NOT_USED Cloud Task

DODO webhook manages: ON_WAY_TO_PICK_UP → IN_DELIVERY → DELIVERED (separate branch)

Midnight: Firebase Function → DELIVERED → DONE
```

### Personal Food Delivery Flow

```
16:00 day before: sendOrders (Firebase Function) creates delivery (PREPARED)
                  + schedules Cloud Task for NOT_USED at (pickupStart - confirmationMinutes)
                  + schedules Cloud Task for ON_WAY_TO_PICK_UP at pickupStart (precondition: ACCEPTED)
                  + schedules Cloud Task for IN_DELIVERY at pickupEnd (precondition: ON_WAY_TO_PICK_UP)
                  + schedules Cloud Task for DELIVERED at deliveryEnd (precondition: IN_DELIVERY)

User accepts:    PREPARED → ACCEPTED (mobile app)

Cloud Task:      At (pickupStart - confirmationMinutes) → if PREPARED → NOT_USED
Cloud Task:      At pickupStart → if ACCEPTED → ON_WAY_TO_PICK_UP (no-op if NOT_USED)
Cloud Task:      At pickupEnd → if ON_WAY_TO_PICK_UP → IN_DELIVERY
Cloud Task:      At deliveryEnd → if IN_DELIVERY → DELIVERED

Midnight:        Firebase Function → DELIVERED → DONE
```

### Personal Box Return Flow

```
App creates box delivery on-demand (mobile app → PREPARED)
Firestore onCreate trigger detects new box delivery with carrierId=personal:
  + schedules Cloud Task for NOT_USED at (pickupStart - confirmationMinutes) (precondition: PREPARED)
  + schedules Cloud Task for ON_WAY_TO_PICK_UP at pickupStart (precondition: ACCEPTED)
  + schedules Cloud Task for IN_DELIVERY at pickupEnd (precondition: ON_WAY_TO_PICK_UP)
  + schedules Cloud Task for DELIVERED at deliveryEnd (precondition: IN_DELIVERY)

Cloud Tasks execute same as personal food delivery flow.

Midnight: Firebase Function → DELIVERED → DONE
```

### Late Acceptance Behavior

If the donor accepts **after** the `ON_WAY_TO_PICK_UP` Cloud Task has already fired (and was a no-op because state was still PREPARED):
- The delivery stays in `ACCEPTED` state
- Subsequent Cloud Tasks (IN_DELIVERY, DELIVERED) will also be no-ops (precondition mismatch)
- The midnight finalize function treats lingering `ACCEPTED` as a stuck delivery and can log a warning
- This is the expected behavior — donor accepted too late for the time windows

---

## Architecture Changes

### New Dependencies

- `@google-cloud/tasks` - For scheduling Cloud Tasks
- Cloud Tasks API must be enabled in GCP project

### New Files

| File | Purpose |
|------|---------|
| `src/services/cloudTaskService.ts` | Create Cloud Tasks for scheduled state transitions |
| `src/functions/cloudTaskHandlerFunction.ts` | HTTP endpoint invoked by Cloud Tasks to execute state transitions |
| `src/functions/boxDeliveryCreatedFunction.ts` | Firestore `onCreate` trigger on `deliveries` — schedules Cloud Tasks for new personal box deliveries |
| `src/functions/finalizeDeliveriesFunction.ts` | Midnight scheduled function: DELIVERED → DONE, safety net for stuck states |

### Modified Files

| File | Changes |
|------|---------|
| `src/index.ts` | Export new functions, remove `checkOrdersFunction` |
| `src/models/Delivery.ts` | Add `ON_WAY_TO_PICK_UP`, `DONE` states; remove `OFFERED` |
| `src/services/deliveryService.ts` | Add queries for new states, remove OFFERED-related logic |
| `src/functions/sendOrdersFunction.ts` | Schedule Cloud Tasks when creating personal food deliveries; schedule NOT_USED task for all deliveries |
| `src/config/constants.ts` | Add Cloud Tasks config constants |
| `src/functions/notifications/*.ts` | Update any OFFERED state references |

### Removed/Deprecated

| File | Action |
|------|--------|
| `src/functions/checkOrdersFunction.ts` | **Remove** — replaced by Cloud Tasks + Firestore triggers |
| `src/functions/checkDeliveriesInvocatorFunction.ts` | **Remove** — already deprecated legacy |

---

## Implementation Tasks (ordered by dependency)

### Task 1: Update Delivery Model & Constants

**Files:** `src/models/Delivery.ts`, `src/config/constants.ts`

- Add states to Zod schema: `ON_WAY_TO_PICK_UP`, `DONE`
- Keep `OFFERED` in schema temporarily (read old docs) but mark as deprecated
- Add params via `defineString()` in `src/config/firebase.ts` (or a new `src/config/params.ts`):
  - `CLOUD_TASKS_QUEUE = defineString("CLOUD_TASKS_QUEUE", { default: "delivery-state-transitions" })`
  - `CLOUD_TASKS_LOCATION = defineString("CLOUD_TASKS_LOCATION", { default: "europe-west1" })`
- Note: these are non-secret config params — use `defineString()`, not the constants file. Set corresponding values in `.env` files / Firebase config for each environment.

### Task 2: Create Cloud Task Service

**File:** `src/services/cloudTaskService.ts`

```typescript
interface ScheduleTransitionParams {
  deliveryId: string;
  targetState: string;
  preconditionState: string;
  executeAt: Date;  // When the task should run
}

function scheduleStateTransition(params: ScheduleTransitionParams): Promise<string>
// Returns the Cloud Task name for tracking

function scheduleMultipleTransitions(tasks: ScheduleTransitionParams[]): Promise<string[]>
// Convenience for scheduling all personal delivery tasks at once
```

- Uses `@google-cloud/tasks` CloudTasksClient
- Constructs HTTP request targeting the `cloudTaskHandler` function URL:
  `https://${CLOUD_TASKS_LOCATION.value()}-${process.env.GCLOUD_PROJECT}.cloudfunctions.net/cloudTaskHandler`
- Reads queue and location via `CLOUD_TASKS_QUEUE.value()` / `CLOUD_TASKS_LOCATION.value()` (`defineString` params)
- Derives project ID from `process.env.GCLOUD_PROJECT`
- Sets `scheduleTime` from `executeAt`
- OIDC token: `{ serviceAccountEmail: process.env.FUNCTION_TARGET_SA ?? "", audience: handlerUrl }`

### Task 3: Create Cloud Task Handler Function

**File:** `src/functions/cloudTaskHandlerFunction.ts`

- `onRequest` HTTP Cloud Function (v2)
- Receives JSON payload: `{ deliveryId, targetState, preconditionState }`
- Validates payload
- Loads delivery document from Firestore
- **Guard:** Only transitions if `delivery.state === preconditionState`
  - If mismatch → log info ("skipping, state is {current} not {expected}") and return 200
- Updates delivery state via `deliveryService.updateDeliveryState()`
- Returns 200 on success
- Error handling: return 400 for missing/invalid payload fields; return 500 (and let Cloud Tasks retry) for Firestore errors or delivery-not-found
- Authentication strategy: **IAM invoker policy only** (no in-code token verification needed).
  - The `cloudTaskHandler` function is deployed WITHOUT `invoker: "allUsers"` — only the Cloud Tasks service account (granted `roles/cloudfunctions.invoker`) can call it.
  - Firebase Functions v2 enforces this automatically when no public access is granted.
  - Do NOT add manual JWT/OIDC verification in function code — IAM handles it.
  - Required IAM binding is documented in the Infrastructure Setup section.

### Task 4: Refactor sendOrdersFunction

**File:** `src/functions/sendOrdersFunction.ts`

After creating each delivery document:

**For ALL carriers (dodo + personal):**
- Schedule NOT_USED Cloud Task at `pickupStart - confirmationMinutes` with precondition `PREPARED`
  - `confirmationMinutes` = `entityPair.confirmationTime ?? CONFIRMATION_MINUTES[carrierId]` where defaults are DODO=45, PERSONAL=20. EntityPair value takes precedence; constant is the fallback.

**For personal carrier only:**
- Schedule ON_WAY_TO_PICK_UP at `pickupTimeWindow.start` with precondition `ACCEPTED`
- Schedule IN_DELIVERY at `pickupTimeWindow.end` with precondition `ON_WAY_TO_PICK_UP`
- Schedule DELIVERED at `deliveryTimeWindow.end` with precondition `IN_DELIVERY`

**For dodo carrier:**
- No additional Cloud Tasks (state transitions handled by webhook in separate branch)

### Task 5: Create Box Delivery Created Function

**File:** `src/functions/boxDeliveryCreatedFunction.ts`

- Firestore `onDocumentCreated` trigger on `deliveries/{id}`
- Only processes documents where `type === "BOX_DELIVERY"`
- **For personal carrier (`carrierId === "personal"`):**
  - Schedules same Cloud Tasks as personal food delivery (NOT_USED, ON_WAY_TO_PICK_UP, IN_DELIVERY, DELIVERED)
- **For dodo carrier (`carrierId === "dodo"`):**
  - Schedules only NOT_USED Cloud Task
  - (DODO webhook handles remaining transitions — separate branch)

### Task 6: Create Finalize Deliveries Function

**File:** `src/functions/finalizeDeliveriesFunction.ts`

- Scheduled function: `0 0 * * *` (midnight, timezone: `Europe/Prague`, daily including weekends to catch Friday deliveries)
- Three passes (all date-filtered to today only):
  1. **DELIVERED → DONE**: query today's DELIVERED deliveries, transition each to DONE
  2. **Safety net PREPARED → NOT_USED**: query today's PREPARED deliveries (Cloud Task missed), transition to NOT_USED
  3. **Stuck ACCEPTED warning**: query today's ACCEPTED deliveries where `deliveryTimeWindow.end < now`, log warning with delivery IDs. Do NOT auto-transition — donor accepted too late, human review needed.
- Logs count of each transition made

### Task 7: Update index.ts & Remove checkOrdersFunction

**File:** `src/index.ts`

Export new functions:
- `cloudTaskHandler` — HTTP (needs `invoker` role for Cloud Tasks service account)
- `boxDeliveryCreated` — Firestore onCreate trigger
- `finalizeDeliveries` — scheduled, **production-only** (wrap in `GCLOUD_PROJECT === "zachran-obed"` guard, same pattern as `sendOrdersFunction`)

Remove exports:
- `checkOrdersFunction`
- `scheduledFunctionCrontab` (legacy)

Update dev triggers:
- Keep `triggerSendOrders`
- Replace `triggerCheckOrders` with `triggerFinalizeDeliveries` for testing

### Task 8: Update deliveryService

**File:** `src/services/deliveryService.ts`

- Update `getTodaysDeliveries()` to support new states
- Add `getDeliveriesByDateAndStates(date, states)` for finalize function
- Remove any OFFERED-specific logic
- Remove box delivery processing from old flow (now handled by onCreate trigger)

### Task 9: Update Notification Functions

**Files:** `src/functions/notifications/*.ts`

- Review `notifyCharityAboutDonationV2` — currently triggers on ACCEPTED/NOT_USED state changes. Verify it still works with new flow (it should, since ACCEPTED still exists)
- Remove any references to `OFFERED` state
- Ensure notification triggers don't conflict with new Cloud Task handler

### Task 10: Cleanup

- Delete `src/functions/checkOrdersFunction.ts`
- Delete `src/functions/checkDeliveriesInvocatorFunction.ts`
- Remove DODO-order-creation logic from deleted files (DODO order creation will be in separate webhook branch)
- Update ESLint/build to ensure no dead imports

---

## Infrastructure Setup Required

### Google Cloud Tasks

```bash
# Enable API (both projects)
gcloud services enable cloudtasks.googleapis.com --project=zachran-obed-dev
gcloud services enable cloudtasks.googleapis.com --project=zachran-obed

# Create queue (both projects)
gcloud tasks queues create delivery-state-transitions \
  --location=europe-west1 \
  --max-attempts=3 \
  --min-backoff=10s \
  --max-backoff=300s \
  --max-retry-duration=600s \
  --project=zachran-obed-dev

gcloud tasks queues create delivery-state-transitions \
  --location=europe-west1 \
  --max-attempts=3 \
  --min-backoff=10s \
  --max-backoff=300s \
  --max-retry-duration=600s \
  --project=zachran-obed

# Grant invoker role to service account (so Cloud Tasks can call the handler)
# DEV:
gcloud functions add-invoker-policy-binding cloudTaskHandler \
  --region=europe-west1 \
  --member="serviceAccount:firebase-adminsdk-ju14s@zachran-obed-dev.iam.gserviceaccount.com" \
  --project=zachran-obed-dev

# PROD:
gcloud functions add-invoker-policy-binding cloudTaskHandler \
  --region=europe-west1 \
  --member="serviceAccount:firebase-adminsdk-gd4ef@zachran-obed.iam.gserviceaccount.com" \
  --project=zachran-obed
```

---

## Migration Strategy

1. **Deploy new functions alongside old** — Both `checkOrdersFunction` and new Cloud Task system can coexist temporarily since precondition checks prevent double transitions
2. **Test on DEV emulator** — Note: Cloud Tasks don't work in emulator; test handler function directly via HTTP
3. **Deploy to DEV** — Test full Cloud Task flow with real GCP
4. **Verify for a few days** — Monitor logs, ensure all transitions happen correctly
5. **Remove `checkOrdersFunction`** — Once confident
6. **Deploy to PROD**

### Backward Compatibility

- Keep `OFFERED` in Zod schema for reading existing documents (remove after migration window)
- Existing `OFFERED` deliveries: midnight finalize treats them as stuck and logs warning
- `checkOrdersFunction` can run in parallel during migration (precondition guards prevent conflicts)

---

## Risks & Mitigations

| Risk | Mitigation |
|------|------------|
| Cloud Tasks unavailable in emulator | Test handler function directly via HTTP calls during local dev |
| Cloud Task handler fails | 3 retries with backoff; precondition check prevents double transitions |
| Stuck deliveries (all tasks no-op) | Midnight finalize function catches and logs stuck states |
| Race: donor accepts while NOT_USED task runs | Firestore transaction or precondition check (only if PREPARED) |
| Cost | Cloud Tasks free tier covers <1M ops/month; we create ~20-50 tasks/day |
| Late acceptance after time windows pass | Expected behavior — delivery stays in ACCEPTED, logged as warning at midnight |

---

## Dependency on Other Branches

- **DODO webhook/orders branch:** Handles DODO order creation on ACCEPTED and DODO status webhook endpoint. This plan schedules NOT_USED Cloud Tasks for DODO deliveries but does NOT handle DODO state transitions (ON_WAY_TO_PICK_UP, IN_DELIVERY, DELIVERED for DODO).
- **Flutter app changes:** Must update to remove OFFERED state from UI flow, go directly PREPARED → ACCEPTED. Tracked separately.
