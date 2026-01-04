# APK Build Guide for LifeTimer Flutter App

## Current Status
❌ **Build Issue**: The `sign_in_with_apple` plugin (version 5.0.0) has compilation errors with the current Flutter/Gradle setup.

## Root Cause
The `sign_in_with_apple` plugin uses deprecated Flutter Android embedding APIs that are incompatible with the current Flutter version (3.38.5).

## Solutions

### Option 1: Quick Fix (Recommended for Testing)
1. **Temporarily disable Apple Sign-In**:
   ```bash
   cd lifetimer
   # Edit pubspec.yaml and comment out sign_in_with_apple
   sed -i 's/^  sign_in_with_apple:/  # sign_in_with_apple:/' pubspec.yaml
   
   # Clean and rebuild
   flutter clean
   flutter pub get
   flutter build apk --debug
   ```

2. **Install the APK**:
   ```bash
   adb install build/app/outputs/flutter-apk/app-debug.apk
   ```

### Option 2: Update Dependencies (Recommended for Production)
Update the problematic dependencies to compatible versions:

1. **Update pubspec.yaml**:
   ```yaml
   # Replace these versions
   sign_in_with_apple: ^6.0.0  # Updated version
   supabase_flutter: ^2.0.0    # Updated version
   ```

2. **Run update commands**:
   ```bash
   flutter pub upgrade
   flutter pub get
   flutter build apk --release
   ```

### Option 3: Manual Build Commands

#### Debug APK (for testing)
```bash
cd lifetimer
flutter clean
flutter pub get
flutter build apk --debug --target-platform android-arm64
```

#### Release APK (for production)
```bash
cd lifetimer
flutter clean
flutter pub get
flutter build apk --release --shrink
```

## APK Location
After successful build, the APK will be located at:
- **Debug**: `lifetimer/build/app/outputs/flutter-apk/app-debug.apk`
- **Release**: `lifetimer/build/app/outputs/flutter-apk/app-release.apk`

## Installation Commands

### Install via ADB
```bash
# Debug APK
adb install lifetimer/build/app/outputs/flutter-apk/app-debug.apk

# Release APK (requires uninstalling debug version first)
adb uninstall com.example.lifetimer
adb install lifetimer/build/app/outputs/flutter-apk/app-release.apk
```

### Install via File Transfer
1. Copy the APK file to your Android device
2. Enable "Install from unknown sources" in device settings
3. Tap on the APK file to install

## Troubleshooting

### Common Issues
1. **"sign_in_with_apple" compilation error**: Use Option 1 to disable it temporarily
2. **"google-services.json missing"**: Comment out Google services plugin in `android/app/build.gradle.kts`
3. **Gradle version conflicts**: Update Flutter and Gradle versions

### Environment Setup
Ensure you have:
- Flutter SDK installed and in PATH
- Android SDK with API level 34+
- Java 17 installed
- Android Studio or VS Code with Flutter extensions

### Verification Commands
```bash
# Check Flutter setup
flutter doctor -v

# Check connected devices
flutter devices

# Check Android SDK
flutter doctor --android-licenses
```

## Build Variants

### Development Build
```bash
flutter build apk --debug --no-shrink
```

### Production Build
```bash
flutter build apk --release --obfuscate --split-debug-info=build/debug-info/
```

### Specific Architecture
```bash
flutter build apk --release --target-platform android-arm64
```

## Next Steps

1. **For immediate testing**: Use Option 1 to build a debug APK without Apple Sign-In
2. **For production**: Update dependencies using Option 2
3. **For long-term**: Consider migrating to newer plugin versions that support current Flutter APIs

## Support

If you continue to experience issues:
1. Check the Flutter documentation: https://flutter.dev/docs/deployment/android
2. Review plugin-specific documentation for updated APIs
3. Consider creating a minimal reproduction case for the plugin maintainers
