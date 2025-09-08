import 'package:flutter_test/flutter_test.dart';
import 'package:gaiosophy_app/data/services/email_service.dart';

void main() {
  group('Email Service Tests', () {
    test('should send welcome email successfully', () async {
      final result = await EmailService.sendWelcomeEmail(
        userEmail: 'test@example.com',
        userName: 'Test User',
      );
      
      expect(result, isTrue);
    });

    test('should handle different user names', () async {
      final result = await EmailService.sendWelcomeEmail(
        userEmail: 'jane.doe@example.com',
        userName: 'Jane Doe',
      );
      
      expect(result, isTrue);
    });

    test('should handle user names with special characters', () async {
      final result = await EmailService.sendWelcomeEmail(
        userEmail: 'maría@example.com',
        userName: 'María García',
      );
      
      expect(result, isTrue);
    });
  });
}
