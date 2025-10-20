import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../application/providers/push_notification_provider.dart';

/// Initializes notification tap handling for the app
/// Call this in the main app widget to enable navigation when users tap notifications
class NotificationNavigationHandler {
  NotificationNavigationHandler(this.ref);

  final WidgetRef ref;
  bool _initialized = false;

  /// Initialize notification tap listeners
  /// This should be called once when the app starts
  void initialize(BuildContext context) {
    if (_initialized) return;
    _initialized = true;

    try {
      final pushService = ref.read(pushNotificationServiceProvider);

      // Listen to notification taps (when app is in background/foreground)
      pushService.onMessageOpenedStream.listen((RemoteMessage message) {
        _handleNotificationTap(context, message);
      });

      debugPrint('✅ Notification navigation handler initialized');
    } catch (e) {
      debugPrint('⚠️ Could not initialize notification navigation: $e');
    }
  }

  /// Handle notification tap and navigate to appropriate screen
  void _handleNotificationTap(BuildContext context, RemoteMessage message) {
    debugPrint('📱 Notification tapped: ${message.data}');

    final contentId = message.data['contentId'] as String?;
    final contentType = message.data['contentType'] as String?;

    if (contentId != null && contentId.isNotEmpty) {
      // Navigate to content detail screen
      _navigateToContent(context, contentId, contentType);
    } else {
      // Fallback: Navigate to home screen
      _navigateToHome(context);
    }
  }

  /// Navigate to content detail screen
  void _navigateToContent(BuildContext context, String contentId, String? contentType) {
    try {
      // Use GoRouter to navigate
      final router = GoRouter.of(context);
      
      // Navigate to content detail
      router.push('/content/$contentId');

      debugPrint('✅ Navigated to content: $contentId (type: $contentType)');
    } catch (e) {
      debugPrint('❌ Navigation error: $e');
      // Fallback to home
      _navigateToHome(context);
    }
  }

  /// Navigate to home screen
  void _navigateToHome(BuildContext context) {
    try {
      final router = GoRouter.of(context);
      router.go('/');
      debugPrint('✅ Navigated to home');
    } catch (e) {
      debugPrint('❌ Home navigation error: $e');
    }
  }
}

/// Widget that initializes notification handling when the app starts
/// Wrap your app with this widget to enable notification tap navigation
class NotificationNavigationWrapper extends ConsumerStatefulWidget {
  const NotificationNavigationWrapper({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  ConsumerState<NotificationNavigationWrapper> createState() =>
      _NotificationNavigationWrapperState();
}

class _NotificationNavigationWrapperState
    extends ConsumerState<NotificationNavigationWrapper> {
  NotificationNavigationHandler? _handler;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Initialize handler only once when we have context
    if (_handler == null) {
      _handler = NotificationNavigationHandler(ref);
      _handler!.initialize(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
