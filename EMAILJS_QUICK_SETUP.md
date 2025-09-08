# EmailJS Setup Guide - Get Emails Working in 5 Minutes!

## Step 1: Create EmailJS Account
1. Go to [EmailJS.com](https://www.emailjs.com/)
2. Sign up for a free account
3. Create a new service (choose Gmail/Outlook/etc.)

## Step 2: Get Your Credentials
After setup, you'll get:
- **Service ID** (e.g., `service_abc123`)
- **Template ID** (e.g., `template_xyz789`) 
- **Public Key** (e.g., `user_def456`)

## Step 3: Create Email Template
In EmailJS dashboard:
1. Go to Email Templates
2. Create new template
3. Use these template variables:
   - `{{to_name}}` - User's name
   - `{{to_email}}` - User's email
   - `{{from_name}}` - Your app name
   - `{{subject}}` - Email subject
   - `{{html_content}}` - HTML email content

## Step 4: Update Flutter Code

Add to `pubspec.yaml`:
```yaml
dependencies:
  http: ^1.1.0
```

Then update your email service:

```dart
class EmailServiceEmailJS {
  // Replace these with your actual EmailJS credentials
  static const String _serviceId = 'service_YOUR_ID';
  static const String _templateId = 'template_YOUR_ID';  
  static const String _publicKey = 'user_YOUR_KEY';
  
  // ... rest of the implementation
}
```

## Step 5: Test It!
1. Update the credentials in the code
2. Run your app
3. Try registering a new user
4. Check your email inbox!

## Free Limits
- 200 emails/month free
- Perfect for testing and small apps
- Upgrade for higher limits

## Pros & Cons
✅ **Pros:**
- Works immediately
- No server setup needed
- Free tier available
- Easy to implement

❌ **Cons:**
- Client-side sending (less secure)
- Limited customization
- Dependent on third-party service

## Need Help?
If you get stuck, check the EmailJS documentation or let me know what error you're seeing!
