#!/bin/bash

# Build Script for LifeTimer Flutter App
# Creates versioned APK in build/release directory

echo "LifeTimer APK Build Script"
echo "=========================="

# Navigate to the lifetimer directory
cd lifetimer

echo "Current directory: $(pwd)"
echo "Flutter version: $(flutter --version | head -n 1)"

# Get version from pubspec.yaml
VERSION=$(grep "version:" pubspec.yaml | cut -d' ' -f2 | cut -d'+' -f1)
BUILD_NUMBER=$(grep "version:" pubspec.yaml | cut -d'+' -f2)

echo "Building LifeTimer version $VERSION (build $BUILD_NUMBER)"

# Create release directory
mkdir -p build/release

# Build APK with version info and .env configuration
echo "Building APK with .env configuration..."
if flutter build apk --dart-define-from-file=.env --build-name=$VERSION --build-number=$BUILD_NUMBER; then
    echo "✅ APK build successful!"
    
    # Copy to release directory with versioned name
    cp build/app/outputs/flutter-apk/app-release.apk build/release/lifetimer-$VERSION-$BUILD_NUMBER.apk
    
    echo "✅ Build complete: build/release/lifetimer-$VERSION-$BUILD_NUMBER.apk"
    
    # Show APK info
    ls -lh build/release/lifetimer-$VERSION-$BUILD_NUMBER.apk
    
    echo ""
    echo "You can install the APK with: adb install build/release/lifetimer-$VERSION-$BUILD_NUMBER.apk"
    
else
    echo "❌ APK build failed"
    echo ""
    echo "Troubleshooting steps:"
    echo "1. Update Flutter: flutter upgrade"
    echo "2. Clean project: flutter clean && flutter pub get"
    echo "3. Check Android SDK installation"
    echo "4. Verify .env file exists and is properly formatted"
    
    exit 1
fi

echo ""
echo "Build script completed."
