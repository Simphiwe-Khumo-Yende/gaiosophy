import 'dart:async';
import 'dart:developer' as developer;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../firebase_options.dart';
import '../repositories/user_notification_repository.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (kDebugMode) {
    developer.log(
      'Background message received: id=${message.messageId}, data=${message.data}',
      name: 'PushNotificationService',
    );
  }
}

class PushNotificationService {
  PushNotificationService({
    FirebaseMessaging? messaging,
    FirebaseAuth? auth,
    UserNotificationRepository? repository,
    FlutterLocalNotificationsPlugin? localNotificationsPlugin,
  String? webVapidKey,
  })  : _messaging = messaging ?? FirebaseMessaging.instance,
        _auth = auth ?? FirebaseAuth.instance,
        _repository =
            repository ?? FirestoreUserNotificationRepository(),
        _localNotificationsPlugin =
      localNotificationsPlugin ?? FlutterLocalNotificationsPlugin(),
    _webVapidKey = webVapidKey;

  static const String newContentTopic = 'new-content';

  final FirebaseMessaging _messaging;
  final FirebaseAuth _auth;
  final UserNotificationRepository _repository;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin;
  final String? _webVapidKey;
  final StreamController<RemoteMessage> _messageOpenedStreamController =
      StreamController<RemoteMessage>.broadcast();

  bool _isInitialized = false;
  bool _notificationsEnabled = false;

  Stream<RemoteMessage> get onMessageOpenedStream =>
      _messageOpenedStreamController.stream;

  static const AndroidNotificationChannel _contentChannel =
      AndroidNotificationChannel(
    'gaiosophy_content_updates',
    'Content Updates',
    description: 'Alerts when new Gaiosophy content is published.',
    importance: Importance.high,
  );

  Future<void> initialize() async {
    if (_isInitialized) {
      _debugLog('initialize skipped – already initialized');
      return;
    }
    _isInitialized = true;
    _debugLog('Initializing push notifications…');

    if (!kIsWeb) {
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
      _debugLog('Configured background handler');
      await _configureLocalNotifications();
    }

    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
    _debugLog('Registered foreground and opened-app listeners');

    if (!kIsWeb) {
      final RemoteMessage? initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {
        _debugLog('Initial message available: id=${initialMessage.messageId}');
        _messageOpenedStreamController.add(initialMessage);
      }
    }

    final User? user = _auth.currentUser;
    if (user != null) {
      _debugLog('User ${user.uid} detected, loading notification preferences');
      final bool? enabled =
          await _repository.getNotificationsEnabled(uid: user.uid);
      _notificationsEnabled = enabled ?? false;

      if (_notificationsEnabled) {
        _debugLog('Notifications previously enabled – refreshing token and topics');
        final String? token = await _getToken();
        if (token != null) {
          _debugLog('Restoring token for ${user.uid}: $token');
          await _repository.addToken(uid: user.uid, token: token);
        }
        await _subscribeToContentTopic();
      }
    }

    _messaging.onTokenRefresh.listen((String token) async {
      _debugLog('Token refresh callback received: $token');
      final User? refreshUser = _auth.currentUser;
      if (refreshUser == null || !_notificationsEnabled) {
        _debugLog('Token refresh ignored – user missing or notifications disabled');
        return;
      }

      await _repository.addToken(uid: refreshUser.uid, token: token);
      await _subscribeToContentTopic();
    });
    _debugLog('PushNotificationService initialization complete');
  }

  Future<bool> enableNotifications() async {
    final User? user = _auth.currentUser;
    if (user == null) {
      _debugLog('enableNotifications aborted – no signed-in user');
      return false;
    }

    _debugLog('Requesting notification permission for ${user.uid}');
    final NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
      providesAppNotificationSettings: false,
    );

    final bool isAuthorized = settings.authorizationStatus ==
            AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;

    if (!isAuthorized) {
      _debugLog('Permission denied: status=${settings.authorizationStatus}');
      await _repository.setNotificationsEnabled(uid: user.uid, enabled: false);
      return false;
    }

