# Push Notifications Setup

This document captures the end-to-end configuration needed to deliver push notifications whenever new content is published to the Gaiosophy platform.

## 1. Firebase configuration

1. **Update service files** – Download the latest `google-services.json` and `GoogleService-Info.plist` from the Firebase console after enabling _Cloud Messaging_. Replace the existing files under `android/app/` and `ios/Runner/` respectively.
2. **APNs key / certificates** – Upload your APNs authentication key (recommended) or certificates to the **Project settings → Cloud Messaging** tab. This step is required for iOS devices to receive pushes.
3. **Server key access** – Store the **Firebase Cloud Messaging server key** as a secret in GitHub (`FIREBASE_FCM_SERVER_KEY`) and in any other infrastructure that will send pushes (for example, Cloud Functions or the content CMS).

## 2. Apple Developer portal

1. Enable the **Push Notifications** capability for the `Runner` target (done in code via `Runner.entitlements`, but you must also toggle it in Xcode when generating provisioning profiles).
2. If you use separate provisioning profiles for Debug and Release, create both Development and Production push certificates. Alternatively, use an APNs key which works across environments.

## 3. Android configuration

- Ensure the app is signed with the upload key. No extra Play Console configuration is needed beyond shipping the updated APK/AAB generated after these changes.

## 4. Topic and token management

- Devices subscribe to the `new-content` topic whenever a signed-in user enables notifications.
- The Firestore document `users/{uid}` now stores:
  ```json
  {
    "notificationsEnabled": true,
    "notificationTokens": ["<token>"]
  }
  ```
- Tokens are refreshed automatically; whenever Firebase rotates a token, the app re-saves it and keeps the topic subscription in sync.

## 5. Sending notifications when content is published

You can trigger notifications from any backend environment. Below is a lightweight Firebase Cloud Function (Node.js 18) that broadcasts to the `new-content` topic whenever a new content document is created:

```ts
import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

export const notifyOnContentCreate = functions.firestore
  .document("content/{contentId}")
  .onCreate(async (snapshot, context) => {
    const data = snapshot.data();
    if (!data) {
      return null;
    }

    const title = data.title ?? "New wisdom available";
    const teaser = data.summary ?? "Tap to explore the latest seasonal guidance.";

    return admin.messaging().send({
      topic: "new-content",
      notification: {
        title,
        body: teaser,
      },
      data: {
        contentId: context.params.contentId,
        contentType: data.type ?? "unknown",
      },
    });
  });
```

### Deployment tips

1. Create a `functions` directory with a standard Firebase setup (`firebase init functions`) if you do not already host Cloud Functions.
2. Set the runtime to Node.js 18 and deploy with `firebase deploy --only functions:notifyOnContentCreate`.
3. If the CMS or another service publishes content via REST, you can instead hit the FCM send API directly, using the stored server key.

## 6. QA checklist

- [ ] Android 13+ prompt shows when enabling notifications for the first time.
- [ ] iOS prompt appears the first time notifications are toggled on.
- [ ] Disabling notifications removes the device from the topic and clears the token from Firestore.
- [ ] New content creation triggers a push via the workflow in section 5.
- [ ] Foreground notifications appear using the in-app banner (backed by `flutter_local_notifications`).

## 7. Troubleshooting

| Symptom | Likely cause | Fix |
| --- | --- | --- |
| Device never receives notifications | APNs key not uploaded or push capability missing | Upload APNs key/cert and regenerate provisioning profile |
| Foreground notifications suppressed on iOS | Presentation options not granted | Check device settings → Notifications → allow alerts |
| Duplicate tokens in Firestore | Old app installs not cleaned up | Call `disableNotifications()` during sign-out or when uninstalling test builds |
| Topic broadcast succeeds but no device receives | Device opted out (`notificationsEnabled = false`) | Toggle notifications back on in the app |

With these steps in place, every new piece of published content will automatically push to opted-in devices across Android and iOS.

## 8. Web (Chrome) development tips

- Ensure `web/firebase-messaging-sw.js` stays in sync with the Firebase configuration above. This file is required for background notifications in browsers.
- Generate a Web Push certificate (VAPID key) in the Firebase console and pass it to the Flutter app when running on web:

  ```powershell
  flutter run -d chrome --dart-define=WEB_PUSH_KEY=<your-public-vapid-key>
  ```

- Chrome treats `http://localhost` as a secure origin, so notifications can be tested locally. Once the app is running, enable notifications from the in-app toggle (Chrome will present the permission prompt).
- Use **Firebase Console → Cloud Messaging → Send Test Message** and paste the device token printed in the debug console (or retrieved from Firestore) to validate delivery.
- Topic subscriptions are not currently supported on web; make sure your backend sends messages directly to the stored web tokens or uses a separate delivery channel.
