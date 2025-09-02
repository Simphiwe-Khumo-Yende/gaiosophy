# TestFlight Build Instructions for Gaiosophy App

## Prerequisites
- macOS machine with Xcode installed
- Apple Developer Account (already set up)
- Bundle ID `com.gaiosophy.app` created in App Store Connect

## Steps to Build for TestFlight

### 1. Transfer Project to macOS
Transfer your entire project folder to a macOS machine.

### 2. Setup on macOS
```bash
# Install Flutter dependencies
flutter pub get

# Check Flutter doctor
flutter doctor -v

# Ensure iOS toolchain is properly set up
```

### 3. iOS Configuration
The bundle identifier has already been updated to `com.gaiosophy.app` in:
- `ios/Runner.xcodeproj/project.pbxproj`
- Version updated to `1.0.0+1` in `pubspec.yaml`

### 4. Open in Xcode
```bash
open ios/Runner.xcworkspace
```

### 5. Configure Signing & Capabilities in Xcode
1. Select the "Runner" project in the navigator
2. Select "Runner" target
3. Go to "Signing & Capabilities" tab
4. Set Team to your Apple Developer Account
5. Ensure Bundle Identifier is `com.gaiosophy.app`
6. Add capabilities if needed:
   - Push Notifications
   - Sign in with Apple
   - App Groups (if using)

### 6. Build Archive
```bash
# Create release build
flutter build ios --release

# Or build directly from Xcode:
# Product > Archive (⌘+B then ⌘+Shift+B)
```

### 7. Upload to App Store Connect
1. In Xcode Organizer (Window > Organizer)
2. Select your app archive
3. Click "Distribute App"
4. Choose "App Store Connect"
5. Follow the upload wizard

### 8. Configure TestFlight
1. Go to App Store Connect
2. Navigate to your app
3. Go to TestFlight tab
4. Add the uploaded build
5. Fill in "What to Test" information
6. Add beta testers or create test groups

## Important Notes

### Firebase Configuration
- iOS Firebase configuration is already set up in `ios/Runner/GoogleService-Info.plist`
- Make sure Firebase project supports the new bundle ID

### Version Management
- Current version: 1.0.0+1
- For subsequent builds, increment the build number: `1.0.0+2`, `1.0.0+3`, etc.

### Testing Checklist
Before uploading to TestFlight, test:
- [ ] App launches successfully
- [ ] Firebase authentication works
- [ ] Firestore data loads correctly
- [ ] Audio playback functions
- [ ] All screens display properly with correct fonts
- [ ] Navigation works between screens

### Build Commands for Different Environments
```bash
# Debug build for testing
flutter build ios --debug

# Release build for TestFlight
flutter build ios --release

# Profile build for performance testing
flutter build ios --profile
```

## Troubleshooting

### Common Issues
1. **Provisioning Profile Issues**: Ensure your Apple Developer account has proper certificates
2. **Bundle ID Mismatch**: Verify bundle ID matches in both Xcode and App Store Connect
3. **Firebase Issues**: Ensure GoogleService-Info.plist is properly configured for the new bundle ID

### Firebase Bundle ID Update
If you encounter Firebase issues with the new bundle ID:
1. Go to Firebase Console
2. Project Settings > Your apps
3. Add iOS app with bundle ID `com.gaiosophy.app`
4. Download new `GoogleService-Info.plist`
5. Replace the existing file in `ios/Runner/`

## Next Steps After Upload
1. Monitor build processing in App Store Connect
2. Add test groups and beta testers
3. Submit for beta review if using external testing
4. Distribute to testers once approved
