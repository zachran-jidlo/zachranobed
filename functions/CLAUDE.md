# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Firebase Cloud Functions for Zachraň oběd (Save Lunch) - a backend service handling automated notifications, scheduled tasks, and business logic for the food redistribution platform.

- Node.js: v20
- TypeScript: ^5.7.3
- Firebase Functions: v2 (^6.4.0)
- Firebase Admin SDK: ^13.6.0

## Essential Commands

```bash
# Install dependencies
npm install

# Linting
npm run lint
npm run lint:fix

# Build TypeScript
npm run build
npm run build:watch

# Local development with emulator
npm run serve    # Builds and starts emulator with seed data

# Firebase emulator (manual)
firebase emulators:start
firebase emulators:start --import seed/export-for-emulator/2024-04-05T11:33:06_69896/ --export-on-exit seed/export-for-emulator/2024-04-05T11:33:06_69896/

# Deployment
npm run deploy         # Deploy to currently selected Firebase project
firebase deploy --only functions

# Firebase project management
firebase use           # List projects and show current selection
firebase use default   # Switch to DEV environment
firebase use prod      # Switch to PROD environment

# View logs
npm run logs
firebase functions:log
```

## Architecture

### Directory Structure

```
src/
├── index.ts              # Main entry point - exports all Firebase Functions
├── config/
│   ├── firebase.ts       # Firebase Admin initialization, global options
│   └── constants.ts      # Business rule constants
├── functions/
│   ├── checkOrdersFunction.ts                 # Scheduled order checking (9-20 CET)
│   ├── sendOrdersFunction.ts                  # Scheduled daily delivery creation (16:00 Prague)
│   ├── checkDeliveriesInvocatorFunction.ts    # Legacy GitHub Actions trigger (deprecated)
│   ├── mismatchFunction.ts                    # Box mismatch notifications
│   └── notifications/                         # Firestore-triggered notifications
│       ├── foodDeliveryFunction.ts
│       ├── boxReturnFunction.ts
│       ├── lackOfBoxesFunction.ts
│       └── monthlyBoxCheckupFunction.ts
├── services/
│   ├── notificationService.ts    # FCM push notifications + Firestore notifications
│   ├── deliveryService.ts        # Delivery document management
│   ├── entityService.ts          # Entity and EntityPair loading
│   └── dodoService.ts            # DODO Logistics API integration
├── models/
│   ├── Delivery.ts               # Delivery document schema
│   ├── Entity.ts                 # Entity document schema
│   ├── EntityPair.ts             # EntityPair document schema
│   ├── DodoToken.ts              # DODO OAuth2 token schema
│   ├── DodoOrder.ts              # DODO order request schema
│   └── index.ts                  # Barrel exports
└── utils/
    ├── dateUtils.ts              # Date/time utilities (Luxon-based)
    ├── emailUtils.ts             # Email generation
    └── noteUtils.ts              # Delivery note generation

lib/          # Compiled JavaScript output (gitignored)
build/        # Build artifacts
seed/         # Emulator seed data
specs/        # Feature specifications
old_solution/ # Legacy GitHub Actions implementation (reference)
```

### Firebase Function Types

**Scheduled Functions** (v2 scheduler):
- `sendOrdersFunction` - Creates daily delivery documents for active entity pairs
  - Runs at 16:00 (4 PM) Prague time on weekdays
  - Only exported for production project (`zachran-obed`)
- `checkOrdersFunction` - Processes delivery state transitions and creates DODO carrier orders
  - Runs every 7-8 minutes from 9:00-20:00 Prague time on weekdays
  - Only exported for production project (`zachran-obed`)
- `scheduledFunctionCrontab` - **DEPRECATED** Legacy GitHub Actions trigger
  - Replaced by `checkOrdersFunction`
  - Kept for reference only

**Firestore Triggers** (v2 onDocumentUpdated):
- `notifyCharityAboutDonationV2` - Triggers on `deliveries/{id}` updates when state changes to ACCEPTED/NOT_USED
- `notifyCanteenAboutBoxShippmentV2` - Box return notifications
- `notifyAboutLackOfBoxes` - Low box inventory alerts
- `boxesMismatchNotification` - Box count mismatch detection
- `monthlyBoxCheckupFunction` - Monthly box audit notifications

### Key Patterns

**Notification Flow**:
1. Firestore document change triggers function
2. Function validates state transition and date conditions
3. Fetches related entities from Firestore
4. Calls `sendNotificationsAndCleanup()` which:
   - Creates notification document in `entities/{id}/notifications` subcollection
   - Sends FCM push notification to all registered device tokens
   - Removes invalid tokens from entity document

