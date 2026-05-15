# Quickstart: GitHub Actions Migration

**Date**: 2026-01-16
**Feature**: 001-github-actions-migration

## Prerequisites

- Node.js v20 installed
- Firebase CLI installed (`npm install -g firebase-tools`)
- Firebase project access (zachran-obed-dev for testing)
- VS Code or preferred TypeScript IDE

## Initial Setup

### 1. Install Dependencies

```bash
cd functions
npm install

# Add new dependency for runtime validation
npm install zod
```

### 2. Configure Firebase Project

```bash
# Verify current project
firebase use

# Switch to DEV for testing
firebase use default

# Verify service account matches DEV in src/config/firebase.ts
# Should be: firebase-adminsdk-ju14s@zachran-obed-dev.iam.gserviceaccount.com
```

### 3. Configure Secrets

Set up DODO API secrets in Firebase (one-time setup):

```bash
# Set DODO OAuth2 credentials
firebase functions:secrets:set DODO_CLIENT_ID
firebase functions:secrets:set DODO_CLIENT_SECRET
firebase functions:secrets:set DODO_OAUTH_URI
firebase functions:secrets:set DODO_SCOPE
firebase functions:secrets:set DODO_ORDERS_API

# Verify secrets are set
firebase functions:secrets:access DODO_CLIENT_ID --project=zachran-obed-dev
```

**Secret Values** (for DEV environment):
- `DODO_CLIENT_ID`: Get from DODO dashboard or project lead
- `DODO_CLIENT_SECRET`: Get from DODO dashboard (keep secure)
- `DODO_OAUTH_URI`: `https://auth.dodo.cz/oauth/token`
- `DODO_SCOPE`: `delivery:create`
- `DODO_ORDERS_API`: `https://api.dodo.cz/v1/orders`

## Development Workflow

### 1. Code Generation and Linting

```bash
# TypeScript compilation
npm run build

# Watch mode (rebuilds on file changes)
npm run build:watch

# Linting
npm run lint

# Auto-fix lint issues
npm run lint:fix
```

### 2. Local Testing with Emulator

```bash
# Start emulator with seed data import/export
npm run serve

# Or manually with custom seed path
firebase emulators:start --import seed/export-for-emulator/2026-03-26T12:11:37_86276/ --export-on-exit seed/export-for-emulator/2026-03-26T12:11:37_86276/
```

**Emulator Ports**:
- Functions: http://localhost:5001
- Firestore: http://localhost:8080
- Firestore UI: http://localhost:4000

### 3. Trigger Scheduled Functions Manually

Since scheduled functions only run on their cron schedule in production, you need to manually trigger them during local development.

**Option A: HTTP Trigger (Recommended for Testing)**

Create a temporary HTTP function wrapper:

```typescript
// Add to src/index.ts temporarily
import { onRequest } from "firebase-functions/v2/https";
import { sendOrders } from "./functions/sendOrdersFunction";
import { checkOrders } from "./functions/checkOrdersFunction";

// DEV ONLY: Manual triggers
if (process.env.GCLOUD_PROJECT === "zachran-obed-dev") {
  exports.triggerSendOrders = onRequest(async (req, res) => {
    await sendOrders();
    res.send("sendOrders executed");
  });

  exports.triggerCheckOrders = onRequest(async (req, res) => {
    await checkOrders();
    res.send("checkOrders executed");
  });
}
```

Then trigger via curl:

```bash
# Trigger sendOrders
curl http://localhost:5001/zachran-obed-dev/us-central1/triggerSendOrders

# Trigger checkOrders
curl http://localhost:5001/zachran-obed-dev/us-central1/triggerCheckOrders
```

**Option B: Call Function Logic Directly**

Extract the core logic into testable functions:

```typescript
// src/functions/sendOrdersFunction.ts
export async function sendOrders() {
  // Core logic here
}

export const sendOrdersFunction = onSchedule(
  { schedule: "0 7 * * 1-5", timeZone: "UTC" },
  async (event) => {
    await sendOrders();
  }
);
```

