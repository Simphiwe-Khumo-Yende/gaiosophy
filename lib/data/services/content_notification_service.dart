import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;

class ContentNotificationService {
  ContentNotificationService({
    FlutterLocalNotificationsPlugin? localNotificationsPlugin,
  }) : _localNotificationsPlugin =
            localNotificationsPlugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _localNotificationsPlugin;
  bool _isInitialized = false;

  static const String _lastNotifiedContentIdsKey = 'last_notified_content_ids';
  static const String _notificationChannelId = 'gaiosophy_content_updates';
  static const String _notificationChannelName = 'Content Updates';
  static const String _notificationChannelDescription =
      'Notifications when new content is published in Gaiosophy';

  Future<void> initialize() async {
    if (_isInitialized || kIsWeb) return;
    _isInitialized = true;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotificationsPlugin.initialize(initSettings);

    // Create Android notification channel
    if (!kIsWeb) {
      const androidChannel = AndroidNotificationChannel(
        _notificationChannelId,
        _notificationChannelName,
        description: _notificationChannelDescription,
        importance: Importance.high,
        playSound: true,
        enableVibration: true,
      );

      await _localNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(androidChannel);
    }

    _debugLog('ContentNotificationService initialized');
  }

  Future<void> checkAndNotifyNewContent({
    required String contentId,
    required String title,
    required String? summary,
    required String contentType,
    String? seasonName,
  }) async {
    if (kIsWeb) return;

    final prefs = await SharedPreferences.getInstance();
    final notifiedIds = prefs.getStringList(_lastNotifiedContentIdsKey) ?? [];

    // If this content hasn't been notified yet
    if (!notifiedIds.contains(contentId)) {
      _debugLog('New content detected: $contentId - $title');
      
      await _showNewContentNotification(
        contentId: contentId,
        title: title,
        summary: summary,
        contentType: contentType,
        seasonName: seasonName,
      );

      // Store this content ID (keep only last 50 to prevent unlimited growth)
      notifiedIds.add(contentId);
      if (notifiedIds.length > 50) {
        notifiedIds.removeAt(0); // Remove oldest
      }
      await prefs.setStringList(_lastNotifiedContentIdsKey, notifiedIds);
    } else {
      _debugLog('Content already notified: $contentId');
    }
  }

  Future<void> _showNewContentNotification({
    required String contentId,
    required String title,
    required String? summary,
    required String contentType,
    String? seasonName,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    final body = summary ?? 'Tap to explore the latest seasonal guidance.';
    final emoji = _getEmojiForContentType(contentType);

    const androidDetails = AndroidNotificationDetails(
      _notificationChannelId,
      _notificationChannelName,
      channelDescription: _notificationChannelDescription,
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Use a unique notification ID based on content ID hash to avoid collisions
    final notificationId = contentId.hashCode;

    await _localNotificationsPlugin.show(
      notificationId,
      '$emoji New $contentType: $title',
      body,
      notificationDetails,
      payload: 'content:$contentId',
    );

    _debugLog('Notification shown for content: $contentId');
  }

  String _getEmojiForContentType(String contentType) {
    final type = contentType.toLowerCase();
    if (type.contains('plant')) return '🌿';
    if (type.contains('recipe')) return '🍲';
    if (type.contains('seasonal') || type.contains('wisdom')) return '✨';
    return '📖';
  }

  Future<void> clearNotifiedContent() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_lastNotifiedContentIdsKey);
    _debugLog('Cleared all notified content IDs');
  }

  void _debugLog(String message) {
    if (!kDebugMode) return;
    developer.log(
      message,
      name: 'ContentNotificationService',
    );
  }
}
