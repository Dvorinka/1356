#!/bin/bash

# Build APK Script for LifeTimer Flutter App
# This script provides multiple approaches to build the APK

echo "LifeTimer APK Build Script"
echo "=========================="

# Navigate to the lifetimer directory
cd lifetimer

echo "Current directory: $(pwd)"
echo "Flutter version: $(flutter --version | head -n 1)"

# Approach 1: Try building debug APK with minimal changes
echo ""
echo "Approach 1: Building debug APK..."
echo "================================"

# Temporarily disable problematic plugins
echo "Temporarily disabling problematic plugins..."

# Create a temporary pubspec.yaml without problematic dependencies
cp pubspec.yaml pubspec.yaml.backup

# Comment out problematic dependencies
sed -i 's/^  sign_in_with_apple:/  # sign_in_with_apple:/' pubspec.yaml
sed -i 's/^  supabase_flutter:/  # supabase_flutter:/' pubspec.yaml

# Clean and get dependencies
flutter clean
flutter pub get

# Try building APK
echo "Attempting to build APK..."
if flutter build apk --debug; then
    echo "✅ APK build successful!"
    echo "APK location: build/app/outputs/flutter-apk/app-debug.apk"
    
    # Show APK info
    ls -lh build/app/outputs/flutter-apk/app-debug.apk
    
    # Restore original pubspec.yaml
    mv pubspec.yaml.backup pubspec.yaml
    flutter pub get
    
    echo ""
    echo "Build completed successfully!"
    echo "You can install the APK with: adb install build/app/outputs/flutter-apk/app-debug.apk"
    
else
    echo "❌ APK build failed with Approach 1"
    
    # Restore original pubspec.yaml
    mv pubspec.yaml.backup pubspec.yaml
    flutter pub get
    
    echo ""
    echo "Approach 2: Building with release mode..."
    echo "====================================="
    
    # Try release build
    if flutter build apk --release; then
        echo "✅ Release APK build successful!"
        echo "APK location: build/app/outputs/flutter-apk/app-release.apk"
        
        # Show APK info
        ls -lh build/app/outputs/flutter-apk/app-release.apk
        
        echo ""
        echo "Build completed successfully!"
        echo "You can install the APK with: adb install build/app/outputs/flutter-apk/app-release.apk"
        
    else
        echo "❌ Both approaches failed"
        echo ""
        echo "Manual troubleshooting steps:"
        echo "1. Update Flutter to latest version: flutter upgrade"
        echo "2. Clean project: flutter clean && flutter pub get"
        echo "3. Check Android SDK installation"
        echo "4. Try building with specific target: flutter build apk --target-platform android-arm64"
        echo "5. Consider updating problematic dependencies in pubspec.yaml"
        
        exit 1
    fi
fi

echo ""
echo "Build script completed."