    final String? token = await _getToken();
    if (token == null) {
      _debugLog('Failed to obtain FCM token');
      await _repository.setNotificationsEnabled(uid: user.uid, enabled: false);
      return false;
    }

    _debugLog('Permission granted. Token=$token');
    await _repository.addToken(uid: user.uid, token: token);
    await _repository.setNotificationsEnabled(uid: user.uid, enabled: true);
    await _subscribeToContentTopic();
    _notificationsEnabled = true;
    _debugLog('Notifications enabled successfully for ${user.uid}');

    return true;
  }

  Future<void> disableNotifications() async {
    final User? user = _auth.currentUser;
    if (user == null) {
      _debugLog('disableNotifications aborted – no signed-in user');
      return;
    }

    final String? token = await _getToken();
    if (token != null) {
      _debugLog('Removing token $token for ${user.uid}');
      await _repository.removeToken(uid: user.uid, token: token);
    }
    await _repository.setNotificationsEnabled(uid: user.uid, enabled: false);
    if (!kIsWeb) {
      await _messaging.unsubscribeFromTopic(newContentTopic);
      _debugLog('Unsubscribed from topic $newContentTopic');
    }
    _notificationsEnabled = false;
    _debugLog('Notifications disabled for ${user.uid}');
  }

  Future<void> dispose() async {
    await _messageOpenedStreamController.close();
  }

  Future<void> _configureLocalNotifications() async {
  const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/launcher_icon');
  const DarwinInitializationSettings iosSettings =
    DarwinInitializationSettings();
  const InitializationSettings initializationSettings =
    InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotificationsPlugin.initialize(initializationSettings);
    _debugLog('Local notifications configured');

    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _localNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidImplementation?.createNotificationChannel(_contentChannel);
    _debugLog('Android notification channel registered');
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    _debugLog('Foreground message received: id=${message.messageId}, data=${message.data}');
    if (kIsWeb) {
      // Browsers display their own foreground notifications; nothing to do.
      return;
    }
    final RemoteNotification? notification = message.notification;
    final AndroidNotification? android = message.notification?.android;

    final String title = notification?.title ??
        message.data['title'] as String? ??
        'New content available';
    final String body = notification?.body ??
        message.data['body'] as String? ??
        'Tap to explore the latest guidance.';

    final NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        _contentChannel.id,
        _contentChannel.name,
        channelDescription: _contentChannel.description,
        importance: Importance.high,
        priority: Priority.high,
        icon: android?.smallIcon ?? '@mipmap/launcher_icon',
      ),
      iOS: const DarwinNotificationDetails(),
    );

    await _localNotificationsPlugin.show(
      message.messageId.hashCode,
      title,
      body,
      notificationDetails,
      payload: message.data.isEmpty ? null : message.data['contentId'] as String?,
    );
    _debugLog('Displayed local notification for message ${message.messageId}');
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    _debugLog('Message opened app: id=${message.messageId}, data=${message.data}');
    _messageOpenedStreamController.add(message);
  }

  Future<String?> _getToken() async {
    try {
    if (kIsWeb) {
      if (_webVapidKey == null || _webVapidKey!.isEmpty) {
        _debugLog('Web VAPID key missing – cannot request token');
        return null;
      }
      final token = await _messaging.getToken(vapidKey: _webVapidKey);
      _debugLog('Obtained web token: $token');
      return token;
    }
    final token = await _messaging.getToken();
    _debugLog('Obtained device token: $token');
    return token;
    } catch (error, stackTrace) {
      _debugLog('Error obtaining FCM token', error: error, stackTrace: stackTrace);
      return null;
    }
  }

  Future<void> _subscribeToContentTopic() async {
    if (kIsWeb) {
      _debugLog('Skipping topic subscription on web');
      return;
    }

    await _messaging.subscribeToTopic(newContentTopic);
    _debugLog('Subscribed to topic $newContentTopic');
  }

  void _debugLog(String message, {Object? error, StackTrace? stackTrace}) {
    if (!kDebugMode) {
      return;
    }

    developer.log(
      message,
      name: 'PushNotificationService',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
