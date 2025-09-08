import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mocktail/mocktail.dart';
import 'package:gaiosophy_app/data/services/password_reset_service.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

void main() {
  group('PasswordResetService', () {
    test('validates email format correctly', () {
      // Valid emails
      expect(PasswordResetService.isValidEmail('test@example.com'), true);
      expect(PasswordResetService.isValidEmail('user.name+tag@domain.co.uk'), true);
      expect(PasswordResetService.isValidEmail('user123@test-domain.com'), true);
      
      // Invalid emails
      expect(PasswordResetService.isValidEmail('invalid-email'), false);
      expect(PasswordResetService.isValidEmail('@domain.com'), false);
      expect(PasswordResetService.isValidEmail('user@'), false);
      expect(PasswordResetService.isValidEmail('user@domain'), false);
      expect(PasswordResetService.isValidEmail(''), false);
    });

    test('returns correct error messages for error codes', () {
      expect(
        PasswordResetService.getErrorMessage('user-not-found'),
        'No account found with this email address.',
      );
      expect(
        PasswordResetService.getErrorMessage('invalid-email'),
        'Please enter a valid email address.',
      );
      expect(
        PasswordResetService.getErrorMessage('too-many-requests'),
        'Too many requests. Please try again in a few minutes.',
      );
      expect(
        PasswordResetService.getErrorMessage('unknown-error'),
        'An error occurred. Please try again.',
      );
    });

    test('logs password reset attempts correctly', () {
      // This test verifies that the logging method doesn't throw errors
      expect(() {
        PasswordResetService.logPasswordResetAttempt(
          email: 'test@example.com',
          success: true,
        );
      }, returnsNormally);

      expect(() {
        PasswordResetService.logPasswordResetAttempt(
          email: 'test@example.com',
          success: false,
          errorCode: 'user-not-found',
        );
      }, returnsNormally);
    });
  });
}
