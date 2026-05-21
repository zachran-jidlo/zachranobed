<!--
  SYNC IMPACT REPORT
  ==================
  Version change: 0.0.0 → 1.0.0

  Added Principles:
  - I. Code Quality Standards
  - II. Repository Structure
  - III. Tools and Frameworks
  - IV. Firebase Functions Specification

  Added Sections:
  - Development Workflow
  - Environment Management

  Removed Sections:
  - N/A (initial constitution)

  Templates requiring updates:
  - ⚠ .specify/templates/plan-template.md - add Constitution Check gates
  - ⚠ .specify/templates/spec-template.md - no changes required
  - ⚠ .specify/templates/tasks-template.md - no changes required

  Follow-up TODOs: None
-->

# Zachraň oběd Cloud Functions Constitution

## Core Principles

### I. Code Quality Standards

All code MUST adhere to strict TypeScript and ESLint standards to ensure maintainability and reliability.

**Non-Negotiable Rules**:
- TypeScript strict mode MUST be enabled (`"strict": true` in tsconfig.json)
- All code MUST pass ESLint validation before deployment (`npm run lint`)
- Double quotes MUST be used for strings (enforced by ESLint)
- 2-space indentation MUST be used consistently
- Unused variables and implicit returns are NOT permitted
- `any` type usage triggers warnings and SHOULD be replaced with `unknown` or proper types
- Explicit return types MUST be declared for all exported functions

**Rationale**: Consistent code quality reduces bugs, improves collaboration, and ensures long-term maintainability of the codebase.

### II. Repository Structure

The codebase MUST follow a modular, domain-driven directory structure to maintain separation of concerns.

**Required Directory Layout**:
```
src/
├── index.ts              # Main entry point - all function exports
├── config/               # Firebase and global configuration
│   └── firebase.ts       # Admin SDK initialization, global options
├── functions/            # Firebase Function implementations
│   ├── notifications/    # Firestore-triggered notification functions
│   └── [feature]/        # Feature-specific functions
├── services/             # Shared business logic services
├── models/               # TypeScript interfaces and data models
└── utils/                # Utility functions (date, email, etc.)
```

**Non-Negotiable Rules**:
- All Firebase Functions MUST be exported via `src/index.ts` using CommonJS exports
- Configuration MUST be centralized in `src/config/`
- Domain-specific functions MUST be grouped in subdirectories under `src/functions/`
- Shared logic MUST be extracted to `src/services/` or `src/utils/`
- Compiled output goes to `lib/` directory (gitignored)

**Rationale**: Clear structure enables rapid onboarding, simplifies debugging, and prevents accidental coupling between unrelated features.

### III. Tools and Frameworks

Development MUST use the specified toolchain versions and configurations to ensure consistency across environments.

**Required Stack**:
- **Node.js**: v24 (as specified in `engines.node`)
- **TypeScript**: ^5.7.3 with ES2017 target, CommonJS module format
- **Firebase Admin SDK**: ^13.6.0
- **Firebase Functions**: v2 API (^6.4.0) - NOT v1 API
- **ESLint**: Flat config format with Google style guide baseline

**Non-Negotiable Rules**:
- Firebase Functions v2 API (`firebase-functions/v2`) MUST be used for all new functions
- `setGlobalOptions()` MUST define region as `europe-west1`
- Secrets (such as credentials, API keys, and tokens) MUST be managed via `defineSecret()` from `firebase-functions/params`
- Non-secret configuration parameters (such as feature flags and non-sensitive IDs) MUST be managed via `defineString()` from `firebase-functions/params`
- Build process: `npm run build` (TypeScript compilation)
- Linting: `npm run lint` before any deployment
- Deployment: `npm run deploy` (never manual `firebase deploy` without lint check)

**Rationale**: Pinned versions prevent runtime surprises and ensure reproducible builds across development, staging, and production environments.

### IV. Firebase Functions Specification

All Firebase Cloud Functions MUST follow established patterns for triggers, error handling, and notification delivery.

**Supported Function Types**:
1. **Scheduled Functions** (`onSchedule`): Cron-based triggers for periodic tasks
2. **Firestore Triggers** (`onDocumentUpdated`): React to document state changes
3. **HTTPS Functions** (`onRequest`): RESTful endpoints (e.g., DODO courier webhook)

**Non-Negotiable Rules**:
- Firestore triggers MUST validate state transitions before processing
- Date conditions MUST be checked to prevent notifications for stale data
- FCM notifications MUST use `sendNotificationsAndCleanup()` pattern:
  1. Create notification document in `entities/{id}/notifications`
  2. Send FCM push to all registered device tokens
  3. Remove invalid tokens from entity document
- Production-only functions MUST be conditionally exported based on `GCLOUD_PROJECT`
- All functions MUST handle errors gracefully and log meaningful context

**Rationale**: Consistent patterns ensure reliable notification delivery, prevent duplicate notifications, and maintain clean device token registries.

## Development Workflow

Development MUST follow established workflows for local testing and deployment.

**Local Development**:
- Use `npm run serve` to start emulator with seed data
- Test Firestore triggers via REST API calls to emulator
- Validate function logic before deploying to any environment

**Deployment Process**:
1. Verify correct Firebase project selected (`firebase use`)
2. Ensure service account in `src/config/firebase.ts` matches target environment
3. Run `npm run lint` to catch issues early
4. Run `npm run build` to verify compilation
5. Deploy with `npm run deploy`

**Non-Negotiable Rules**:
- NEVER deploy without running lint first
- NEVER delete functions that may be used by Rowy or external services
- ALWAYS verify the selected Firebase project before deployment
- Service account MUST match the deployment target (DEV vs PROD)

## Environment Management

Two Firebase environments MUST be maintained with clear separation.

**Environments**:
| Alias | Project ID | Service Account |
|-------|-----------|-----------------|
| default | zachran-obed-dev | firebase-adminsdk-ju14s@zachran-obed-dev.iam.gserviceaccount.com |
| prod | zachran-obed | firebase-adminsdk-gd4ef@zachran-obed.iam.gserviceaccount.com |

**Non-Negotiable Rules**:
- DEV environment (`default`) MUST be used for all testing and development
- PROD deployment requires explicit `firebase use prod` command
- Firestore indexes MUST be synced from DEV to PROD after changes
- Scheduled functions MAY be conditionally exported for PROD only

## Governance

This constitution supersedes all informal practices and tribal knowledge. All development decisions MUST align with these principles.

**Amendment Procedure**:
1. Propose changes via pull request modifying this file
2. Document rationale for changes
3. Obtain team review and approval
4. Update version number according to semantic versioning

**Versioning Policy**:
- MAJOR: Removal or fundamental redefinition of principles
- MINOR: New principles, sections, or material expansions
- PATCH: Clarifications, wording improvements, typo fixes

**Compliance Review**:
- All PRs MUST verify compliance with this constitution
- Complexity beyond these patterns MUST be explicitly justified
- Runtime development guidance: see `CLAUDE.md` for detailed commands and examples

**Version**: 1.0.0 | **Ratified**: 2026-01-16 | **Last Amended**: 2026-01-16