Then create a test script:

```typescript
// test/manual/trigger-send-orders.ts
import * as admin from "firebase-admin";
import { sendOrders } from "../../src/functions/sendOrdersFunction";

admin.initializeApp();

sendOrders()
  .then(() => console.log("Done"))
  .catch(console.error)
  .finally(() => process.exit());
```

Run with:

```bash
npx ts-node test/manual/trigger-send-orders.ts
```

### 4. Test Firestore Triggers via REST API

Create or update documents to trigger functions:

```bash
# Create a new delivery document
curl -X POST \
  "http://localhost:8080/v1/projects/zachran-obed-dev/databases/(default)/documents/deliveries" \
  -H 'Content-Type: application/json' \
  -d '{
    "fields": {
      "carrierId": {"stringValue": "dodo"},
      "donorId": {"stringValue": "donor-123"},
      "recipientId": {"stringValue": "recipient-456"},
      "state": {"stringValue": "PREPARED"},
      "type": {"stringValue": "FOOD_DELIVERY"},
      "deliveryDate": {"timestampValue": "2026-01-17T00:00:00Z"},
      "deliveryIdentifier": {"stringValue": "test-delivery-20260117"},
      "pickupTimeWindow": {
        "mapValue": {
          "fields": {
            "start": {"timestampValue": "2026-01-17T16:30:00Z"},
            "end": {"timestampValue": "2026-01-17T17:00:00Z"}
          }
        }
      },
      "deliveryTimeWindow": {
        "mapValue": {
          "fields": {
            "start": {"timestampValue": "2026-01-17T17:30:00Z"},
            "end": {"timestampValue": "2026-01-17T18:00:00Z"}
          }
        }
      }
    }
  }'

# Update delivery state (triggers onDocumentUpdated if configured)
curl -X PATCH \
  "http://localhost:8080/v1/projects/zachran-obed-dev/databases/(default)/documents/deliveries/{docId}?updateMask.fieldPaths=state" \
  -H 'Content-Type: application/json' \
  -d '{
    "fields": {
      "state": {"stringValue": "OFFERED"}
    }
  }'
```

## Testing Strategy

### Unit Tests (Functions Logic)

```typescript
// test/unit/dateUtils.test.ts
import { getNextBusinessDay } from "../../src/utils/dateUtils";

describe("getNextBusinessDay", () => {
  it("should skip weekends to Monday", () => {
    // Test Friday + 1 day = Monday
    const friday = new Date("2026-01-16"); // Friday
    const result = getNextBusinessDay(1);
    expect(result.getDay()).not.toBe(0); // Not Sunday
    expect(result.getDay()).not.toBe(6); // Not Saturday
  });
});
```

### Integration Tests (With Emulator)

```typescript
// test/integration/sendOrders.test.ts
import * as admin from "firebase-admin";
import { sendOrders } from "../../src/functions/sendOrdersFunction";

describe("sendOrders integration", () => {
  beforeAll(() => {
    process.env.FIRESTORE_EMULATOR_HOST = "localhost:8080";
    admin.initializeApp({ projectId: "zachran-obed-dev" });
  });

  it("should create deliveries for active entity pairs", async () => {
    const db = admin.firestore();

    // Setup test data
    await db.collection("entityPairs").doc("test-pair").set({
      donorId: "donor-1",
      recipientId: "recipient-1",
      carrierId: "dodo",
      // ... other fields
    });

    // Execute function
    await sendOrders();

    // Verify delivery created
    const deliveries = await db.collection("deliveries")
      .where("donorId", "==", "donor-1")
      .get();

    expect(deliveries.size).toBe(1);
  });
});
```

## Deployment

### Deploy to DEV

```bash
# Ensure on DEV project
firebase use default

# Verify service account in src/config/firebase.ts
# Should be: firebase-adminsdk-ju14s@zachran-obed-dev.iam.gserviceaccount.com

# Lint first (required)
npm run lint

# Build
npm run build

# Deploy
npm run deploy

# Or deploy only functions
firebase deploy --only functions
```

