import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'presentation/routing/app_router.dart';
import 'presentation/theme/app_theme.dart';
import 'firebase_options.dart';
import 'data/local/hive_init.dart';
import 'application/providers/push_notification_provider.dart';
import 'data/services/push_notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set up global error handlers FIRST
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('❌ Flutter Error: ${details.exception}');
    debugPrint('Stack trace: ${details.stack}');
  };
  
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('❌ PlatformDispatcher Error: $error');
    debugPrint('Stack trace: $stack');
    return true; // Prevent app crash
  };
  
  // Initialize Firebase with error handling
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    debugPrint('✅ Firebase initialized successfully');
  } catch (e, stackTrace) {
    debugPrint('❌ Firebase initialization error: $e');
    debugPrint('Stack trace: $stackTrace');
    _showErrorScreen('Firebase initialization failed', e);
    return;
  }
  
  // Set Firebase Auth persistence (web only)
  await _configureAuthPersistence();
  
  // Initialize offline storage with error handling
  try {
    await initHive();
    debugPrint('✅ Hive initialized successfully');
  } catch (e, stackTrace) {
    debugPrint('❌ Hive initialization error: $e');
    debugPrint('Stack trace: $stackTrace');
    _showErrorScreen('Local storage initialization failed', e);
    return;
  }
  
  // Initialize push notifications (non-blocking)
  PushNotificationService? pushNotificationService;
  try {
    const String webPushKey = String.fromEnvironment('WEB_PUSH_KEY', defaultValue: '');
    pushNotificationService = PushNotificationService(
      webVapidKey: webPushKey.isEmpty ? null : webPushKey,
    );
    
    // Initialize asynchronously - don't block app startup
    pushNotificationService.initialize().then((_) {
      debugPrint('✅ Push notifications initialized successfully');
    }).catchError((error, stackTrace) {
      debugPrint('⚠️ Push notifications unavailable: $error');
      debugPrint('Stack trace: $stackTrace');
      // App continues without push notifications
    });
  } catch (e, stackTrace) {
    debugPrint('⚠️ Push notification service creation failed: $e');
    debugPrint('Stack trace: $stackTrace');
    // Continue without push notifications
  }

  // Run app with or without push notification service
  runApp(
    ProviderScope(
      overrides: pushNotificationService != null
          ? [pushNotificationServiceProvider.overrideWithValue(pushNotificationService)]
          : [],
      child: const GaiosophyApp(),
    ),
  );
}

/// Configure Firebase Auth persistence
/// On mobile (iOS/Android): Auth automatically persists using secure storage
/// On web: Need to explicitly set persistence mode
Future<void> _configureAuthPersistence() async {
  try {
    // Only set persistence on web platform
    // Mobile platforms (iOS/Android) handle persistence automatically via Keychain/Keystore
    if (kIsWeb) {
      await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
      debugPrint('✅ Firebase Auth persistence set to LOCAL (web)');
    } else {
      debugPrint('✅ Firebase Auth using platform persistence (mobile)');
    }
  } catch (e, stackTrace) {
    // Persistence setting failed, but app can still function
    debugPrint('⚠️ Auth persistence configuration error: $e');
    debugPrint('Stack trace: $stackTrace');
    // Don't crash - authentication will still work, just won't persist across sessions
  }
}

/// Show error screen when critical initialization fails
void _showErrorScreen(String title, Object error) {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFFFCF9F2),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 80,
                    color: Color(0xFF8B6B47),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Failed to Start Gaiosophy',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1612),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF5A4E3C),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8DCC8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      error.toString(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'monospace',
                        color: Color(0xFF5A4E3C),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Please try:\n• Restarting the app\n• Checking your internet connection\n• Reinstalling if the issue persists',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF8B6B47),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class GaiosophyApp extends ConsumerWidget {
  const GaiosophyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Gaiosophy',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: ref.watch(appRouterProvider),
      builder: (context, widget) {
        // Set custom error widget for build-time errors
        ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
          return Scaffold(
            backgroundColor: const Color(0xFFFCF9F2),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      size: 64,
                      color: Color(0xFF8B6B47),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Something went wrong',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1612),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${errorDetails.exception}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF5A4E3C),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        };
        
        if (widget != null) return widget;
        throw StateError('widget is null');
      },
    );
  }
}
