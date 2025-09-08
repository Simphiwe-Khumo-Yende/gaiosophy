import 'package:firebase_auth/firebase_auth.dart';

/// Service for handling password reset functionality
class PasswordResetService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Sends a password reset email to the specified email address
  /// 
  /// Returns a map with success status and message
  /// - success: true if email was sent successfully
  /// - message: descriptive message about the result
  /// - error: error code if applicable
  static Future<Map<String, dynamic>> sendPasswordResetEmail({
    required String email,
  }) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      
      return {
        'success': true,
        'message': 'Password reset email sent successfully! Please check your inbox and spam folder.',
      };
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No account found with this email address. Please check the email or create a new account.';
          break;
        case 'invalid-email':
          message = 'Please enter a valid email address.';
          break;
        case 'too-many-requests':
          message = 'Too many password reset requests. Please wait a few minutes before trying again.';
          break;
        case 'auth/operation-not-allowed':
          message = 'Password reset is currently disabled. Please contact support.';
          break;
        default:
          message = e.message ?? 'An error occurred while sending the reset email. Please try again.';
      }
      
      return {
        'success': false,
        'message': message,
        'error': e.code,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An unexpected error occurred. Please check your internet connection and try again.',
        'error': 'unknown',
      };
    }
  }

  /// Checks if an email address is associated with an existing user account
  /// This is useful for providing better UX feedback
  static Future<bool> emailExists(String email) async {
    try {
      // Try to send a password reset email - if user doesn't exist, it will throw an error
      await _auth.sendPasswordResetEmail(email: email.trim());
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return false;
      }
      // For other errors, assume email might exist to avoid revealing user information
      return true;
    } catch (e) {
      // If we can't check, assume the email might exist to avoid revealing user information
      return true;
    }
  }

  /// Validates email format
  static bool isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email.trim());
  }

  /// Gets user-friendly error messages for common scenarios
  static String getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'No account found with this email address.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'too-many-requests':
        return 'Too many requests. Please try again in a few minutes.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      default:
        return 'An error occurred. Please try again.';
    }
  }

  /// Logs password reset attempts for analytics/debugging
  static void logPasswordResetAttempt({
    required String email,
    required bool success,
    String? errorCode,
  }) {
    // In a production app, you might want to log this to your analytics service
    print('Password reset attempt: email=$email, success=$success, error=$errorCode');
  }
}
