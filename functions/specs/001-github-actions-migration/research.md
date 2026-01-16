# Research: GitHub Actions Migration

**Date**: 2026-01-16
**Feature**: 001-github-actions-migration

## Technology Decisions

### 1. HTTP Client: Native Fetch vs Axios

**Decision**: Use native `fetch` API for DODO API communication

**Rationale**:
- Node.js 18+ includes native fetch implementation (no external dependency)
- Simpler error handling with try-catch around async/await
- Reduces bundle size by removing axios dependency
- Standard Web API - same interface as browser fetch
- Sufficient for OAuth2 flow and simple POST requests

**Alternatives Considered**:
- **Axios** (current solution): Mature library with interceptors and automatic JSON parsing. Rejected because it adds dependency weight and the project doesn't need advanced features like request/response interceptors, progress tracking, or XSRF protection.
- **node-fetch**: Polyfill for older Node versions. Rejected because Node.js 20 has native fetch built-in.
- **undici**: Low-level HTTP client used internally by Node.js. Rejected as overkill for simple API calls.

**Implementation Notes**:
- Use `AbortController` for timeout handling (30 second timeout for DODO API)
- Manual JSON parsing required: `await response.json()`
- Status code checking: `if (!response.ok) throw new Error(...)`
- Headers passed as plain object: `{ "Authorization": "Bearer ...", "Content-Type": "application/json" }`

**Code Pattern**:
```typescript
const response = await fetch(url, {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${token}`,
    "Content-Type": "application/json"
  },
  body: JSON.stringify(payload),
  signal: AbortSignal.timeout(30000)
});

if (!response.ok) {
  throw new Error(`DODO API error: ${response.status} ${response.statusText}`);
}

const data = await response.json();
```

---

### 2. Runtime Type Validation: Zod vs Runtypes

**Decision**: Migrate from runtypes to zod for runtime type checking

**Rationale**:
- Zod has better TypeScript integration with type inference
- More active maintenance and larger community (1M+ weekly downloads vs 100K for runtypes)
- Better error messages with `.parse()` vs `.check()`
- Supports schema composition, refinements, and transformations
- Industry standard for runtime validation in TypeScript ecosystem

**Alternatives Considered**:
- **Runtypes** (current solution): Works well but less feature-rich. Rejected in favor of more modern, actively maintained solution.
- **io-ts**: Similar to runtypes with functional programming approach. Rejected due to steeper learning curve and less intuitive API.
- **TypeBox**: JSON Schema first approach. Rejected because zod's TypeScript-first design is more natural for this codebase.
- **No runtime validation**: TypeScript compile-time only. Rejected because DODO API responses and Firestore data need runtime validation to catch unexpected data shapes.

**Implementation Notes**:
- Define schemas with `z.object()`, `z.string()`, `z.number()`, etc.
- Use `.parse()` for validation that throws on error (for API responses)
- Use `.safeParse()` for validation with error handling (when needed)
- Type inference: `type DodoToken = z.infer<typeof DodoTokenSchema>`
- Enums: `z.enum(['PREPARED', 'OFFERED', 'ACCEPTED', ...])`

**Code Pattern**:
```typescript
import { z } from "zod";

// Define schema
export const DodoTokenSchema = z.object({
  token_type: z.literal("Bearer"),
  expires_in: z.number(),
  ext_expires_in: z.number(),
  access_token: z.string()
});

// Infer TypeScript type
export type DodoToken = z.infer<typeof DodoTokenSchema>;

