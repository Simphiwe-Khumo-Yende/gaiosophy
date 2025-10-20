import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';

class SeasonNotificationService {
  SeasonNotificationService({
    FlutterLocalNotificationsPlugin? localNotificationsPlugin,
  }) : _localNotificationsPlugin =
            localNotificationsPlugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _localNotificationsPlugin;
  bool _isInitialized = false;

  static const String _lastSeasonKey = 'last_season_name';
  static const String _notificationChannelId = 'gaiosophy_season_changes';
  static const String _notificationChannelName = 'Season Changes';
  static const String _notificationChannelDescription =
      'Notifications when the season changes in Gaiosophy';

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
  }

  Future<void> checkAndNotifySeasonChange({
    required String newSeasonName,
    String? element,
    String? direction,
  }) async {
    if (kIsWeb) return;

    final prefs = await SharedPreferences.getInstance();
    final lastSeason = prefs.getString(_lastSeasonKey);

    // If this is the first time or season has changed
    if (lastSeason != null && lastSeason != newSeasonName) {
      await _showSeasonChangeNotification(
        newSeasonName: newSeasonName,
        element: element,
        direction: direction,
      );
    }

    // Store the current season
    await prefs.setString(_lastSeasonKey, newSeasonName);
  }

  Future<void> _showSeasonChangeNotification({
    required String newSeasonName,
    String? element,
    String? direction,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    final elementText = element != null ? ' • $element' : '';
    final directionText = direction != null ? ' • $direction' : '';

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

    await _localNotificationsPlugin.show(
      0, // notification ID
      '🍂 New Season: $newSeasonName',
      'Explore new seasonal wisdom, rituals, and plant allies$elementText$directionText',
      notificationDetails,
      payload: 'season_change:$newSeasonName',
    );
  }

  Future<void> clearLastSeason() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_lastSeasonKey);
  }
}