### Deploy to PROD

```bash
# Switch to PROD
firebase use prod

# Update service account in src/config/firebase.ts
# Should be: firebase-adminsdk-gd4ef@zachran-obed.iam.gserviceaccount.com

# Lint and build
npm run lint
npm run build

# Deploy
npm run deploy

# Verify functions are running
firebase functions:log --limit 20
```

### Post-Deployment Verification

```bash
# View function logs
firebase functions:log --limit 50

# Filter by function name
firebase functions:log --only sendOrdersFunction

# Real-time log streaming
firebase functions:log --follow
```

## Monitoring and Debugging

### View Firestore Data

1. Open Firestore emulator UI: http://localhost:4000
2. Navigate to collections: entities, entityPairs, deliveries
3. Verify document structure matches schemas in data-model.md

### View Function Logs

```bash
# Local emulator logs (console output)
# Logs appear in terminal running `npm run serve`

# Production logs
firebase functions:log

# Filter by severity
firebase functions:log --min-level error

# Specific time range
firebase functions:log --since 2h
```

### Common Issues

**Issue**: Scheduled function doesn't export in DEV

**Solution**: Check conditional export in src/index.ts:

```typescript
const currentProjectId = process.env.GCLOUD_PROJECT || process.env.FIREBASE_PROJECT_ID;

if (currentProjectId === "zachran-obed") {
  exports.sendOrdersFunction = sendOrdersFunction;
  exports.checkOrdersFunction = checkOrdersFunction;
}
```

For DEV testing, temporarily change condition to include "zachran-obed-dev".

---

**Issue**: DODO API returns 401 Unauthorized

**Solution**: Verify secrets are set correctly:

```bash
firebase functions:secrets:access DODO_CLIENT_ID
firebase functions:secrets:access DODO_OAUTH_URI
```

Check OAuth2 token request in logs for error details.

---

**Issue**: Firestore query returns empty results

**Solution**: Check Firestore indexes:

```bash
# Deploy indexes from DEV to PROD
firebase use default
firebase firestore:indexes > firestore.indexes.json

firebase use prod
firebase deploy --only firestore:indexes
```

Verify query filters match indexed fields.

---

**Issue**: TypeScript compilation errors after schema changes

**Solution**: Delete `lib/` directory and rebuild:

```bash
rm -rf lib/
npm run build
```

---

## Useful Commands Reference

```bash
# Project Management
firebase use                          # List projects
firebase use default                  # Switch to DEV
firebase use prod                     # Switch to PROD

# Development
npm install                           # Install dependencies
npm run build                         # Compile TypeScript
npm run build:watch                   # Watch mode compilation
npm run lint                          # Run ESLint
npm run lint:fix                      # Auto-fix lint issues

# Testing
npm run serve                         # Start emulator with seed data
firebase emulators:start              # Start emulator (no seed)

# Deployment
npm run deploy                        # Deploy functions (with lint/build)
firebase deploy --only functions      # Deploy functions only
firebase deploy --only functions:sendOrdersFunction  # Deploy single function

# Secrets Management
firebase functions:secrets:set SECRET_NAME
firebase functions:secrets:access SECRET_NAME
firebase functions:secrets:delete SECRET_NAME

# Logging
firebase functions:log                # View logs
firebase functions:log --follow       # Real-time logs
firebase functions:log --only functionName

# Firestore
firebase firestore:indexes            # List indexes
firebase deploy --only firestore:indexes
```

## Next Steps After Migration

1. Run both GitHub Actions and Cloud Functions in parallel for 1 week
2. Compare Firestore results to verify functional parity
3. Monitor error rates and execution times in Firebase Console
4. Switch PROD to Cloud Functions only
5. Delete GitHub Actions workflows: `.github/workflows/sendOrders.yml` and `.github/workflows/checkOrders.yml`
6. Delete `old_solution/` directory after verification complete
7. Remove temporary HTTP trigger functions from DEV
