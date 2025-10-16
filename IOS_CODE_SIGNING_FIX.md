# iOS Code Signing Fix for GitHub Actions

## Problem
The GitHub Actions workflow was failing with the error:
```
No valid code signing certificates were found
No development certificates available to code sign app for device deployment
```

## Root Cause
The `flutter build ipa` command was not properly utilizing the manually configured certificates and provisioning profiles in the CI environment. Flutter's IPA build process needs explicit control over the code signing process when using manual signing in CI/CD.

## Solution Applied

### Changes Made to `.github/workflows/ios-deploy.yml`

#### 1. **Split Build Process into Two Steps**
   - **Before**: Single `flutter build ipa` command
   - **After**: Two-step process:
     1. `flutter build ios --no-codesign` - Builds the Flutter framework without signing
     2. `xcodebuild` commands - Handles archiving and signing explicitly

#### 2. **Build iOS Archive Step**
   ```yaml
   - name: Build iOS Archive
     run: |
       CERT_IDENTITY=$(security find-identity -v -p codesigning build.keychain | grep "Apple Distribution" | head -1 | grep -o '".*"' | sed 's/"//g')
       flutter build ios --release \
         --build-name=${{ steps.get_version.outputs.version_name }} \
         --build-number=${{ steps.get_version.outputs.build_number }} \
         --no-codesign
   ```
   - Builds the iOS app without code signing
   - Prepares the framework for manual signing with xcodebuild

#### 3. **Build and Sign IPA with Xcode Step**
   ```yaml
   - name: Build and Sign IPA with Xcode
     run: |
       CERT_IDENTITY=$(security find-identity -v -p codesigning build.keychain | grep "Apple Distribution" | head -1 | grep -o '".*"' | sed 's/"//g')
       
       cd ios
       
       # Build archive with xcodebuild
       xcodebuild -workspace Runner.xcworkspace \
         -scheme Runner \
         -configuration Release \
         -archivePath ${{ github.workspace }}/build/Runner.xcarchive \
         -allowProvisioningUpdates \
         CODE_SIGN_IDENTITY="${CERT_IDENTITY}" \
         CODE_SIGN_STYLE=Manual \
         DEVELOPMENT_TEAM=${{ secrets.APPLE_TEAM_ID }} \
         PROVISIONING_PROFILE_SPECIFIER="${PROFILE_UUID}" \
         archive
       
       # Export IPA
       xcodebuild -exportArchive \
         -archivePath ${{ github.workspace }}/build/Runner.xcarchive \
         -exportPath ${{ github.workspace }}/build/ios/ipa \
         -exportOptionsPlist ExportOptions.plist \
         -allowProvisioningUpdates
   ```

#### 4. **Fixed ExportOptions.plist**
   - **Before**: Used profile name `gaiosophy`
   - **After**: Uses actual profile UUID `${PROFILE_UUID}`
   ```xml
   <key>provisioningProfiles</key>
   <dict>
       <key>com.gaiosophy.app</key>
       <string>${PROFILE_UUID}</string>
   </dict>
   ```

## Why This Works

1. **Explicit Certificate Selection**: Extracts the exact certificate identity from the keychain and passes it to xcodebuild
2. **Manual Signing Control**: Uses `CODE_SIGN_STYLE=Manual` with explicit parameters
3. **Correct Profile Reference**: Uses UUID instead of profile name for accurate matching
4. **Two-Phase Build**: Separates Flutter compilation from iOS code signing, giving full control over each step

## Key Parameters

| Parameter | Purpose |
|-----------|---------|
| `CODE_SIGN_IDENTITY` | Specifies exact certificate to use for signing |
| `CODE_SIGN_STYLE=Manual` | Forces manual signing (not automatic) |
| `DEVELOPMENT_TEAM` | Your Apple Team ID (Z9WJ3V7JV3) |
| `PROVISIONING_PROFILE_SPECIFIER` | UUID of the provisioning profile |
| `-allowProvisioningUpdates` | Allows Xcode to manage provisioning if needed |

## Testing the Fix

After pushing these changes:

1. The workflow will run automatically on push to `main`
2. Or trigger manually via GitHub Actions UI (workflow_dispatch)
3. Monitor the "Build and Sign IPA with Xcode" step for success
4. Check that the certificate identity is correctly detected
5. Verify the archive is created at `build/Runner.xcarchive`
6. Confirm IPA export completes successfully

## Verification Checklist

- [ ] GitHub secrets are all configured (see screenshot - all ✅)
- [ ] Workflow file updated with new build steps
- [ ] Certificate expires in the future (check Apple Developer portal)
- [ ] Provisioning profile is valid and matches bundle ID `com.gaiosophy.app`
- [ ] Team ID in secrets matches the one in provisioning profile

## Next Steps

1. **Commit and push the workflow changes**
2. **Monitor the GitHub Actions run**
3. **Check logs for certificate detection**
4. **If successful, app will upload to TestFlight automatically**

## Troubleshooting

If the build still fails:

### Check Certificate Identity
```bash
security find-identity -v -p codesigning build.keychain
```
Should show "Apple Distribution" certificate

### Check Provisioning Profile UUID
```bash
security cms -D -i ~/Library/MobileDevice/Provisioning\ Profiles/gaiosophy.mobileprovision | plutil -extract UUID xml1 -o - - | xmllint --xpath "//string/text()" -
```

### Verify Bundle ID Match
Ensure `com.gaiosophy.app` in:
- `ios/Runner.xcodeproj/project.pbxproj`
- App Store Connect
- Provisioning Profile

### Certificate Expiration
Check Apple Developer Portal to ensure certificates haven't expired.

## References

- [Apple Code Signing Guide](https://developer.apple.com/support/code-signing/)
- [xcodebuild Manual](https://developer.apple.com/library/archive/technotes/tn2339/_index.html)
- [GitHub Actions for iOS](https://docs.github.com/en/actions/deployment/deploying-xcode-applications/installing-an-apple-certificate-on-macos-runners-for-xcode-development)
