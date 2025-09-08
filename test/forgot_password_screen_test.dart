import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaiosophy_app/presentation/screens/forgot_password_screen.dart';

void main() {
  group('ForgotPasswordScreen Widget Tests', () {
    testWidgets('displays forgot password form correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const ForgotPasswordScreen(),
        ),
      );

      // Verify initial UI elements
      expect(find.text('Forgot Your Password?'), findsOneWidget);
      expect(find.text('No worries! Enter your email address and we\'ll send you a link to reset your password.'), findsOneWidget);
      expect(find.text('Email Address'), findsOneWidget);
      expect(find.text('Send Reset Link'), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('shows validation error for empty email', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const ForgotPasswordScreen(),
        ),
      );

      // Tap the send button without entering email
      await tester.tap(find.text('Send Reset Link'));
      await tester.pump();

      // Verify validation error appears
      expect(find.text('Please enter your email address'), findsOneWidget);
    });

    testWidgets('shows validation error for invalid email format', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const ForgotPasswordScreen(),
        ),
      );

      // Enter invalid email
      await tester.enterText(find.byType(TextFormField), 'invalid-email');
      await tester.tap(find.text('Send Reset Link'));
      await tester.pump();

      // Verify validation error appears
      expect(find.text('Please enter a valid email address'), findsOneWidget);
    });

    testWidgets('accepts valid email format', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const ForgotPasswordScreen(),
        ),
      );

      // Enter valid email
      await tester.enterText(find.byType(TextFormField), 'test@example.com');
      await tester.tap(find.text('Send Reset Link'));
      await tester.pump();

      // Verify no validation error appears
      expect(find.text('Please enter a valid email address'), findsNothing);
      expect(find.text('Please enter your email address'), findsNothing);
    });

    testWidgets('shows loading state when sending email', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const ForgotPasswordScreen(),
        ),
      );

      // Enter valid email
      await tester.enterText(find.byType(TextFormField), 'test@example.com');
      
      // Tap send button
      await tester.tap(find.text('Send Reset Link'));
      await tester.pump();

      // Verify loading indicator appears (before async operation completes)
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays back button in app bar', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const ForgotPasswordScreen(),
        ),
      );

      // Verify back button exists
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.text('Reset Password'), findsOneWidget);
    });

    testWidgets('shows help text and back to login link', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const ForgotPasswordScreen(),
        ),
      );

      // Verify help text and link
      expect(find.text('Remember your password?'), findsOneWidget);
      expect(find.text('Back to Login'), findsOneWidget);
    });
  });
}
