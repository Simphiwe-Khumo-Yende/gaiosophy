# Gaiosophy Mobile App

Consumer-facing Flutter application for the Gaiosophy platform.

## Project Overview

- **Framework:** Flutter (Dart)
- **State management:** Riverpod + hooks
- **Backend:** Firebase (Auth, Firestore, Storage)
- **Platforms:** Android, iOS, Web (experimental)

## Push Notifications

Push notifications for new content are handled through Firebase Cloud Messaging (FCM). Devices subscribe to the `new-content` topic when notifications are enabled from the in-app settings screen.

See [`PUSH_NOTIFICATIONS_SETUP.md`](./PUSH_NOTIFICATIONS_SETUP.md) for a full configuration guide covering Firebase, iOS capabilities, Android permissions, and the recommended Cloud Function trigger for publishing notifications.

## Getting Started

1. Install Flutter `>=3.0.0`.
2. Run `flutter pub get` to fetch dependencies.
3. Configure Firebase by supplying `google-services.json` and `GoogleService-Info.plist`.
4. Launch the app:
	- Android: `flutter run -d android`
	- iOS: `flutter run -d ios`

For more Flutter resources, visit the [official documentation](https://docs.flutter.dev/).
