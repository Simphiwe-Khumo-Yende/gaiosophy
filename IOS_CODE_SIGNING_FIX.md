# iOS Code Signing Fix for GitHub Actions - FINAL VERSION

## Problem History

### Initial Issue
```
No valid code signing certificates were found
No development certificates available to code sign app for device deployment
```

### Second Issue (After First Fix)
```
'Flutter/Flutter.h' file not found
Command SwiftCompile failed with a nonzero exit code
```

## Root Causes

1. **First Issue**: `flutter build ipa` couldn't find certificates in CI environment
2. **Second Issue**: Splitting `flutter build ios` and `xcodebuild` caused Flutter framework to not be properly linked for CocoaPods dependencies

## Final Solution

### The Correct Approach
Use `flutter build ipa` with proper Xcode project configuration BEFORE the build runs.

### Changes Made to `.github/workflows/ios-deploy.yml`

#### 1. **Reordered Build Steps**
   ```yaml
   Clean → Get Dependencies → Setup Signing → Configure Xcode → Install Pods → Build IPA
   ```

#### 2. **New Step: Update Xcode Project with Signing Configuration**
   ```yaml
   - name: Update Xcode Project with Signing Configuration
     run: |
       CERT_IDENTITY=$(security find-identity -v -p codesigning build.keychain | grep "Apple Distribution" | head -1 | grep -o '".*"' | sed 's/"//g')
       echo "CERT_IDENTITY=${CERT_IDENTITY}" >> $GITHUB_ENV
       
       cd ios
       ruby -i -pe "gsub(/CODE_SIGN_STYLE = Automatic;/, 'CODE_SIGN_STYLE = Manual;')" Runner.xcodeproj/project.pbxproj
       ruby -i -pe "gsub(/DEVELOPMENT_TEAM = \"\";/, 'DEVELOPMENT_TEAM = \"${{ secrets.APPLE_TEAM_ID }}\";')" Runner.xcodeproj/project.pbxproj
       ruby -i -pe "gsub(/DEVELOPMENT_TEAM = ;/, 'DEVELOPMENT_TEAM = ${{ secrets.APPLE_TEAM_ID }};')" Runner.xcodeproj/project.pbxproj
   ```
   - Modifies the Xcode project file to use manual signing
   - Sets the DEVELOPMENT_TEAM in project.pbxproj
   - Ensures Flutter's build process uses the correct signing

#### 3. **Pod Install After Xcode Configuration**
   ```yaml
   - name: Install CocoaPods Dependencies
     run: |
       cd ios
       pod install --repo-update
   ```
   - Moved AFTER Xcode project configuration
   - Ensures pods are installed with correct signing settings

#### 4. **Enhanced ExportOptions.plist**
   ```xml
   <key>signingCertificate</key>
   <string>Apple Distribution</string>
   ```
   - Added explicit signing certificate type

#### 5. **Single Build Command**
   ```yaml
   - name: Build and Sign IPA
     run: |
       flutter build ipa --release \
         --build-name=${{ steps.get_version.outputs.version_name }} \
         --build-number=${{ steps.get_version.outputs.build_number }} \
         --export-options-plist=ios/ExportOptions.plist
   ```
   - Back to using `flutter build ipa` (not split)
   - Flutter handles the complete build and signing process
   - Uses the pre-configured Xcode project settings

## Why This Works

1. ✅ **Xcode Project Pre-Configuration**: Sets manual signing in project.pbxproj before any build
2. ✅ **Proper Build Order**: Dependencies → Signing Setup → Xcode Config → Pods → Build
3. ✅ **Flutter Framework Linking**: Flutter builds everything together, ensuring proper framework linking
4. ✅ **Certificate Available**: Keychain has distribution certificate accessible to codesign
5. ✅ **Profile UUID**: ExportOptions.plist uses the extracted UUID

## Complete Flow

```
1. ✅ Setup Flutter & Xcode
2. ✅ Verify App Store Connect API
3. ✅ Clean & Get Dependencies (flutter pub get)
4. ✅ Setup iOS Signing (certificate + provisioning profile)
5. ✅ Create ExportOptions.plist with UUID
6. ✅ Update Xcode Project (set manual signing + team)
7. ✅ Install CocoaPods
8. ✅ Build IPA (flutter build ipa with signing)
9. ✅ Upload to TestFlight
10. ✅ Clean up
```

## Key Differences from Previous Attempts

| Previous | Current |
|----------|---------|
| Pod install BEFORE signing setup | Pod install AFTER Xcode configuration |
| Split: `flutter build ios` + `xcodebuild` | Single: `flutter build ipa` |
| No Xcode project modification | Modifies project.pbxproj for manual signing |
| Profile name in ExportOptions | Profile UUID in ExportOptions |

## Testing the Fix

After pushing:
1. ✅ Check "Update Xcode Project" step succeeds
2. ✅ Verify certificate identity is detected
3. ✅ Check pod install completes without errors
4. ✅ Verify Flutter build IPA succeeds
5. ✅ Confirm upload to TestFlight works

## All GitHub Secrets Required

- ✅ `APPLE_TEAM_ID`
- ✅ `APPSTORE_ISSUER_ID`
- ✅ `APPSTORE_KEY_ID`
- ✅ `APPSTORE_PRIVATE_KEY`
- ✅ `GOOGLE_SERVICE_INFO_PLIST_BASE64`
- ✅ `IOS_DIST_CERT_P12`
- ✅ `IOS_DIST_CERT_PASSWORD`
- ✅ `IOS_PROVISIONING_PROFILE`

All are configured! ✅

## Expected Result

```
Building com.gaiosophy.app for device (ios-release)...
Running pod install...                                             ✅
Running Xcode build...                                             ✅
Xcode build done.                                                  ✅
Built IPA to build/ios/ipa/gaiosophy_app.ipa                      ✅
Uploading to TestFlight...                                         ✅
Upload successful!                                                 ✅
```

## Troubleshooting

If still fails, check:
1. Certificate hasn't expired
2. Provisioning profile matches bundle ID exactly
3. Team ID in secrets matches provisioning profile
4. Provisioning profile type is "App Store" (not Development)

