import Flutter
import UIKit
import FirebaseCore
import FirebaseMessaging
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate, MessagingDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // DON'T initialize Firebase here - Flutter will do it in Dart
    // This prevents "Firebase already initialized" crash
    // if FirebaseApp.app() == nil {
    //   FirebaseApp.configure()
    // }

    // Push notification setup will be done after Firebase init in Dart
    // UNUserNotificationCenter.current().delegate = self
    // Messaging.messaging().delegate = self
    // application.registerForRemoteNotifications()

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    // Only set APNS token if Firebase Messaging is available
    if FirebaseApp.app() != nil {
      Messaging.messaging().apnsToken = deviceToken
    }
    super.application(
      application,
      didRegisterForRemoteNotificationsWithDeviceToken: deviceToken
    )
  }

  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    // Intentionally left blank; token syncing handled in Dart layer.
  }
}