**Configuration Management**:
- Global options set in `src/config/firebase.ts` via `setGlobalOptions()`
- Region: `europe-west1`
- Service account configured per environment (see README.md)
- Secrets managed via `defineString()` from `firebase-functions/params`

## Environment Management

### Firebase Projects

Two environments configured:
- **default** - DEV environment (`zachran-obed-dev`)
- **prod** - PROD environment (`zachran-obed`)

Service accounts differ by environment:
- PROD: `firebase-adminsdk-gd4ef@zachran-obed.iam.gserviceaccount.com`
- DEV: `firebase-adminsdk-ju14s@zachran-obed-dev.iam.gserviceaccount.com`

**Important**: Update service account in `src/config/firebase.ts` when switching environments for testing.

### Firestore Index Management

When indexes change on DEV, sync them to PROD:

```bash
# 1. Switch to DEV and export indexes
firebase use default
firebase firestore:indexes > firestore.indexes.json

# 2. Switch to PROD and deploy
firebase use prod
firebase deploy --only firestore:indexes
```

## TypeScript Configuration

- Target: ES2017
- Module: CommonJS (required for Firebase Functions)
- Strict mode enabled
- Compiled output: `lib/` directory
- Source maps enabled

Functions exported via CommonJS style (`exports.functionName = ...`) in `src/index.ts` for Firebase compatibility.

## Linting & Code Style

ESLint configuration (flat config format):
- Google style guide baseline
- Double quotes enforced
- 2-space indentation
- Import order enforcement
- TypeScript-specific rules enabled

Key rules:
- `@typescript-eslint/no-explicit-any`: warn
- `no-console`: warn (logs are expected in Cloud Functions)
- `import/order`: error

## Development with Emulator

The emulator suite includes Firestore and Functions emulators. Seed data can be imported/exported for consistent testing:

```bash
# Serve with automatic seed data import/export
npm run serve

# Manual emulator with custom seed path
firebase emulators:start --import <path> --export-on-exit <path>
```

### Exporting Production Data for Emulator

```bash
# 1. Authenticate
firebase login
gcloud auth login

# 2. Select project
firebase use zachran-obed-dev
gcloud config set project zachran-obed-dev

# 3. Export to GCloud bucket
gcloud firestore export gs://export-for-emulator

# 4. Copy to local machine
cd functions
gsutil -m cp -r gs://export-for-emulator .
```

## Deployment Notes

- Always run linting before deployment: `npm run lint`
- Auto-fix available: `npm run lint:fix`
- Functions are deployed via `npm run deploy` which runs `firebase deploy --only functions`
- Do NOT delete functions from source that are used by Rowy or other external services
- Check currently selected project before deploying: `firebase use`

## Testing Firestore Triggers Locally

Use Firestore REST API to trigger local functions during emulator development:

```bash
# Create document
curl -X POST \
  "http://localhost:8080/v1/projects/zachran-obed-dev/databases/(default)/documents/deliveries" \
  -H 'Content-Type: application/json' \
  -d '{ ... }'

# Update document (triggers onDocumentUpdated)
curl -X PATCH \
  "http://localhost:8080/v1/projects/zachran-obed-dev/databases/(default)/documents/deliveries/{docId}" \
  -H 'Content-Type: application/json' \
  -d '{ ... }'
```

See README.md for complete curl examples.

## TypeScript Best Practices (from Cursor rules)

- Prefer `interfaces` over `types` for object definitions
- Avoid `any`, use `unknown` for unknown types
- Use explicit return types for public functions
- Prefer `async/await` over raw Promises
- Use `readonly` for immutable properties
- PascalCase for types/interfaces, camelCase for functions/variables, UPPER_CASE for constants

## Important Locations

- Function exports: `src/index.ts`
- Firebase config & secrets: `src/config/firebase.ts`
- Business constants: `src/config/constants.ts`
- Scheduled functions: `src/functions/checkOrdersFunction.ts`, `src/functions/sendOrdersFunction.ts`
- Firestore triggers: `src/functions/notifications/`
- Notification service: `src/services/notificationService.ts`
- Delivery service: `src/services/deliveryService.ts`
- DODO API integration: `src/services/dodoService.ts`
- Entity management: `src/services/entityService.ts`
- Data models: `src/models/`
- TypeScript config: `tsconfig.json`
- ESLint config: `eslint.config.mjs`
