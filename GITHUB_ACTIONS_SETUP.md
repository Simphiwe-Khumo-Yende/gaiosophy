# GitHub Actions Setup for iOS TestFlight Deployment

## Overview
This guide will help you set up automated iOS builds and TestFlight deployment using GitHub Actions. Once configured, you can deploy to TestFlight directly from Windows by pushing code to GitHub!

## Prerequisites
- Apple Developer Account
- App Store Connect access
- Bundle ID `com.gaiosophy.app` already created

## Step 1: Fix Git Authentication

Your current push failed due to authentication. Choose one option:

### Option A: Update Git Token
```bash
# Update the remote URL with a new token
git remote set-url origin https://Simphiwe-Khumo-Yende:NEW_TOKEN@github.com/Simphiwe-Khumo-Yende/gaiosophy.git
```

### Option B: Use SSH (Recommended)
```bash
# Change to SSH
git remote set-url origin git@github.com:Simphiwe-Khumo-Yende/gaiosophy.git
```

### Option C: Use GitHub CLI
```bash
# Install GitHub CLI and authenticate
gh auth login
```

## Step 2: Create App Store Connect API Key

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Navigate to Users and Access → Integrations → App Store Connect API
3. Click "Generate API Key"
4. Set role to "Developer" or "App Manager"
5. Download the .p8 file
6. Note the Key ID and Issuer ID

## Step 3: Export Certificates from Xcode (Requires Mac)

You'll need these certificates from a Mac with Xcode:

### Distribution Certificate
1. Open Keychain Access on Mac
2. Find "Apple Distribution: Your Name (Team ID)"
3. Right-click → Export → .p12 format
4. Set a password

### Provisioning Profile
Will be automatically downloaded by GitHub Actions using App Store Connect API.

## Step 4: Add GitHub Secrets

Go to your GitHub repository → Settings → Secrets and variables → Actions

Add these secrets:

| Secret Name | Description | Example |
|-------------|-------------|---------|
| `APPSTORE_ISSUER_ID` | From App Store Connect API | `69a6de8d-xxxx-xxxx-xxxx-xxxxxxxxxxxx` |
| `APPSTORE_KEY_ID` | From App Store Connect API | `2X9R4HXF34` |
| `APPSTORE_PRIVATE_KEY` | Content of .p8 file | `-----BEGIN PRIVATE KEY-----\n...` |
| `IOS_DISTRIBUTION_CERTIFICATE` | Base64 of .p12 file | (Base64 encoded content) |
| `IOS_CERTIFICATE_PASSWORD` | Password for .p12 file | `your_password_here` |

### Convert .p12 to Base64
On Mac:
```bash
base64 -i YourCertificate.p12 | pbcopy
```

On Windows:
```powershell
[Convert]::ToBase64String([IO.File]::ReadAllBytes("YourCertificate.p12"))
```

## Step 5: Update ExportOptions.plist

Update the `ios/ExportOptions.plist` file with your Team ID:
```xml
<key>teamID</key>
<string>YOUR_ACTUAL_TEAM_ID</string>
```

Find your Team ID in:
- App Store Connect → Membership details
- Or Apple Developer Portal → Membership

## Step 6: Test the Workflow

### Option A: Push to GitHub
```bash
git add .
git commit -m "Add GitHub Actions iOS deployment"
git push origin main
```

### Option B: Manual Trigger
1. Go to GitHub repository → Actions tab
2. Select "Build and Deploy to TestFlight"
3. Click "Run workflow"

## Workflow Features

✅ **Automatic Triggers**: Builds on every push to main  
✅ **Manual Triggers**: Run workflows on-demand  
✅ **Testing**: Runs Flutter tests before building  
✅ **Code Signing**: Automatic certificate and profile management  
✅ **TestFlight Upload**: Direct upload to TestFlight  
✅ **Artifacts**: Downloads IPA files for manual distribution  

## Troubleshooting

### Common Issues:

**Certificate Issues**:
- Ensure certificate is valid and not expired
- Check Team ID matches in ExportOptions.plist
- Verify certificate password is correct

**Provisioning Profile Issues**:
- Bundle ID must match exactly: `com.gaiosophy.app`
- Profile must be App Store distribution type
- App Store Connect API key needs proper permissions

**Build Issues**:
- Check Flutter version compatibility
- Ensure all dependencies are compatible with iOS
- Verify Firebase configuration is correct

### Viewing Logs:
1. Go to GitHub repository → Actions tab
2. Click on failed workflow run
3. Expand job steps to see detailed logs

## Alternative: Quick Setup

If you have a Mac available temporarily:
1. Open the project in Xcode
2. Archive and upload to TestFlight manually
3. Use GitHub Actions for future automated deployments

## Success!

Once set up, your deployment process will be:
1. Make code changes on Windows
2. Commit and push to GitHub
3. GitHub Actions automatically builds and uploads to TestFlight
4. Beta testers receive notification

No Mac required for ongoing deployments! 🎉
