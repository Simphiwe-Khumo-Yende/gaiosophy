import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'presentation/routing/app_router.dart';
import 'presentation/theme/app_theme.dart';
import 'firebase_options.dart';
import 'data/local/hive_init.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  // Set Firebase Auth persistence to 30 days
  await _configureAuthPersistence();
  
  // Initialize offline storage
  await initHive();
  
  runApp(const ProviderScope(child: GaiosophyApp()));
}

Future<void> _configureAuthPersistence() async {
  try {
    // Firebase Auth on mobile platforms automatically persists sessions
    // The session will persist until the user signs out or the token expires
    // Firebase tokens typically last for 1 hour but are automatically refreshed
    // We can configure the app to maintain the user session indefinitely until manual logout
    
    // For web platforms, we can set persistence explicitly
    if (FirebaseAuth.instance.app.options.projectId.isNotEmpty) {
      // Set auth state persistence - this keeps the user logged in across app restarts
      await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
    }
  } catch (e) {
    // Persistence setting failed, but app can still function
    print('Failed to set auth persistence: $e');
  }
}

class GaiosophyApp extends ConsumerWidget {
  const GaiosophyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
  // Bootstrap no longer blocks UI; run side-effects after first frame if needed.
  return MaterialApp.router(
      title: 'Gaiosophy',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: ref.watch(appRouterProvider),
  builder: (context, child) => child!,
    );
  }
}
