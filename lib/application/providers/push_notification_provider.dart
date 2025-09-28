import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/services/push_notification_service.dart';

final pushNotificationServiceProvider = Provider<PushNotificationService>((ref) {
  throw UnimplementedError(
    'pushNotificationServiceProvider must be overridden at the root level.',
  );
});
