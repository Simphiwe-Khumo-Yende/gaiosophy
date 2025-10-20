# Push Notification Cloud Functions - Deployment Guide

## Overview

This guide explains how to deploy Firebase Cloud Functions that automatically send push notifications when new content is added to any Firestore collection.

## What Gets Triggered

The Cloud Functions monitor these Firestore collections and send notifications when new documents are created:

- `content/{contentId}` - Main content collection
- `content_plant_allies/{contentId}` - Plant ally content
- `content_recipes/{contentId}` - Recipe content
- `content_seasonal_wisdom/{contentId}` - Seasonal wisdom content

## Prerequisites

1. **Node.js 18+** installed on your machine
2. **Firebase CLI** installed globally:
   ```powershell
   npm install -g firebase-tools
   ```
3. **Firebase project** already set up (you have this)
4. **Admin permissions** for your Firebase project

## Setup Steps

### 1. Login to Firebase

```powershell
firebase login
```

### 2. Initialize Firebase (if not already done)

From the project root directory:

```powershell
# Check if firebase.json exists - if yes, skip this step
firebase init
```

If initializing, select:
- **Functions** (use arrow keys and space to select)
- **TypeScript** as the language
- **Yes** to ESLint
- **Use existing project** and select your project

### 3. Install Function Dependencies

Navigate to the functions directory and install packages:

```powershell
cd functions
npm install
```

### 4. Build the Functions

Compile TypeScript to JavaScript:

```powershell
npm run build
```

### 5. Deploy to Firebase

Deploy all functions to Firebase:

```powershell
firebase deploy --only functions
```

Or deploy specific functions:

```powershell
# Deploy only plant ally notifications
firebase deploy --only functions:notifyOnPlantAllyCreate

# Deploy all notification functions
firebase deploy --only functions:notifyOnContentCreate,functions:notifyOnPlantAllyCreate,functions:notifyOnRecipeCreate,functions:notifyOnSeasonalWisdomCreate
```

## Verification

### 1. Check Deployment Status

In the Firebase Console:
1. Go to **Functions** section
2. Verify these functions are deployed:
   - `notifyOnContentCreate`
   - `notifyOnPlantAllyCreate`
   - `notifyOnRecipeCreate`
   - `notifyOnSeasonalWisdomCreate

### 2. Test with Real Content

1. In Firebase Console, go to **Firestore Database**
2. Add a new document to `content_plant_allies`:
   ```json
   {
     "title": "Test Plant",
     "summary": "This is a test notification",
     "status": "published",
     "season_id": "your-season-id",
     "updated_at": [Firebase Timestamp - now]
   }
   ```
3. Check that:
   - Function executes in **Functions → Logs**
   - Your test device receives a notification (if you've enabled notifications in the app)

### 3. Monitor Function Logs

View real-time logs:

```powershell
firebase functions:log
```

Or view logs in Firebase Console → Functions → Logs

## How It Works

### Notification Flow

1. **Content Created**: Admin adds a new document to any content collection
2. **Function Triggered**: Cloud Function detects the `onCreate` event
3. **Validation**: Function checks if `status === "published"`
4. **FCM Message**: Function sends notification to `new-content` topic
5. **Devices Receive**: All devices subscribed to `new-content` topic receive the notification
6. **App Displays**: Flutter app's `PushNotificationService` handles display

### Notification Payload

Each notification includes:

```json
{
  "notification": {
    "title": "New Plant Ally: Bramble",
    "body": "Traditional autumn harvest plant with healing properties"
  },
  "data": {
    "contentId": "doc-id-123",
    "contentType": "Plant Ally",
    "title": "Bramble",
    "seasonName": "Autumn",
    "clickAction": "FLUTTER_NOTIFICATION_CLICK"
  }
}
```

## Troubleshooting

### Function Not Triggering

**Check Firestore collection names match exactly:**
- Collection must be named `content_plant_allies` (not `plant_allies` or `content-plant-allies`)
- Document must have `status: "published"`

**View function logs:**
```powershell
firebase functions:log --only notifyOnPlantAllyCreate
```

### Notification Not Received

**1. Check device subscription:**
- User must have enabled notifications in app settings
- Device must be subscribed to `new-content` topic
- Check Firestore `users/{uid}` → `notificationsEnabled: true`

**2. Check FCM setup:**
- APNs key uploaded for iOS (Firebase Console → Project Settings → Cloud Messaging)
- `google-services.json` and `GoogleService-Info.plist` are up to date

**3. Test with Firebase Console:**
- Go to **Cloud Messaging** → **Send test message**
- Enter a device token from Firestore `users/{uid}/notificationTokens`
- If test works, the issue is with Cloud Functions

### "Insufficient Permissions" Error

The Cloud Function needs admin access to send FCM messages. This should be automatic, but verify:
- Service account has **Firebase Admin SDK** permissions
- Function deployment succeeded without errors

### Build Errors

**Cannot find module 'firebase-functions':**
```powershell
cd functions
npm install
```

**TypeScript compilation errors:**
```powershell
npm run build
# Review and fix any type errors
```

## Cost Considerations

Firebase Cloud Functions pricing:
- **Spark Plan (Free)**: 125K invocations/month, 40K GB-seconds, 40K CPU-seconds
- **Blaze Plan (Pay-as-you-go)**: $0.40 per million invocations

For typical content publishing (a few per day), you'll stay well within free tier limits.

## Testing Locally

Test functions locally with Firebase Emulator:

```powershell
cd functions
npm run serve
```

This starts local emulators. You can:
1. Add test documents through Firestore Emulator UI
2. See function execution logs in terminal
3. Test without deploying to production

## Updating Functions

After making changes to `functions/src/index.ts`:

```powershell
cd functions
npm run build
firebase deploy --only functions
```

## Rollback

If something goes wrong, rollback to previous version:

```powershell
firebase functions:delete notifyOnPlantAllyCreate
# Then redeploy the previous working version
```

## Production Checklist

Before going live:

- [ ] All 4 functions deployed successfully
- [ ] Tested notification with real content creation
- [ ] Verified notification appears on iOS device
- [ ] Verified notification appears on Android device
- [ ] Checked function logs show successful sends
- [ ] Confirmed users with notifications enabled receive them
- [ ] Verified unpublished content (`status != "published"`) doesn't trigger notifications

## Advanced: Notification on Update

If you want notifications when content changes from draft to published, uncomment the `notifyOnContentUpdate` function in `functions/src/index.ts` and redeploy.

## Need Help?

- **Firebase Functions docs**: https://firebase.google.com/docs/functions
- **FCM docs**: https://firebase.google.com/docs/cloud-messaging
- **Check logs**: `firebase functions:log`
- **Discord/Support**: Check Firebase status page if all functions fail

---

**Next Steps After Deployment:**
1. Add new content in Firebase Console
2. Watch your test device receive the notification
3. Celebrate! 🎉
