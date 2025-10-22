import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'dart:developer' as developer;
import '../../data/services/content_notification_service.dart';
import '../../data/models/content.dart';
import 'realtime_content_provider.dart';

final contentNotificationServiceProvider = Provider<ContentNotificationService>((ref) {
  return ContentNotificationService();
});

/// Provider that monitors all content types and triggers notifications
final contentNotificationMonitorProvider = Provider<void>((ref) {
  // Initialize the notification service
  final notificationService = ref.watch(contentNotificationServiceProvider);
  notificationService.initialize();

  // Monitor each content type
  _monitorContentType(ref, ContentType.plant, notificationService);
  _monitorContentType(ref, ContentType.recipe, notificationService);
  _monitorContentType(ref, ContentType.seasonal, notificationService);
});

void _monitorContentType(
  Ref ref,
  ContentType contentType,
  ContentNotificationService notificationService,
) {
  // Watch the real-time content for this type
  ref.listen<RealTimeContentState>(
    realTimeContentByTypeProvider(contentType),
    (previous, next) {
      // Only notify if we have new items and not in loading/error state
      if (next.isLoading || next.error != null) {
        return;
      }

      // If this is the first load (previous is null), don't notify
      // We only want to notify about NEW content added after app starts
      if (previous == null || previous.items.isEmpty) {
        _debugLog('[$contentType] Initial load, skipping notifications');
        return;
      }

      // Find newly added items
      final previousIds = previous.items.map((item) => item.id).toSet();
      final newItems = next.items.where((item) => !previousIds.contains(item.id)).toList();

      if (newItems.isEmpty) {
        return;
      }

      _debugLog('[$contentType] Found ${newItems.length} new items');

      // Notify for each new item
      for (final content in newItems) {
        _notifyNewContent(content, notificationService);
      }
    },
  );
}

void _notifyNewContent(
  Content content,
  ContentNotificationService notificationService,
) {
  final contentType = _getContentTypeName(content.type);
  
  _debugLog('Triggering notification for: ${content.id} - ${content.title}');

  notificationService.checkAndNotifyNewContent(
    contentId: content.id,
    title: content.title,
    summary: content.summary ?? content.subtitle,
    contentType: contentType,
    seasonName: content.season,
  );
}

String _getContentTypeName(ContentType type) {
  switch (type) {
    case ContentType.plant:
      return 'Plant Ally';
    case ContentType.recipe:
      return 'Recipe';
    case ContentType.seasonal:
      return 'Seasonal Wisdom';
  }
}

void _debugLog(String message) {
  if (!kDebugMode) return;
  developer.log(
    message,
    name: 'ContentNotificationMonitor',
  );
}
