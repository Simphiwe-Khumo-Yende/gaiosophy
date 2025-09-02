#!/bin/bash

# TestFlight Build Script for Gaiosophy App
# Run this script on macOS to build and prepare for TestFlight upload

echo "🚀 Starting TestFlight build process for Gaiosophy App..."

# Check if we're on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ This script must be run on macOS for iOS builds"
    exit 1
fi

# Check Flutter installation
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter not found. Please install Flutter first."
    exit 1
fi

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean

# Get dependencies
echo "📦 Getting Flutter dependencies..."
flutter pub get

# Check Flutter doctor
echo "🩺 Running Flutter doctor..."
flutter doctor

# Build for iOS release
echo "🔨 Building iOS release..."
flutter build ios --release

if [ $? -eq 0 ]; then
    echo "✅ iOS build completed successfully!"
    echo ""
    echo "Next steps:"
    echo "1. Open ios/Runner.xcworkspace in Xcode"
    echo "2. Configure signing with your Apple Developer account"
    echo "3. Archive the app (Product > Archive)"
    echo "4. Upload to App Store Connect"
    echo "5. Configure TestFlight and add testers"
else
    echo "❌ iOS build failed. Please check the errors above."
    exit 1
fi
