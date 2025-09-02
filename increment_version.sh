#!/bin/bash

# Version Management Script for Gaiosophy App
# Usage: ./increment_version.sh [major|minor|patch|build]

if [ $# -eq 0 ]; then
    echo "Usage: $0 [major|minor|patch|build]"
    echo "Current version:"
    grep "version:" pubspec.yaml
    exit 1
fi

VERSION_TYPE=$1
PUBSPEC_FILE="pubspec.yaml"

# Get current version
CURRENT_VERSION=$(grep "version:" $PUBSPEC_FILE | sed 's/version: //')
VERSION_NUMBER=$(echo $CURRENT_VERSION | cut -d'+' -f1)
BUILD_NUMBER=$(echo $CURRENT_VERSION | cut -d'+' -f2)

MAJOR=$(echo $VERSION_NUMBER | cut -d'.' -f1)
MINOR=$(echo $VERSION_NUMBER | cut -d'.' -f2)
PATCH=$(echo $VERSION_NUMBER | cut -d'.' -f3)

echo "Current version: $CURRENT_VERSION"
echo "Version parts: $MAJOR.$MINOR.$PATCH+$BUILD_NUMBER"

case $VERSION_TYPE in
    "major")
        MAJOR=$((MAJOR + 1))
        MINOR=0
        PATCH=0
        BUILD_NUMBER=1
        ;;
    "minor")
        MINOR=$((MINOR + 1))
        PATCH=0
        BUILD_NUMBER=1
        ;;
    "patch")
        PATCH=$((PATCH + 1))
        BUILD_NUMBER=1
        ;;
    "build")
        BUILD_NUMBER=$((BUILD_NUMBER + 1))
        ;;
    *)
        echo "Invalid version type. Use: major, minor, patch, or build"
        exit 1
        ;;
esac

NEW_VERSION="$MAJOR.$MINOR.$PATCH+$BUILD_NUMBER"

echo "New version: $NEW_VERSION"

# Update pubspec.yaml
sed -i.bak "s/version: $CURRENT_VERSION/version: $NEW_VERSION/" $PUBSPEC_FILE

echo "✅ Version updated in pubspec.yaml"
echo "📱 Ready for next build!"

# Show git diff
if command -v git &> /dev/null; then
    echo ""
    echo "Git diff:"
    git diff $PUBSPEC_FILE
fi
