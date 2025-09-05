#!/bin/bash

# ========================================
# COMPREHENSIVE iOS BUILD DIAGNOSTIC SCRIPT
# ========================================
# This script checks EVERY aspect of your iOS setup
# Run this locally before pushing to GitHub Actions

echo "🔍 STARTING COMPREHENSIVE iOS BUILD DIAGNOSTIC..."
echo "=================================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counter for issues
ISSUES=0
WARNINGS=0

# Function to print status
print_status() {
    if [ $2 -eq 0 ]; then
        echo -e "${GREEN}✅ $1${NC}"
    else
        echo -e "${RED}❌ $1${NC}"
        ((ISSUES++))
    fi
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
    ((WARNINGS++))
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

echo
echo "1. 🏗️  PROJECT STRUCTURE CHECK"
echo "================================"

# Check Flutter project
if [ -f "pubspec.yaml" ]; then
    print_status "Flutter project root found" 0
    FLUTTER_VERSION=$(grep "version:" pubspec.yaml | head -1 | awk '{print $2}')
    print_info "App version: $FLUTTER_VERSION"
else
    print_status "Flutter project root NOT found" 1
fi

# Check iOS folder structure
if [ -d "ios" ]; then
    print_status "iOS folder exists" 0
    
    # Check critical iOS files
    [ -f "ios/Runner.xcworkspace/contents.xcworkspacedata" ] && print_status "Xcode workspace exists" 0 || print_status "Xcode workspace MISSING" 1
    [ -f "ios/Runner.xcodeproj/project.pbxproj" ] && print_status "Xcode project exists" 0 || print_status "Xcode project MISSING" 1
    [ -f "ios/Runner/Info.plist" ] && print_status "Info.plist exists" 0 || print_status "Info.plist MISSING" 1
    [ -f "ios/Podfile" ] && print_status "Podfile exists" 0 || print_status "Podfile MISSING" 1
    [ -f "ios/ExportOptions.plist" ] && print_status "ExportOptions.plist exists" 0 || print_status "ExportOptions.plist MISSING" 1
    [ -f "ios/Runner/GoogleService-Info.plist" ] && print_status "GoogleService-Info.plist exists" 0 || print_status "GoogleService-Info.plist MISSING" 1
else
    print_status "iOS folder MISSING" 1
fi

echo
echo "2. 🎯 XCODE PROJECT CONFIGURATION"
echo "=================================="

if [ -f "ios/Runner.xcodeproj/project.pbxproj" ]; then
    # Check DEVELOPMENT_TEAM
    if grep -q "DEVELOPMENT_TEAM = Z9WJ3V7JV3" ios/Runner.xcodeproj/project.pbxproj; then
        TEAM_COUNT=$(grep -c "DEVELOPMENT_TEAM = Z9WJ3V7JV3" ios/Runner.xcodeproj/project.pbxproj)
        print_status "DEVELOPMENT_TEAM configured ($TEAM_COUNT instances)" 0
    else
        print_status "DEVELOPMENT_TEAM MISSING or incorrect" 1
    fi
    
    # Check Bundle Identifier
    if grep -q "PRODUCT_BUNDLE_IDENTIFIER = com.gaiosophy.app" ios/Runner.xcodeproj/project.pbxproj; then
        print_status "Bundle Identifier configured correctly" 0
    else
        print_status "Bundle Identifier MISSING or incorrect" 1
    fi
    
    # Check Code Signing Style
    if grep -q "CODE_SIGN_STYLE = Automatic" ios/Runner.xcodeproj/project.pbxproj; then
        print_status "Automatic code signing enabled" 0
    else
        print_status "Automatic code signing NOT configured" 1
    fi
    
    # Check iOS Deployment Target
    if grep -q "IPHONEOS_DEPLOYMENT_TARGET" ios/Runner.xcodeproj/project.pbxproj; then
        DEPLOYMENT_TARGET=$(grep "IPHONEOS_DEPLOYMENT_TARGET" ios/Runner.xcodeproj/project.pbxproj | head -1 | sed 's/.*= \(.*\);/\1/')
        print_info "iOS Deployment Target: $DEPLOYMENT_TARGET"
        
        # Check if it's at least iOS 12.0
        if [[ "$DEPLOYMENT_TARGET" =~ ^[0-9]+\.[0-9]+$ ]] && [ "$(echo "$DEPLOYMENT_TARGET >= 12.0" | bc)" -eq 1 ]; then
            print_status "iOS Deployment Target is modern (>= 12.0)" 0
        else
            print_warning "iOS Deployment Target might be too old"
        fi
    else
        print_warning "iOS Deployment Target not found"
    fi
fi

echo
echo "3. 📋 INFO.PLIST VALIDATION"
echo "============================="

if [ -f "ios/Runner/Info.plist" ]; then
    # Check for essential keys
    if /usr/libexec/PlistBuddy -c "Print CFBundleIdentifier" ios/Runner/Info.plist 2>/dev/null; then
        BUNDLE_ID=$(/usr/libexec/PlistBuddy -c "Print CFBundleIdentifier" ios/Runner/Info.plist)
        print_status "CFBundleIdentifier: $BUNDLE_ID" 0
    else
        print_status "CFBundleIdentifier MISSING" 1
    fi
    
    if /usr/libexec/PlistBuddy -c "Print CFBundleDisplayName" ios/Runner/Info.plist 2>/dev/null; then
        DISPLAY_NAME=$(/usr/libexec/PlistBuddy -c "Print CFBundleDisplayName" ios/Runner/Info.plist)
        print_status "CFBundleDisplayName: $DISPLAY_NAME" 0
    else
        print_warning "CFBundleDisplayName missing (optional but recommended)"
    fi
    
    # Check version configuration
    if /usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" ios/Runner/Info.plist 2>/dev/null; then
        VERSION_STRING=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" ios/Runner/Info.plist)
        print_status "CFBundleShortVersionString: $VERSION_STRING" 0
    else
        print_status "CFBundleShortVersionString MISSING" 1
    fi
fi

echo
echo "4. 🔐 CODE SIGNING & CERTIFICATES"
echo "=================================="

# Check ExportOptions.plist
if [ -f "ios/ExportOptions.plist" ]; then
    if /usr/libexec/PlistBuddy -c "Print method" ios/ExportOptions.plist 2>/dev/null | grep -q "app-store"; then
        print_status "Export method set to app-store" 0
    else
        print_status "Export method NOT set to app-store" 1
    fi
    
    if /usr/libexec/PlistBuddy -c "Print teamID" ios/ExportOptions.plist 2>/dev/null | grep -q "Z9WJ3V7JV3"; then
        print_status "Team ID matches in ExportOptions.plist" 0
    else
        print_status "Team ID mismatch in ExportOptions.plist" 1
    fi
    
    if /usr/libexec/PlistBuddy -c "Print signingStyle" ios/ExportOptions.plist 2>/dev/null | grep -q "automatic"; then
        print_status "Signing style set to automatic" 0
    else
        print_status "Signing style NOT set to automatic" 1
    fi
fi

echo
echo "5. 📦 COCOAPODS & DEPENDENCIES"
echo "==============================="

# Check Podfile
if [ -f "ios/Podfile" ]; then
    print_status "Podfile exists" 0
    
    # Check platform version
    if grep -q "platform :ios" ios/Podfile; then
        PLATFORM_VERSION=$(grep "platform :ios" ios/Podfile | sed "s/.*'\(.*\)'.*/\1/")
        print_info "iOS platform version: $PLATFORM_VERSION"
    fi
    
    # Check for Firebase dependencies in pubspec.yaml
    if grep -q "firebase_" pubspec.yaml; then
        print_status "Firebase dependencies detected" 0
        
        # Check if GoogleService-Info.plist exists
        if [ -f "ios/Runner/GoogleService-Info.plist" ]; then
            print_status "GoogleService-Info.plist exists for Firebase" 0
        else
            print_status "GoogleService-Info.plist MISSING for Firebase" 1
        fi
    fi
else
    print_status "Podfile MISSING" 1
fi

# Check if Pods are installed
if [ -d "ios/Pods" ]; then
    print_status "CocoaPods dependencies installed" 0
    POD_COUNT=$(find ios/Pods -name "*.podspec" | wc -l)
    print_info "Number of pods: $POD_COUNT"
else
    print_warning "CocoaPods not installed (will be installed during build)"
fi

echo
echo "6. 🔧 FLUTTER CONFIGURATION"
echo "============================="

# Check Flutter dependencies
if [ -f "pubspec.yaml" ]; then
    # Count iOS-specific dependencies
    IOS_DEPS=$(grep -E "(path_provider|url_launcher|shared_preferences|firebase_|google_)" pubspec.yaml | wc -l)
    print_info "iOS-specific dependencies: $IOS_DEPS"
    
    # Check for problematic dependencies
    if grep -q "flutter_webview_plugin" pubspec.yaml; then
        print_warning "flutter_webview_plugin detected - consider using webview_flutter"
    fi
fi

# Check Flutter installation
if command -v flutter &> /dev/null; then
    FLUTTER_VERSION_INSTALLED=$(flutter --version | head -1 | awk '{print $2}')
    print_status "Flutter installed: $FLUTTER_VERSION_INSTALLED" 0
    
    # Check if iOS toolchain is installed
    if flutter doctor | grep -q "Xcode"; then
        print_status "Xcode toolchain available" 0
    else
        print_warning "Xcode toolchain issues detected"
    fi
else
    print_status "Flutter NOT installed" 1
fi

echo
echo "7. 🏃‍♂️ BUILD TEST (DRY RUN)"
echo "=========================="

if command -v flutter &> /dev/null && [ -d "ios" ]; then
    print_info "Testing Flutter iOS build (this may take a few minutes)..."
    
    # Test pub get
    if flutter pub get > /dev/null 2>&1; then
        print_status "flutter pub get successful" 0
    else
        print_status "flutter pub get FAILED" 1
    fi
    
    # Test iOS build (without codesigning)
    if flutter build ios --release --no-codesign > /dev/null 2>&1; then
        print_status "Flutter iOS build successful" 0
    else
        print_status "Flutter iOS build FAILED" 1
        echo "Build error details:"
        flutter build ios --release --no-codesign
    fi
fi

echo
echo "8. 🌐 GITHUB ACTIONS READINESS"
echo "==============================="

# Check if GitHub workflow exists
if [ -f ".github/workflows/ios-deploy.yml" ]; then
    print_status "GitHub Actions workflow exists" 0
    
    # Check for required secrets placeholders
    if grep -q "secrets.APPSTORE_ISSUER_ID" .github/workflows/ios-deploy.yml; then
        print_status "App Store Connect secrets configured in workflow" 0
    else
        print_status "App Store Connect secrets MISSING in workflow" 1
    fi
    
    # Check Flutter version in workflow
    if grep -q "FLUTTER_VERSION:" .github/workflows/ios-deploy.yml; then
        WORKFLOW_FLUTTER=$(grep "FLUTTER_VERSION:" .github/workflows/ios-deploy.yml | awk '{print $2}' | tr -d "'\"")
        print_info "Workflow Flutter version: $WORKFLOW_FLUTTER"
    fi
else
    print_status "GitHub Actions workflow MISSING" 1
fi

echo
echo "9. 📱 APP STORE CONNECT REQUIREMENTS"
echo "===================================="

print_info "Manual checks required:"
echo "   • App registered in App Store Connect with bundle ID: com.gaiosophy.app"
echo "   • Team ID Z9WJ3V7JV3 has access to the app"
echo "   • App Store Connect API key has App Manager role"
echo "   • TestFlight is enabled for the app"

echo
echo "10. 🔑 REQUIRED GITHUB SECRETS"
echo "==============================="

print_info "Ensure these secrets are set in GitHub repository settings:"
echo "   • APPSTORE_ISSUER_ID: Your App Store Connect Issuer ID"
echo "   • APPSTORE_KEY_ID: Your App Store Connect Key ID"
echo "   • APPSTORE_PRIVATE_KEY: Your App Store Connect API private key"

echo
echo "==============================================="
echo "🎯 DIAGNOSTIC SUMMARY"
echo "==============================================="

if [ $ISSUES -eq 0 ]; then
    echo -e "${GREEN}✅ All critical checks passed!${NC}"
    echo -e "${GREEN}Your project should build successfully.${NC}"
else
    echo -e "${RED}❌ Found $ISSUES critical issues that must be fixed.${NC}"
fi

if [ $WARNINGS -gt 0 ]; then
    echo -e "${YELLOW}⚠️  Found $WARNINGS warnings to consider.${NC}"
fi

echo
echo "==============================================="
echo "🚀 NEXT STEPS"
echo "==============================================="

if [ $ISSUES -eq 0 ]; then
    echo "1. Commit and push your changes"
    echo "2. Ensure GitHub secrets are configured"
    echo "3. Trigger the GitHub Actions workflow"
    echo "4. Monitor the build in GitHub Actions"
    echo "5. Check TestFlight for the uploaded build"
else
    echo "1. Fix all critical issues listed above"
    echo "2. Re-run this diagnostic script"
    echo "3. Test local build: flutter build ios --release --no-codesign"
    echo "4. Once all issues are resolved, push to GitHub"
fi

echo
echo "🏁 Diagnostic complete!"
exit $ISSUES
