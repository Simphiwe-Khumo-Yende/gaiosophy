# Gaiosophy Firebase Cloud Functions

This directory contains Firebase Cloud Functions that handle push notifications when new content is added to the Gaiosophy app.

## Functions

- **notifyOnContentCreate** - Sends notification when content is added to `content` collection
- **notifyOnPlantAllyCreate** - Sends notification when content is added to `content_plant_allies` collection
- **notifyOnRecipeCreate** - Sends notification when content is added to `content_recipes` collection
- **notifyOnSeasonalWisdomCreate** - Sends notification when content is added to `content_seasonal_wisdom` collection

## Quick Start

### Install Dependencies
```powershell
npm install
```

### Build TypeScript
```powershell
npm run build
```

### Deploy to Firebase
```powershell
firebase deploy --only functions
```

### View Logs
```powershell
firebase functions:log
```

## Development

### Local Testing
```powershell
npm run serve
```

This starts the Firebase emulator suite. You can test functions locally before deploying.

### Watch Mode
```powershell
npm run build:watch
```

Automatically recompiles TypeScript when files change.

## Documentation

See `../CLOUD_FUNCTIONS_DEPLOYMENT.md` for detailed deployment instructions and troubleshooting.

## Requirements

- Node.js 18+
- Firebase CLI
- Firestore database with content collections
- FCM (Firebase Cloud Messaging) enabled
