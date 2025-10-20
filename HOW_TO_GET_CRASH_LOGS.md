# How to Get Crash Logs for Gaiosophy iOS App

## 🎯 Quick Guide - Choose Your Method

### Method 1: App Store Connect (Easiest - No Mac Required)
**Best for:** Getting detailed crash reports after they happen

1. Go to https://appstoreconnect.apple.com/
2. Sign in with your Apple Developer account
3. Click **"My Apps"**
4. Select **"Gaiosophy"**
5. Click **"TestFlight"** in left sidebar
6. Click on **Build 5** (current build)
7. Scroll to **"Crashes"** section
8. Click **"View All"** to see all crashes
9. Click on a specific crash to see:
   - Stack trace
   - Device info
   - iOS version
   - Crash count
   - When it occurred

**Screenshot locations:**
- Crashes grouped by type
- Symbolicated (human-readable) crash logs
- Can download crash log as text file

---

### Method 2: Console App (Mac Required - BEST FOR DEBUGGING)
**Best for:** Real-time debugging while app runs

**Requirements:**
- Mac computer
- iPhone connected via USB
- Console app (built into macOS)

**Steps:**
1. Connect iPhone to Mac with USB cable
2. Trust computer on iPhone if prompted
3. Open **Console** app on Mac
   - Location: `/Applications/Utilities/Console.app`
   - Or: Spotlight search "Console"
4. In Console app:
   - Select your **iPhone** in left sidebar (under "Devices")
   - Click **Start** button (top right)
   - In filter box (top right), type: `Runner`
5. On iPhone:
   - Open **Gaiosophy** app
   - Watch Console app on Mac
6. You'll see real-time logs:
   ```
   ✅ Firebase initialized successfully
   ✅ Hive initialized successfully
   ❌ Router redirect error: [actual error]
   ```

**To save logs:**
- Right-click in Console → Save Selection
- Or: Edit → Copy (⌘C) → Paste into text file

---

### Method 3: Xcode Organizer (Mac Required)
**Best for:** Viewing symbolicated crash logs with code references

**Steps:**
1. Open **Xcode** on Mac
2. Window → Organizer (or press `⌘⇧2`)
3. Click **"Crashes"** tab at top
4. Select **"Gaiosophy"** in left sidebar
5. You'll see:
   - All crashes grouped by type
   - Crash frequency
   - iOS versions affected
   - Device models
6. Click on a crash to see:
   - Full stack trace
   - Exact file and line number
   - Thread information

**Note:** Crashes appear here after users share them via TestFlight

---

### Method 4: iPhone Analytics Logs
**Best for:** When you have the crashing device physically

**Steps:**
1. On iPhone: **Settings** → **Privacy & Security**
2. Scroll down to **Analytics & Improvements**
3. Tap **"Analytics Data"**
4. Scroll to find **"Gaiosophy-"** entries
   - Format: `Gaiosophy-2025-10-20-123456.ips`
5. Tap on a crash log
6. Tap **Share** button (top right)
7. Send to yourself via AirDrop, Email, etc.

**Note:** These logs are unsymbolicated (harder to read)

---

### Method 5: TestFlight App (Basic Info Only)
**Best for:** Quick check if crashes are happening

**Steps:**
1. Open **TestFlight** app on iPhone
2. Tap **"Gaiosophy"**
3. Scroll to **"Previous Builds"** or current build
4. Look for **"Crashes"** indicator
5. If prompted, tap **"Send to Developer"**

**Limitation:** Doesn't show detailed crash info

---

## 🔍 What to Look For in Crash Logs

### Critical Information:

1. **Exception Type**
   ```
   Exception Type: EXC_BAD_ACCESS (SIGSEGV)  ← Memory error
   Exception Type: EXC_CRASH (SIGABRT)       ← Fatal error
   Exception Type: EXC_BREAKPOINT (SIGTRAP)  ← Assertion failure
   ```

2. **Application Specific Information**
   ```
   Application Specific Information:
   *** Terminating app due to uncaught exception 'FlutterError'
   reason: 'Firebase already initialized'
   ```

3. **Crashed Thread Stack Trace**
   ```
   Thread 0 Crashed:
   0   Runner                0x0000000102abc123 Runner + 123456
   1   Flutter               0x0000000103def456 Flutter + 789012
   ```

4. **Look for our code:**
   - Lines containing "Runner" (your app)
   - Lines containing "Firebase", "Firestore", "Hive"
   - Any Dart/Flutter framework lines

---

## 📋 Crash Log Template to Share

If you get a crash log, share this information:

```
1. Exception Type: [EXC_BAD_ACCESS, EXC_CRASH, etc.]

2. Exception Subtype: [KERN_INVALID_ADDRESS, etc.]

3. Crashed Thread: [Thread 0, Thread 1, etc.]

4. Application Specific Information:
[Any error messages here]

5. Stack Trace (first 20 lines):
[Paste stack trace]

6. When it crashes:
- [ ] Immediately on launch
- [ ] After splash screen
- [ ] After login screen appears
- [ ] When navigating to specific screen
- [ ] Other: ___________

7. Device Info:
- iPhone model: ___________
- iOS version: ___________
```

---

## 🚀 Quick Actions Based on Crash Type

### If crash log shows:
- **"Firebase already initialized"** → Firebase double initialization issue
- **"MissingPluginException"** → Plugin not registered
- **"PlatformException"** → Native code issue
- **"Null check operator"** → Dart null safety issue
- **"EXC_BAD_ACCESS"** → Memory corruption
- **"SIGABRT"** → Assertion failure

---

## 💡 Enable More Detailed Logging

If you can't access crash logs yet, we can:
1. Add more `debugPrint()` statements
2. Add breadcrumb logging to track app flow
3. Add try-catch around every operation
4. Create a "safe mode" minimal version

---

## 🎯 Recommended Next Steps

**Option A: If you have a Mac**
→ Use Console app method (real-time debugging)

**Option B: If no Mac available**
→ Check App Store Connect after 24 hours (crashes upload automatically)

**Option C: If crashes happen immediately**
→ Get crash log from iPhone Settings → Analytics

**Option D: Need help now**
→ I can create an ultra-minimal version that logs everything

---

## ❓ Common Questions

**Q: How long until crashes appear in App Store Connect?**
A: Usually 24-48 hours after users experience them

**Q: Why don't I see crashes in TestFlight app?**
A: TestFlight only shows basic info; use App Store Connect for details

**Q: Can I test crash logging before uploading to TestFlight?**
A: Yes! Use Console app with device connected to Mac

**Q: What if crash log is too long to share?**
A: Share just:
- Exception Type
- Application Specific Information section
- First 30 lines of crashed thread stack trace

---

## 📞 Need Help?

If you share any crash log info, I can:
- ✅ Identify exact crash cause
- ✅ Point to specific file and line
- ✅ Provide targeted fix
- ✅ Explain why it's crashing

Just paste the crash log (or relevant parts) in the chat!
