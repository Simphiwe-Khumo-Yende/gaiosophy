#!/bin/bash

# ========================================
# LOCAL iOS BUILD TESTING SCRIPT
# ========================================
# Run this script to test your iOS build locally (requires macOS)

set -e  # Exit on any error

echo "🚀 Starting Local iOS Build Test..."
echo "===================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print status
print_status() {
    if [ $2 -eq 0 ]; then
        echo -e "${GREEN}✅ $1${NC}"
    else
        echo -e "${RED}❌ $1${NC}"
        exit 1
    fi
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo -e "${RED}❌ This script requires macOS for iOS development${NC}"
    echo "Use GitHub Actions workflow for Windows/Linux development"
    exit 1
fi

echo
echo "1. 🔍 Pre-flight Checks"
echo "======================"

# Check Flutter
if command -v flutter &> /dev/null; then
    FLUTTER_VERSION=$(flutter --version | head -1 | awk '{print $2}')
    print_status "Flutter installed: $FLUTTER_VERSION" 0
else
    print_status "Flutter not found" 1
fi

# Check Xcode
if command -v xcodebuild &> /dev/null; then
    XCODE_VERSION=$(xcodebuild -version | head -1)
    print_status "Xcode found: $XCODE_VERSION" 0
else
    print_status "Xcode not found" 1
fi

# Check CocoaPods
if command -v pod &> /dev/null; then
    POD_VERSION=$(pod --version)
    print_status "CocoaPods installed: $POD_VERSION" 0
else
    print_status "CocoaPods not found" 1
fi

echo
echo "2. 🧹 Cleaning Previous Builds"
echo "=============================="

print_info "Cleaning Flutter build cache..."
flutter clean

print_info "Removing iOS build artifacts..."
cd ios
rm -rf build/
rm -rf Pods/
rm -f Podfile.lock
cd ..

print_status "Clean completed" 0

echo
echo "3. 📦 Installing Dependencies"
echo "============================="

print_info "Running flutter pub get..."
flutter pub get
print_status "Flutter dependencies installed" 0

print_info "Ensuring Flutter iOS frameworks..."
flutter precache --ios
print_status "Flutter iOS frameworks cached" 0

print_info "Installing CocoaPods..."
cd ios
pod install --verbose
print_status "CocoaPods installed" 0

echo
echo "4. 🔧 Configuring CocoaPods Integration"
echo "======================================="

# Add CocoaPods includes to Flutter xcconfig files
if [ -f "Pods/Target Support Files/Pods-Runner/Pods-Runner.debug.xcconfig" ]; then
    if ! grep -q "Pods-Runner.debug.xcconfig" Flutter/Debug.xcconfig; then
        echo "" >> Flutter/Debug.xcconfig
        echo "#include \"../Pods/Target Support Files/Pods-Runner/Pods-Runner.debug.xcconfig\"" >> Flutter/Debug.xcconfig
        print_status "Added CocoaPods debug config to Flutter/Debug.xcconfig" 0
    else
        print_info "CocoaPods debug config already included"
    fi
fi

if [ -f "Pods/Target Support Files/Pods-Runner/Pods-Runner.release.xcconfig" ]; then
    if ! grep -q "Pods-Runner.release.xcconfig" Flutter/Release.xcconfig; then
        echo "" >> Flutter/Release.xcconfig
        echo "#include \"../Pods/Target Support Files/Pods-Runner/Pods-Runner.release.xcconfig\"" >> Flutter/Release.xcconfig
        print_status "Added CocoaPods release config to Flutter/Release.xcconfig" 0
    else
        print_info "CocoaPods release config already included"
    fi
    
    if ! grep -q "Pods-Runner.release.xcconfig" Flutter/Profile.xcconfig; then
        echo "" >> Flutter/Profile.xcconfig
        echo "#include \"../Pods/Target Support Files/Pods-Runner/Pods-Runner.release.xcconfig\"" >> Flutter/Profile.xcconfig
        print_status "Added CocoaPods profile config to Flutter/Profile.xcconfig" 0
    else
        print_info "CocoaPods profile config already included"
    fi
fi

cd ..

echo
echo "5. 🔍 Verification Checks"
echo "========================="

cd ios

# Check xcconfig files
for config in Debug Release Profile; do
    if [ -f "Flutter/${config}.xcconfig" ]; then
        print_status "Flutter/${config}.xcconfig exists" 0
        print_info "Content: $(cat Flutter/${config}.xcconfig | tr '\n' ' ')"
    else
        print_status "Flutter/${config}.xcconfig missing" 1
    fi
done

# Check CocoaPods integration
if [ -d "Pods/Target Support Files/Pods-Runner" ]; then
    print_status "CocoaPods target configurations exist" 0
else
    print_status "CocoaPods target configurations missing" 1
fi

# Check workspace
if [ -f "Runner.xcworkspace/contents.xcworkspacedata" ]; then
    print_status "Xcode workspace exists" 0
else
    print_status "Xcode workspace missing" 1
fi

cd ..

echo
echo "6. 🏗️ Testing Flutter Build"
echo "==========================="

print_info "Building iOS app (Release, no codesign)..."
if flutter build ios --release --no-codesign --verbose; then
    print_status "Flutter iOS build successful" 0
else
    print_status "Flutter iOS build failed" 1
fi

echo
echo "7. 📱 Testing Xcode Archive (Optional)"
echo "====================================="

read -p "Do you want to test Xcode archive creation? (requires valid signing) [y/N]: " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_info "Creating Xcode archive..."
    cd ios
    if xcodebuild -workspace Runner.xcworkspace \
        -scheme Runner \
        -configuration Release \
        -destination generic/platform=iOS \
        -archivePath ../build/Runner.xcarchive \
        CODE_SIGN_STYLE=Automatic \
        DEVELOPMENT_TEAM=Z9WJ3V7JV3 \
        archive; then
        print_status "Xcode archive created successfully" 0
        
        if [ -d "../build/Runner.xcarchive" ]; then
            print_info "Archive location: build/Runner.xcarchive"
            print_info "Archive size: $(du -sh ../build/Runner.xcarchive | cut -f1)"
        fi
    else
        print_warning "Xcode archive failed (this may be due to signing requirements)"
    fi
    cd ..
else
    print_info "Skipping Xcode archive test"
fi

echo
echo "==============================================="
echo "🎉 LOCAL BUILD TEST COMPLETE!"
echo "==============================================="

if [ -d "build/ios/iphoneos/Runner.app" ]; then
    echo -e "${GREEN}✅ iOS app built successfully!${NC}"
    echo -e "${GREEN}✅ Ready for GitHub Actions deployment${NC}"
    
    echo
    echo "📋 Build Artifacts:"
    echo "   - iOS App: build/ios/iphoneos/Runner.app"
    echo "   - Size: $(du -sh build/ios/iphoneos/Runner.app | cut -f1)"
    
    if [ -d "build/Runner.xcarchive" ]; then
        echo "   - Archive: build/Runner.xcarchive"
        echo "   - Archive Size: $(du -sh build/Runner.xcarchive | cut -f1)"
    fi
else
    echo -e "${RED}❌ iOS app build not found${NC}"
    echo "Check the build logs above for errors"
    exit 1
fi

echo
echo "🚀 Next Steps:"
echo "1. Commit your changes if any were made"
echo "2. Set up GitHub secrets (if not already done)"
echo "3. Push to GitHub to trigger the workflow"
echo "4. Monitor GitHub Actions for deployment"

echo
echo "🔧 GitHub Secrets Required:"
echo "   - APPSTORE_ISSUER_ID"
echo "   - APPSTORE_KEY_ID" 
echo "   - APPSTORE_PRIVATE_KEY"

echo
echo "✨ Happy deploying!"
