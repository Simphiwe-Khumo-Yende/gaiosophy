# TestFlight Build Checklist ✅

## Pre-Build Setup (Completed ✅)
- [x] Bundle identifier updated to `com.gaiosophy.app` in iOS project
- [x] Version bumped to `1.0.0+1` in pubspec.yaml
- [x] Firebase GoogleService-Info.plist updated with correct bundle ID
- [x] All UI screens updated and tested
- [x] Content filtering by "Published" status implemented
- [x] Firestore indexes deployed

## Required for iOS Build (On macOS)
- [ ] Transfer project to macOS machine
- [ ] Install Xcode (latest version recommended)
- [ ] Run `flutter doctor` to ensure iOS toolchain is set up
- [ ] Open project in Xcode: `open ios/Runner.xcworkspace`

## Xcode Configuration
- [ ] Select correct Apple Developer Team
- [ ] Verify bundle identifier is `com.gaiosophy.app`
- [ ] Configure signing certificates
- [ ] Add required capabilities:
  - [ ] Push Notifications (if needed)
  - [ ] Sign in with Apple (if implemented)
  - [ ] App Groups (if needed)

## Firebase Configuration (Important!)
Since the bundle ID changed from `com.example.gaiosophyApp` to `com.gaiosophy.app`:

### Option 1: Add new iOS app to existing Firebase project
1. Go to Firebase Console → Project Settings
2. Add iOS app with bundle ID `com.gaiosophy.app`
3. Download new GoogleService-Info.plist
4. Replace the file in `ios/Runner/`

### Option 2: Update existing iOS app (if possible)
1. In Firebase Console, try to update the bundle ID
2. If not possible, use Option 1

## Build Process
1. Clean build: `flutter clean && flutter pub get`
2. Build for release: `flutter build ios --release`
3. Archive in Xcode: Product → Archive
4. Upload to App Store Connect

## App Store Connect Final Steps
- [ ] Complete app information (already started)
- [ ] Add app screenshots
- [ ] Write app description
- [ ] Set content ratings
- [ ] Configure TestFlight settings
- [ ] Add beta testers

## Testing Before Upload
- [ ] Test on physical iOS device
- [ ] Verify authentication works
- [ ] Check all screens load correctly
- [ ] Test audio playback
- [ ] Verify Firestore data loads
- [ ] Test navigation between screens

## Post-Upload
- [ ] Monitor build processing in App Store Connect
- [ ] Add test notes for beta testers
- [ ] Create test groups if needed
- [ ] Invite beta testers
- [ ] Submit for beta review (if using external testing)

## Scripts Available
- `build_testflight.sh` - Automated build script for macOS
- `increment_version.sh` - Version management for future builds
- `TESTFLIGHT_BUILD_GUIDE.md` - Detailed step-by-step guide

## Emergency Firebase Update
If you encounter Firebase authentication issues after changing bundle ID:
1. Create new iOS app in Firebase with `com.gaiosophy.app`
2. Replace GoogleService-Info.plist
3. Update any hardcoded bundle references in Firebase rules
4. Test authentication flow

## Version Management for Future Builds
For subsequent TestFlight builds:
- Increment build number: `./increment_version.sh build` (1.0.0+2, 1.0.0+3, etc.)
- For feature updates: `./increment_version.sh minor` (1.1.0+1)
- For major releases: `./increment_version.sh major` (2.0.0+1)

---
**Current Status:** Project is configured and ready for iOS build on macOS machine. All bundle identifiers updated and Firebase configuration prepared.
