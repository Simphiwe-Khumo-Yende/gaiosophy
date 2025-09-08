# How to Switch to Real Email Sending

## Current Status
Your app is currently using a **mock email service** that only prints to console. Here's how to switch to actual email sending:

## Quick Fix - Use EmailJS (Recommended for Testing)

### 1. Set up EmailJS account (5 minutes)
- Go to [EmailJS.com](https://www.emailjs.com/) and create account
- Add an email service (Gmail/Outlook/etc.)
- Create a template and get your credentials

### 2. Replace the email service
Update `lib/presentation/screens/register_screen.dart`:

```dart
// Replace this line:
import '../../data/services/email_service.dart';

// With this:
import '../../data/services/email_service_emailjs.dart';

// Then replace the email calls:
// OLD:
EmailService.sendWelcomeEmail(
  userEmail: email,
  userName: displayName ?? 'Plant Enthusiast',
)

// NEW:
EmailServiceEmailJS.sendWelcomeEmail(
  userEmail: email,
  userName: displayName ?? 'Plant Enthusiast',
)
```

### 3. Update EmailJS credentials
In `lib/data/services/email_service_emailjs.dart`, replace:
```dart
static const String _serviceId = 'YOUR_SERVICE_ID';
static const String _templateId = 'YOUR_TEMPLATE_ID';  
static const String _publicKey = 'YOUR_PUBLIC_KEY';
```

### 4. Install dependencies
```bash
flutter pub get
```

### 5. Test it!
Register a new user and check your email.

## Alternative Options

### Option A: Firebase Functions (Production Ready)
- Most secure and scalable
- Requires Firebase Functions setup
- See `FIREBASE_EMAIL_SETUP.md` for details

### Option B: Third-party Services
- SendGrid, Mailgun, AWS SES
- More complex setup but very reliable
- Better for high-volume applications

## Troubleshooting

### "Email sent successfully" but no email received?
- Check spam/junk folder
- Verify email address is correct
- Check EmailJS dashboard for send logs
- Make sure template variables are mapped correctly

### EmailJS not working?
- Verify service is connected and active
- Check template ID matches exactly
- Ensure public key is correct
- Look for CORS errors in browser console

### Need help?
The current mock service shows exactly what data would be sent:
- User email: `siphiweyende371@gmail.com`
- Template length: `11706 characters`
- This confirms the service is being called correctly

## Next Steps
1. Choose EmailJS for quick testing
2. Set up Firebase Functions for production
3. Test thoroughly with different email providers
4. Add error handling and retry logic