// Validate API response
const dodoTokenResponse = await fetch(...);
const data = await dodoTokenResponse.json();
const token = DodoTokenSchema.parse(data); // Throws if invalid
```

**Migration from Runtypes**:
| Runtypes | Zod Equivalent |
|----------|----------------|
| `Record({ field: String })` | `z.object({ field: z.string() })` |
| `String` | `z.string()` |
| `Number` | `z.number()` |
| `Literal("value")` | `z.literal("value")` |
| `Array(Type)` | `z.array(Type)` |
| `Optional(Type)` | `Type.optional()` |
| `InstanceOf(Timestamp)` | `z.instanceof(Timestamp)` |
| `.check(data)` | `.parse(data)` |
| `Static<typeof RT>` | `z.infer<typeof Schema>` |

---

### 3. Scheduled Functions: onSchedule vs GitHub Actions

**Decision**: Use Firebase Functions v2 `onSchedule` trigger

**Rationale**:
- Native to Firebase ecosystem - no external service coordination
- Direct access to Firestore without authentication overhead
- Automatic retry and error handling via Cloud Functions runtime
- Cost-effective: billed only for execution time
- Easier secret management via `defineString()` from `firebase-functions/params`

**Alternatives Considered**:
- **GitHub Actions** (current solution): Free for public repos, requires Firestore authentication. Rejected because it adds external dependency, requires managing service account keys in GitHub Secrets, and has unnecessary network latency between GitHub and Firebase.
- **Cloud Scheduler + HTTPS Function**: More control over retry logic. Rejected as unnecessarily complex - `onSchedule` provides same capabilities with less boilerplate.
- **Pub/Sub + Cloud Function**: Over-engineered for simple cron patterns. Rejected for added complexity.

**Implementation Notes**:
- Cron syntax identical to GitHub Actions: `"0 7 * * 1-5"` (7 AM UTC weekdays)
- Timezone handling: Use `{schedule: "...", timeZone: "UTC"}` option
- Conditional export: Check `process.env.GCLOUD_PROJECT === "zachran-obed"` before exporting scheduled function

**Code Pattern**:
```typescript
import { onSchedule } from "firebase-functions/v2/scheduler";

export const sendOrdersFunction = onSchedule(
  {
    schedule: "0 7 * * 1-5",
    timeZone: "UTC"
  },
  async (event) => {
    // Implementation
  }
);
```

---

### 4. Date Handling: Manual Calculation vs date-fns

**Decision**: Use manual Date calculations with utility functions

**Rationale**:
- Existing codebase already has date utilities in `utils/dateUtils.ts`
- Simple requirements: add days, skip weekends, format locale strings
- No need for complex timezone conversions (UTC-based)
- Avoids adding date-fns dependency (47KB minified)

**Alternatives Considered**:
- **date-fns**: Comprehensive date library with 200+ functions. Rejected as overkill for basic date arithmetic and increases bundle size.
- **Luxon**: Immutable date library with timezone support. Rejected for similar reasons - too much functionality for simple use case.
- **Day.js**: Lightweight alternative to moment.js. Rejected because manual calculations are sufficient.

**Implementation Notes**:
- Create `getNextBusinessDay(daysInFuture: number)` utility
- Create `getDateInFuture(days: number, timeString?: string)` utility
- Use `Date.setTime()` and `getTime()` for millisecond-based calculations
- Czech locale formatting: `date.toLocaleDateString('cs')`

**Code Pattern**:
```typescript
export function getNextBusinessDay(daysInFuture: number = 1): Date {
  const date = new Date();
  date.setDate(date.getDate() + daysInFuture);

  // Skip weekends
  while (date.getDay() === 0 || date.getDay() === 6) {
    date.setDate(date.getDate() + 1);
  }

  return date;
}
```

---

### 5. Error Handling: Continue vs Stop on Failure

**Decision**: Log errors and continue processing remaining items

**Rationale**:
- Maximize successful deliveries even if some fail
- Firestore batch operations not used (each delivery processed independently)
- Errors isolated per delivery - one failure doesn't affect others
- Comprehensive logging for debugging failed items

**Alternatives Considered**:
- **Stop on first error**: Simpler error handling. Rejected because it would block all remaining deliveries if one entity is misconfigured.
- **Batch with rollback**: Atomic operations across all deliveries. Rejected because partial success is acceptable and preferred over all-or-nothing.
- **Retry with exponential backoff**: Handle transient failures. Rejected as Cloud Functions already retries on failure; added complexity not needed.

**Implementation Notes**:
- Wrap each delivery iteration in try-catch
- Log error with delivery context (deliveryIdentifier, donorId, recipientId)
- Increment success counter only on successful processing
- Report total handled vs total found at end

**Code Pattern**:
```typescript
for (const delivery of deliveries) {
  try {
    await processDelivery(delivery);
    handledCount++;
  } catch (error) {
    console.error(`Failed to process delivery ${delivery.deliveryIdentifier}:`, error);
  }
}

