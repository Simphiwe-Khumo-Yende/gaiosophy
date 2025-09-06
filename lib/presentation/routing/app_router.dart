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
import '../screens/saved_content_screen.dart';
import '../screens/search_screen.dart';
import '../screens/disclaimer_screen.dart';
import '../screens/legal_screen.dart';
import '../screens/content_icon_demo_screen.dart';
import '../../data/services/disclaimer_service.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(firebaseAuthProvider);
  final disclaimerAccepted = ref.watch(disclaimerAcceptedProvider);
  
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) async {
      // Show loading during auth state determination
      if (authState.isLoading || disclaimerAccepted.isLoading) {
        return '/splash';
      }
      
      final user = authState.value;
      final loggedIn = user != null;
      final hasAcceptedDisclaimer = disclaimerAccepted.value ?? false;
      final loggingIn = state.matchedLocation == '/login';
      final registering = state.matchedLocation == '/register';
      final onProfileSetup = state.matchedLocation == '/profile-setup';
      final onDisclaimer = state.matchedLocation == '/disclaimer';
      final onLegal = state.matchedLocation == '/legal';
      
      // Always allow access to legal page
      if (onLegal) {
        return null;
      }
      
      // If not authenticated, go to login (but not if already on login/register)
      if (!loggedIn && !loggingIn && !registering) {
        return '/login';
      }
      
      // If logged in, check profile completion first
      if (loggedIn && !onProfileSetup && !loggingIn && !registering && !onDisclaimer) {
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
      
      // After profile is complete, check disclaimer acceptance for authenticated users
      if (loggedIn && !hasAcceptedDisclaimer && !onDisclaimer && !onProfileSetup && !loggingIn && !registering) {
        return '/disclaimer';
      }
      
      // If logged in and on auth pages, go to home
      if (loggedIn && (loggingIn || registering)) {
        return '/';
      }
      
      return null;
    },
    routes: [
      GoRoute(path: '/splash', builder: (c, s) => const SplashScreen()),
      GoRoute(path: '/disclaimer', builder: (c, s) => const DisclaimerScreen()),
      GoRoute(path: '/', builder: (c, s) => const HomeScreen()),
      GoRoute(path: '/search', builder: (c, s) => const SearchScreen()),
      GoRoute(path: '/login', builder: (c, s) => const LoginScreen()),
      GoRoute(path: '/register', builder: (c, s) => const RegisterScreen()),
      GoRoute(path: '/profile-setup', builder: (c, s) => const ProfileSetupScreen()),
      GoRoute(path: '/settings', builder: (c, s) => const SettingsScreen()),
      GoRoute(path: '/profile-edit', builder: (c, s) => const ProfileEditScreen()),
      GoRoute(path: '/notification-settings', builder: (c, s) => const NotificationSettingsScreen()),
      GoRoute(path: '/privacy-settings', builder: (c, s) => const PrivacySettingsScreen()),
      GoRoute(path: '/help-support', builder: (c, s) => const HelpSupportScreen()),
      GoRoute(path: '/saved-content', builder: (c, s) => const SavedContentScreen()),
      GoRoute(path: '/legal', builder: (c, s) => const LegalScreen()),
      GoRoute(path: '/content-icon-demo', builder: (c, s) => const ContentIconDemoScreen()),
      GoRoute(
        path: '/content/:id',
        builder: (c, s) => ContentScreen(contentId: s.pathParameters['id']!),
      ),
    ],
  );
});
