# GitHub Secrets Configuration for Gaiosophy iOS Deployment

## Your App Store Connect API Details ✅
- **Issuer ID**: `7794a476-5614-4b73-9c89-b6b46ff33a4`
- **Key ID**: `Y7639KMBXG`
- **Private Key**: Ready to add to secrets

## Required GitHub Secrets Setup

Go to your GitHub repository: https://github.com/Simphiwe-Khumo-Yende/gaiosophy

Navigate to: **Settings** → **Secrets and variables** → **Actions** → **New repository secret**

### 1. APPSTORE_ISSUER_ID
- **Name**: `APPSTORE_ISSUER_ID`
- **Value**: `7794a476-5614-4b73-9c89-b6b46ff33a4`

### 2. APPSTORE_KEY_ID
- **Name**: `APPSTORE_KEY_ID`
- **Value**: `Y7639KMBXG`

### 3. APPSTORE_PRIVATE_KEY
- **Name**: `APPSTORE_PRIVATE_KEY`
- **Value**: 
```
-----BEGIN PRIVATE KEY-----
MIGTAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBHkwdwIBAQQgN0jdjZSbJyq0miiY
oS7arrZ1ODeIfF0D7rAoNgi2lXugCgYIKoZIzj0DAQehRANCAAT2uRXX9ouABq69
iuzFBnhfPstjVuyXQlOsJHbw5fxjswe6zGrFeoWh711jp3aBNHvOEjHasR32TBiz
wKvPkQNg
-----END PRIVATE KEY-----
```

## Still Needed (Requires Mac/Xcode)

### 4. IOS_DISTRIBUTION_CERTIFICATE
You need to export your iOS Distribution Certificate from Xcode:
1. Open Keychain Access on a Mac
2. Find "Apple Distribution: [Your Name] ([Team ID])"
3. Right-click → Export → Save as .p12 file
4. Convert to Base64:
   ```bash
   base64 -i YourCertificate.p12 | pbcopy
   ```
5. Add as secret: `IOS_DISTRIBUTION_CERTIFICATE`

### 5. IOS_CERTIFICATE_PASSWORD
- **Name**: `IOS_CERTIFICATE_PASSWORD`
- **Value**: [Password you set when exporting the .p12 file]

### 6. Update Team ID
Find your Apple Developer Team ID:
- Go to https://developer.apple.com/account/
- Look for "Team ID" in membership details
- Update `ios/ExportOptions.plist` with your actual Team ID

## Alternative: Manual First Build

If you want to test immediately without setting up certificates:

1. **Modify the workflow** to build but not upload
2. **Download the IPA** from GitHub Actions artifacts
3. **Upload manually** to App Store Connect

## Testing the Workflow

Once you've added the App Store Connect API secrets (steps 1-3), you can:

### Option 1: Manual Trigger
1. Go to https://github.com/Simphiwe-Khumo-Yende/gaiosophy/actions
2. Click "Build and Deploy to TestFlight"
3. Click "Run workflow" → "Run workflow"

### Option 2: Push Code
```bash
git add .
git commit -m "Update secrets configuration"
git push origin main
```

## Expected Results

With just the App Store Connect API secrets (steps 1-3):
- ✅ Workflow will run
- ✅ Flutter dependencies will install
- ✅ Tests will run
- ❌ Code signing will fail (missing certificate)
- ✅ You'll see detailed logs to debug

With all secrets (steps 1-6):
- ✅ Complete build process
- ✅ Code signing
- ✅ Upload to TestFlight
- 🎉 Beta testing ready!

## Quick Start (Recommended)

1. **Add the 3 App Store Connect secrets now** (steps 1-3)
2. **Trigger the workflow** to test the build process
3. **Get certificate later** when you have Mac access
4. **Complete automation** once all secrets are added

This way you can validate most of the process immediately!