console.log(`Processed ${handledCount}/${deliveries.length} deliveries`);
```

---

### 6. Service Layer: Caching vs Fresh Queries

**Decision**: Implement lazy caching for entities and entity pairs within a single function execution

**Rationale**:
- Entities and entity pairs don't change during function execution
- Reduces Firestore reads (cost savings)
- Existing pattern from old_solution works well
- Cache scope limited to single function invocation

**Alternatives Considered**:
- **No caching**: Query Firestore for every delivery. Rejected due to unnecessary cost and latency - data is immutable within execution.
- **Redis caching**: External cache across invocations. Rejected as overkill for simple in-memory cache valid for seconds.
- **Firestore offline persistence**: Client-side caching. Rejected because server-side functions don't benefit from offline persistence.

**Implementation Notes**:
- Module-level variables for cache: `let cachedEntities: Entity[] | null = null`
- Lazy load on first access: check if null, fetch if needed
- No cache invalidation needed (scoped to function execution)
- Both `checkOrdersFunction` operations share the cache

**Code Pattern**:
```typescript
let cachedEntities: Entity[] | null = null;
let cachedEntityPairs: EntityPair[] | null = null;

export async function getEntitiesCached(): Promise<Entity[]> {
  if (cachedEntities === null) {
    cachedEntities = await getEntities();
  }
  return cachedEntities;
}
```

---

## Integration Patterns

### DODO API OAuth2 Flow

1. Request token with client credentials
2. Parse `access_token` and `expires_in` from response using zod schema validation
3. Use token for order creation within same function execution
4. No token caching across invocations (simple stateless approach)

### Firestore Query Patterns

1. **Entity Pairs**: `where('carrierId', '!=', 'disabled')`
2. **Today's Deliveries**: `where('pickupTimeWindow.start', '>', todayStart).where('pickupTimeWindow.start', '<', todayEnd)`
3. **State-based Filtering**: `where('state', 'in', ['PREPARED', 'OFFERED', 'ACCEPTED'])`
4. **Box Returns**: `where('type', '==', 'BOX_DELIVERY').where('deliveryDate', '>=', todayStart)`

### State Transition Logic

```
PREPARED --[deadline passed]--> NOT_USED
PREPARED --[confirmed by app]--> OFFERED
OFFERED --[create DODO order]--> OFFERED (with carrierOrder.createdAt)
OFFERED --[pickup end time passed]--> IN_DELIVERY
ACCEPTED --[create DODO order]--> ACCEPTED (with carrierOrder.createdAt)
ACCEPTED --[pickup end time passed]--> IN_DELIVERY
```

## Best Practices Applied

1. **Runtime Validation**: Use zod schemas to validate DODO API responses
2. **Secrets Management**: Use `defineString()` for DODO credentials (not hardcoded)
3. **Error Logging**: Include context (deliveryIdentifier, timestamp) in all error messages
4. **Conditional Export**: Production-only functions check project ID before export
5. **Timeout Handling**: 30-second timeout for external API calls
6. **Idempotency**: Check for existing `carrierOrder.createdAt` before creating DODO order
7. **Graceful Degradation**: Skip DODO order for 'personal' carrier, continue on API errors

## Migration Strategy

1. Keep `old_solution/` directory during development for reference
2. Add zod to dependencies: `npm install zod`
3. Test functions in emulator with seed data before deploying
4. Deploy to DEV environment first, verify logs
5. Run both old (GitHub Actions) and new (Cloud Functions) in parallel for 1 week
6. Compare Firestore results to ensure parity
7. Switch PROD to Cloud Functions only
8. Delete GitHub Actions workflows and `old_solution/` directory
