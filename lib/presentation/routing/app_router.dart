import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/splash_screen.dart';
import '../screens/home_screen.dart';
import '../screens/content_detail_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/profile_setup_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/profile_edit_screen.dart';
import '../screens/notification_settings_screen.dart';
import '../screens/privacy_settings_screen.dart';
import '../screens/help_support_screen.dart';

final firebaseAuthProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(firebaseAuthProvider);
  
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) async {
      // Show loading during auth state determination
      if (authState.isLoading) {
        return '/splash';
      }
      
      final user = authState.value;
      final loggedIn = user != null;
      final loggingIn = state.matchedLocation == '/login';
      final registering = state.matchedLocation == '/register';
      final onProfileSetup = state.matchedLocation == '/profile-setup';
      
      // If not authenticated, go to login
      if (!loggedIn && !loggingIn && !registering) {
        return '/login';
      }
      
      // If logged in, check profile completion
      if (loggedIn && !onProfileSetup && !loggingIn && !registering) {
        try {
          final userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
          
          final profileCompleted = userDoc.data()?['profileCompleted'] ?? false;
          if (!profileCompleted) {
            return '/profile-setup';
          }
        } catch (e) {
          // If error checking profile, allow through
        }
      }
      
      // If logged in and on auth pages, go to home
      if (loggedIn && (loggingIn || registering)) {
        return '/';
      }
      
      return null;
    },
    routes: [
      GoRoute(path: '/splash', builder: (c, s) => const SplashScreen()),
      GoRoute(path: '/', builder: (c, s) => const HomeScreen()),
      GoRoute(path: '/login', builder: (c, s) => const LoginScreen()),
      GoRoute(path: '/register', builder: (c, s) => const RegisterScreen()),
      GoRoute(path: '/profile-setup', builder: (c, s) => const ProfileSetupScreen()),
      GoRoute(path: '/settings', builder: (c, s) => const SettingsScreen()),
      GoRoute(path: '/profile-edit', builder: (c, s) => const ProfileEditScreen()),
      GoRoute(path: '/notification-settings', builder: (c, s) => const NotificationSettingsScreen()),
      GoRoute(path: '/privacy-settings', builder: (c, s) => const PrivacySettingsScreen()),
      GoRoute(path: '/help-support', builder: (c, s) => const HelpSupportScreen()),
      GoRoute(
        path: '/content/:id',
        builder: (c, s) => ContentScreen(contentId: s.pathParameters['id']!),
      ),
    ],
  );
});

// Removed custom refresh stream (using ValueNotifier instead).
