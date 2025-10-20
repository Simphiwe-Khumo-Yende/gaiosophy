# Gaiosophy Mobile App

Consumer-facing Flutter application for the Gaiosophy platform.

## Project Overview

- **Framework:** Flutter (Dart)
- **State management:** Riverpod + hooks
- **Backend:** Firebase (Auth, Firestore, Storage)
- **Platforms:** Android, iOS, Web (experimental)

## Push Notifications

Push notifications for new content are fully automated using Firebase Cloud Messaging (FCM) and Cloud Functions. When new content is added to Firestore, notifications are automatically sent to all users who have enabled notifications.

**Key Features:**
- ✅ Automatic notifications when content is created
- ✅ Real-time content updates in app
- ✅ Tap notifications to view content
- ✅ Works across iOS, Android, and Web

**Documentation:**
- [`PUSH_NOTIFICATIONS_COMPLETE.md`](./PUSH_NOTIFICATIONS_COMPLETE.md) - Quick start guide
- [`CLOUD_FUNCTIONS_DEPLOYMENT.md`](./CLOUD_FUNCTIONS_DEPLOYMENT.md) - Deploy Cloud Functions
- [`PUSH_NOTIFICATIONS_SETUP.md`](./PUSH_NOTIFICATIONS_SETUP.md) - FCM configuration
- [`PUSH_NOTIFICATIONS_IMPLEMENTATION.md`](./PUSH_NOTIFICATIONS_IMPLEMENTATION.md) - Technical details

**To Enable:**
1. Deploy Cloud Functions: `cd functions && npm install && firebase deploy --only functions`
2. Users enable notifications in Settings → Notifications
3. New content with `status: "published"` triggers automatic notifications

## Getting Started

1. Install Flutter `>=3.0.0`.
2. Run `flutter pub get` to fetch dependencies.
3. Configure Firebase by supplying `google-services.json` and `GoogleService-Info.plist`.
4. Launch the app:
	- Android: `flutter run -d android`
	- iOS: `flutter run -d ios`

For more Flutter resources, visit the [official documentation](https://docs.flutter.dev/).
