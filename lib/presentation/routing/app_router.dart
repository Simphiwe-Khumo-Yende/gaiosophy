import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/splash_screen.dart';
import '../screens/home_screen.dart';
import '../screens/content_detail_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';

final firebaseAuthProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(firebaseAuthProvider);
  
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      // Show loading during auth state determination
      if (authState.isLoading) {
        return '/splash';
      }
      
      final user = authState.value;
      final loggedIn = user != null;
      final loggingIn = state.matchedLocation == '/login';
      final registering = state.matchedLocation == '/register';
      
      // If not authenticated, go to login
      if (!loggedIn && !loggingIn && !registering) {
        return '/login';
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
      GoRoute(
        path: '/content/:id',
        builder: (c, s) => ContentDetailScreen(contentId: s.pathParameters['id']!),
      ),
    ],
  );
});

// Removed custom refresh stream (using ValueNotifier instead).
