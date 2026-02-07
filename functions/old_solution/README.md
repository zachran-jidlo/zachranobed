# Zachraň Oběd Firebase CRON Automation

**"Zachraň oběd" is a Czech charitable organization that handles meal distribution from restaurants to charities.**

This project automates order creation and management using the DODO delivery service API, with data stored in Firebase Firestore.

## Overview

The system consists of two main automated functions:

### 1. Send Orders (`sendOrders`)

- **Schedule**: Runs at 7:00 AM CET, Monday-Friday
- **Purpose**: Creates weekly orders for the upcoming delivery day
- **Process**:
  - Loads donor restaurants and charity recipients from Firebase
  - Creates orders via DODO API for each donor-charity pair
  - Saves order information to Firebase with status tracking

### 2. Check Orders (`checkOrders`)

- **Schedule**: Runs every 7-8 minutes during business hours (10:00-18:00 CET, Monday-Friday)
- **Purpose**: Monitors and updates order confirmations
- **Process**:
  - Checks pending orders for current day
  - Verifies confirmations against available offers in Firebase
  - Updates order status (confirmed/cancelled) based on confirmation deadlines

## Technology Stack

- **Runtime**: Node.js v20
- **Language**: TypeScript
- **Database**: Firebase Firestore
- **Deployment**: GitHub Actions
- **API Integration**: DODO delivery service
- **Key Dependencies**:
  - `firebase-admin`: ^12.0.0
  - `firebase`: ^10.3.0
  - `axios`: ^1.6.8
  - `runtypes`: ^6.6.0

## Development Setup

### Prerequisites

- Node.js 20.10.0+ (< 21.0.0)
- npm 10.2.3+ (< 11.0.0)

### Installation

1. Clone the repository:

```bash
git clone https://github.com/zachran-jidlo/zachran-obed-firebase-cron.git
cd zachran-obed-firebase-cron
```

2. Install dependencies:

```bash
npm install
```

3. Configure environment variables:
   - Copy `development.env` to `.env` for local development
   - Update the Firebase and DODO API credentials

### Environment Variables

Required environment variables (available in `development.env` and `production.env`):

```bash
# Environment
NODE_ENV=development
MAKE_API_CALLS=false  # Set to true for actual API calls

# DODO API Configuration
DODO_CLIENT_ID=your_client_id
DODO_CLIENT_SECRET=your_client_secret
DODO_OAUTH_URI=oauth_endpoint
DODO_SCOPE=api_scope
DODO_ORDERS_API=orders_api_endpoint

# Firebase Configuration
FIREBASE_PROJECT_ID=your_project_id
FIREBASE_PRIVATE_KEY=your_private_key
FIREBASE_CLIENT_EMAIL=your_service_account_email
```

### Running Locally

#### Test Environment (Development)

```bash
npm run start:test:dev    # Test with development config
npm run start:test:prod   # Test with production config
```

**Note**: For testing, you need to uncomment the desired function in `src/common/index.ts`:

- Uncomment `// await runChecks()` to test the check orders function
- Uncomment `// await sendDeliveries()` to test the send orders function

#### Individual Functions

```bash
npm run start:send        # Run send orders function
npm run start:check       # Run check orders function
```

**Note**: These commands are used in the Github Actions with production environment. Don't use them for local development.

#### Code Quality

```bash
npm run lint              # Check code style
npm run lint:fix          # Auto-fix linting issues
```

### Project Structure

```
src/
├── common/           # Shared utilities and configurations
│   ├── config.ts     # Environment configuration
│   ├── firestore.ts  # Firebase Firestore client
│   ├── dodo.ts       # DODO API client
│   ├── logger.ts     # Logging utilities
│   ├── utils.ts      # Common utilities
│   └── index.ts      # Test entry point
├── sendOrders/       # Send orders function
└── checkOrders/      # Check orders function
```

## Deployment

The project uses GitHub Actions for automated deployment with CRON scheduling.

### Workflows

1. **Send Orders** (`.github/workflows/sendOrders.yml`)

   - Triggers: Daily at 7:00 AM CET (Monday-Friday)
   - Manual trigger available via `workflow_dispatch`

2. **Check Orders** (`.github/workflows/checkOrders.yml`)

   - Triggers: Every 7-8 minutes during business hours
   - Manual trigger available via `workflow_dispatch`

3. **Test** (`.github/workflows/test.yml`)
   - Runs on code changes for validation

### GitHub Secrets

Configure these secrets in your GitHub repository:

- `DODO_CLIENT_ID`
- `DODO_CLIENT_SECRET`
- `DODO_OAUTH_URI`
- `DODO_SCOPE`
- `DODO_ORDERS_API`
- `FIREBASE_PROJECT_ID`
- `FIREBASE_PRIVATE_KEY`
- `FIREBASE_CLIENT_EMAIL`

### GitHub Variables

Configure these variables:

- `NODE_ENV`: Set to `production`
- `MAKE_API_CALLS`: Set to `true` for production

## Order Management

### Order Lifecycle

1. **Creation**: Orders are created for donor-charity pairs for the next delivery day
2. **Confirmation**: System monitors for confirmations from offers in Firebase
3. **Status Updates**: Orders are marked as confirmed or cancelled based on deadlines
4. **Unique Keys**: Each order has a unique identifier: `{donor}-{charity}-d.m.yyyy`

### Firebase Collections

The system interacts with Firebase Firestore collections for:

- Donor restaurants data
- Charity recipients data
- Order tracking and status
- Delivery offers and confirmations

## Contributing

1. Follow the existing TypeScript coding standards
2. Run linting before committing: `npm run lint:fix`
3. Test locally with `npm run start:test:dev`
4. Ensure all environment variables are properly configured

## License

ISC

## Support

For issues related to DODO API access or Firebase configuration, contact the Zachraň Jídlo team.

Repository: https://github.com/zachran-jidlo/zachran-obed-firebase-cron
