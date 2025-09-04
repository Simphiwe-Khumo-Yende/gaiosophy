# App Store Connect API Authentication Issue

## Current Problem
```json
{
  "errors": [{
    "status": "401",
    "code": "NOT_AUTHORIZED", 
    "title": "Authentication credentials are missing or invalid.",
    "detail": "Provide a properly configured and signed bearer token..."
  }]
}
```

## Root Cause
The App Store Connect API key `Y7639KMBXG` either:
1. **Lacks sufficient permissions** for provisioning profiles
2. **Has expired** or been revoked
3. **Belongs to wrong team** for bundle ID `com.gaiosophy.app`

## Immediate Solution: Test iOS Build

I've created a simplified workflow that **skips provisioning profiles** to test the iOS build process:

### 1. Test the Build First
- Go to: https://github.com/Simphiwe-Khumo-Yende/gaiosophy/actions
- Click "Build iOS (No Provisioning Profile)"
- Click "Run workflow" → "Run workflow"

This will verify:
- ✅ Flutter builds your iOS app successfully
- ✅ All dependencies work
- ✅ Basic build pipeline is functional

## Fix App Store Connect API Key

### Option A: Regenerate API Key (Recommended)
1. Go to [App Store Connect API](https://appstoreconnect.apple.com/access/integrations/api)
2. **Revoke** the current key `Y7639KMBXG`
3. **Create new key** with these settings:
   - **Name**: `Gaiosophy iOS Deploy`
   - **Access**: **App Manager** (not Developer)
   - **Download** the new .p8 file
4. **Update GitHub secrets** with new:
   - `APPSTORE_KEY_ID` (new key ID)
   - `APPSTORE_PRIVATE_KEY` (new .p8 content)

### Option B: Check Current Key Permissions
1. Go to [App Store Connect API](https://appstoreconnect.apple.com/access/integrations/api)
2. Find key `Y7639KMBXG`
3. Ensure role is **App Manager** (not Developer)
4. Verify key is **Active** and not expired

## Alternative: Manual TestFlight Upload

If API issues persist, you can:
1. Use the test workflow to build the iOS app
2. Download the generated files
3. Manually upload to TestFlight via Xcode or Application Loader

## Expected Results

### After Test Workflow:
- ✅ iOS build success without certificates
- ✅ Proof that automation works
- ✅ Ready for certificate setup

### After API Fix:
- ✅ Provisioning profile download
- ✅ Complete automation to TestFlight
- ✅ Full CI/CD pipeline working

## Priority Actions:
1. **Run test workflow first** (immediate validation)
2. **Fix API key** (for full automation)
3. **Add certificates** (for TestFlight upload)

We're very close to success! 🚀
