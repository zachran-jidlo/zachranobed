# Implementation Plan: GitHub Actions Migration to Firebase Cloud Functions

**Branch**: `001-github-actions-migration` | **Date**: 2026-01-16 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/001-github-actions-migration/spec.md`

## Summary

Migrate two GitHub Actions (sendOrders and checkOrders) into Firebase Cloud Functions v2. The sendOrders action runs daily at 7:00 AM UTC to create delivery documents for active entity pairs. The checkOrders action runs every 7-8 minutes during business hours to process delivery state transitions and create DODO logistics orders. The migration will use Firebase Functions v2 with Node.js 20, TypeScript in strict mode, and replace axios with native fetch for DODO API communication.

## Technical Context

**Language/Version**: TypeScript 5.7.3, Node.js 20, ES2017 target
**Primary Dependencies**: Firebase Functions v2 (6.4.0), Firebase Admin SDK (13.6.0)
**Storage**: Firestore (entities, entityPairs, deliveries collections)
**Testing**: Firebase Emulators with seed data, manual trigger testing
**Target Platform**: Firebase Cloud Functions (europe-west1 region)
**Project Type**: Single (Cloud Functions backend)
**Performance Goals**: Process all deliveries within 15 minutes, handle 100+ entity pairs
**Constraints**: Daily function at 7:00 AM UTC weekdays, check function every 7-8 min (9-17 CET weekdays)
**Scale/Scope**: 2 scheduled functions, 4 services, 4 models, ~800 LOC migration

**Key Technical Decisions**:
- Replace axios with native fetch (Node.js 18+ built-in)
- Use `onSchedule` from `firebase-functions/v2/scheduler`
- Extract DODO API service, entity service, delivery service
- Maintain identical business logic to existing GitHub Actions
- Conditional export for PROD-only scheduled functions

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Gate | Status |
|-----------|------|--------|
| I. Code Quality | TypeScript strict mode enabled (`tsconfig.json`), ESLint configured with Google style | ✓ |
| II. Repository Structure | Models in `src/models/`, services in `src/services/`, functions in `src/functions/` | ✓ |
| III. Tools & Frameworks | Firebase Functions v2 API, `setGlobalOptions({region: "europe-west1"})` | ✓ |
| IV. Firebase Functions Specification | Scheduled functions use `onSchedule`, secrets via `defineString()`, error isolation | ✓ |

**Notes**: All gates pass. Existing codebase already follows the constitution. This migration adds new scheduled functions without modifying existing notification functions.

## Project Structure

### Documentation (this feature)

```text
specs/001-github-actions-migration/
├── plan.md              # This file
├── research.md          # Technology decisions and patterns
├── data-model.md        # Firestore entity models
├── quickstart.md        # Local development and testing guide
└── contracts/           # DODO API interface specifications
    └── dodo-api.yaml    # OAuth2 + orders endpoint contract
```

### Source Code (repository root)

```text
src/
├── index.ts                          # Add exports for sendOrdersFunction, checkOrdersFunction
├── config/
│   └── firebase.ts                   # Add DODO secrets (5 defineString calls)
├── functions/
│   ├── sendOrdersFunction.ts         # NEW: Daily delivery creation (7:00 AM UTC weekdays)
│   ├── checkOrdersFunction.ts        # NEW: State transitions and order creation (every 7-8 min)
│   ├── checkDeliveriesInvocatorFunction.ts  # MODIFY: Remove GitHub Actions trigger, kept for reference
│   └── notifications/                # UNCHANGED: Existing Firestore triggers
├── services/
│   ├── dodoService.ts                # NEW: DODO OAuth2 + order creation (fetch-based)
│   ├── entityService.ts              # NEW: Load entities and entity pairs from Firestore
│   ├── deliveryService.ts            # NEW: Delivery state transitions and Firestore updates
│   └── notificationService.ts        # UNCHANGED: Existing FCM notification service
├── models/
│   ├── Delivery.ts                   # NEW: Delivery document with state machine
│   ├── Entity.ts                     # NEW: Donor/recipient location
│   ├── EntityPair.ts                 # NEW: Donor-recipient connection
│   ├── DodoOrder.ts                  # NEW: DODO API request/response types
│   ├── index.ts                      # NEW: Barrel export for models
│   └── FoodBox.ts                    # UNCHANGED: Existing model
└── utils/
    ├── dateUtils.ts                  # MODIFY: Add getNextBusinessDay(), getMinutesBeforePickup()
    └── emailUtils.ts                 # UNCHANGED: Existing utilities

old_solution/                         # KEEP: Reference for business logic verification
└── [GitHub Actions source code]
```

**Structure Decision**: Single project structure with Firebase Functions v2. All new code follows existing patterns in `src/`. The `old_solution/` directory remains for reference during migration and will be removed after verification.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

No violations. All patterns align with the constitution.
