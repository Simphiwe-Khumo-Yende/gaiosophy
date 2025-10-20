import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/season_notification_service.dart';
import 'app_config_provider.dart';

final seasonNotificationServiceProvider = Provider<SeasonNotificationService>((ref) {
  return SeasonNotificationService();
});

final seasonChangeMonitorProvider = Provider<void>((ref) {
  final appConfig = ref.watch(appConfigProvider);
  final notificationService = ref.watch(seasonNotificationServiceProvider);

  // Initialize the notification service
  notificationService.initialize();

  // Check and notify about season changes
  notificationService.checkAndNotifySeasonChange(
    newSeasonName: appConfig.currentSeasonName,
    element: appConfig.appElement.isNotEmpty ? appConfig.appElement : null,
    direction: appConfig.appDirection.isNotEmpty ? appConfig.appDirection : null,
  );
});
