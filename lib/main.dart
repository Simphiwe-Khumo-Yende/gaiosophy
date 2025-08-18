import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'presentation/routing/app_router.dart';
import 'presentation/theme/app_theme.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: GaiosophyApp()));
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
