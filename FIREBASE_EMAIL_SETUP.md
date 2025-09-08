# Firebase Functions Email Service Setup

## Overview
This guide shows how to set up a Firebase Cloud Function to send emails using Nodemailer, which is the recommended approach for production Flutter apps.

## Prerequisites
- Firebase project set up
- Firebase CLI installed
- Node.js installed

## Setup Steps

### 1. Initialize Firebase Functions
```bash
# In your project root
firebase init functions
```

### 2. Install Dependencies
```bash
# Navigate to functions directory
cd functions

# Install required packages
npm install nodemailer
npm install @types/nodemailer --save-dev
```

### 3. Create Email Function

Create `functions/src/email.ts`:

```typescript
import * as functions from 'firebase-functions';
import * as nodemailer from 'nodemailer';

// Configure your email service
const transporter = nodemailer.createTransporter({
  service: 'gmail', // or your email provider
  auth: {
    user: functions.config().email.user, // Set via Firebase config
    pass: functions.config().email.password, // App password for Gmail
  },
});

export const sendWelcomeEmail = functions.https.onCall(async (data, context) => {
  // Verify user is authenticated
  if (!context.auth) {
    throw new functions.https.HttpsError(
      'unauthenticated',
      'User must be authenticated to send emails.'
    );
  }

  const { userEmail, userName } = data;

  if (!userEmail || !userName) {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'Missing required fields: userEmail, userName'
    );
  }

  const mailOptions = {
    from: '"Gaiosophy Team" <your-email@gmail.com>',
    to: userEmail,
    subject: 'Welcome to Gaiosophy - Your Plant Wisdom Journey Begins! 🌿',
    html: generateWelcomeEmailTemplate(userName),
  };

  try {
    await transporter.sendMail(mailOptions);
    console.log('Welcome email sent to:', userEmail);
    return { success: true, message: 'Email sent successfully' };
  } catch (error) {
    console.error('Error sending email:', error);
    throw new functions.https.HttpsError(
      'internal',
      'Failed to send email'
    );
  }
});

function generateWelcomeEmailTemplate(userName: string): string {
  return `
    <!DOCTYPE html>
    <html lang="en">
    <!-- Same HTML template as in the EmailJS version -->
    </html>
  `;
}
```

### 4. Set Firebase Config
```bash
# Set email configuration
firebase functions:config:set email.user="your-email@gmail.com"
firebase functions:config:set email.password="your-app-password"
```

### 5. Deploy Function
```bash
firebase deploy --only functions
```

### 6. Update Flutter Code

```dart
import 'package:cloud_functions/cloud_functions.dart';

class EmailServiceFirebase {
  static Future<bool> sendWelcomeEmail({
    required String userEmail,
    required String userName,
  }) async {
    try {
      final callable = FirebaseFunctions.instance.httpsCallable('sendWelcomeEmail');
      
      final result = await callable.call({
        'userEmail': userEmail,
        'userName': userName,
      });

      if (result.data['success'] == true) {
        print('✅ Welcome email sent successfully to $userEmail');
        return true;
      } else {
        print('❌ Failed to send email: ${result.data['message']}');
        return false;
      }
    } catch (e) {
      print('❌ Error sending welcome email: $e');
      return false;
    }
  }
}
```

## Gmail Setup for Nodemailer
1. Enable 2-factor authentication on your Gmail account
2. Generate an App Password:
   - Go to Google Account settings
   - Security → 2-Step Verification → App passwords
   - Generate password for "Mail"
   - Use this password in Firebase config

## Security Notes
- Never commit email credentials to source control
- Use Firebase config or environment variables
- Consider using OAuth2 for production Gmail integration
- Implement rate limiting to prevent abuse
