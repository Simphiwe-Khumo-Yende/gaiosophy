# Private Key Format Issue - Fix Required

## Current Issue
```
Error: error:1E08010C:DECODER routines::unsupported
```

This error indicates the private key format is not being parsed correctly by the Apple Actions.

## Solution: Re-add APPSTORE_PRIVATE_KEY with Correct Format

The private key should be exactly as follows (no extra spaces, proper line breaks):

### 1. Go to GitHub Secrets
Visit: https://github.com/Simphiwe-Khumo-Yende/gaiosophy/settings/secrets/actions

### 2. Edit the APPSTORE_PRIVATE_KEY secret
Click on `APPSTORE_PRIVATE_KEY` → "Update"

### 3. Replace with This Exact Value:
```
-----BEGIN PRIVATE KEY-----
MIGTAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBHkwdwIBAQQgN0jdjZSbJyq0miiY
oS7arrZ1ODeIfF0D7rAoNgi2lXugCgYIKoZIzj0DAQehRANCAAT2uRXX9ouABq69
iuzFBnhfPstjVuyXQlOsJHbw5fxjswe6zGrFeoWh711jp3aBNHvOEjHasR32TBiz
wKvPkQNg
-----END PRIVATE KEY-----
```

**Important:** 
- Make sure there are NO extra spaces before/after
- Make sure line breaks are exactly as shown
- Include the BEGIN and END lines exactly

### 4. Alternative: Try Without Line Breaks
If the above doesn't work, try this single-line version:
```
-----BEGIN PRIVATE KEY-----MIGTAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBHkwdwIBAQQgN0jdjZSbJyq0miiYoS7arrZ1ODeIfF0D7rAoNgi2lXugCgYIKoZIzj0DAQehRANCAAT2uRXX9ouABq69iuzFBnhfPstjVuyXQlOsJHbw5fxjswe6zGrFeoWh711jp3aBNHvOEjHasR32TBizwKvPkQNg-----END PRIVATE KEY-----
```

## Expected Result After Fix
Once the private key format is corrected:
- ✅ Provisioning profile download will succeed
- ✅ iOS build will complete
- ✅ Build summary will show success

## Test the Fix
After updating the secret:
1. Go to GitHub Actions
2. Re-run the failed workflow
3. Should proceed past the provisioning profile step

We're very close to success! 🚀
