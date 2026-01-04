# Git Configuration for Manual Releases

This document outlines the Git configuration to ensure build files and unnecessary files are not uploaded, allowing for manual release management.

## ✅ What's Already Configured

### Build Files Excluded
- **APK/AAB files**: `*.apk`, `*.aab` 
- **Android build directories**: `/android/app/build/`, `/android/build/`, `/android/.gradle/`
- **iOS build directories**: `/ios/build/`, `/ios/Flutter/Flutter.framework`
- **Flutter build artifacts**: `/build/`, `.dart_tool/`, `.pub-cache/`
- **Debug/Release profiles**: `/android/app/debug`, `/android/app/profile`, `/android/app/release`

### Development Files Excluded
- **IDE files**: `.idea/`, `*.iml`, `*.ipr`, `*.iws`
- **Environment files**: `.env`, `.env.local`, `.env.*.local`
- **Cache files**: `.DS_Store`, `Thumbs.db`, `*.log`
- **Keystore files**: `*.keystore`, `*.jks`, `key.properties`

## 📁 Git Ignore Files

### Root `.gitignore` (Enhanced)
- Comprehensive Flutter/Android/iOS exclusions
- Build artifact prevention
- Environment and security file protection

### Android `.gitignore` (Enhanced) 
- Platform-specific build files
- Gradle wrapper exclusions
- NDK and temporary files

## 🔧 Manual Release Workflow

### 1. Build Your APK/AAB
```bash
# Make the build script executable (already done)
chmod +x build_apk.sh

# Run the build script
./build_apk.sh
```

### 2. Build Artifacts Location
Build files are automatically placed in:
- `lifetimer/build/app/outputs/flutter-apk/` (APK files)
- `lifetimer/build/app/outputs/bundle/release/` (AAB files)

### 3. Distribution Ready
The build script creates timestamped files in a `releases/` directory:
- `releases/lifetimer-YYYYMMDD-HHMMSS.apk`
- `releases/lifetimer-YYYYMMDD-HHMMSS.aab`

## 🔒 Security & Git Safety

### Keystore Management
- Keystore files are **never** tracked by Git
- Store your `key.properties` and `*.keystore` files securely
- Use environment variables for sensitive data

### Build File Isolation
- All build outputs are excluded from version control
- Manual releases are completely separate from Git workflow
- No risk of accidentally committing large binary files

## 📋 Verification Commands

### Check Git Status
```bash
# See untracked files (builds should be ignored)
git status --ignored

# Verify no build files are tracked
git ls-files | grep -E "(build|\.apk|\.aab|\.keystore)"
```

### Test Build Exclusions
```bash
# Build should create files that Git ignores
./build_apk.sh

# Verify build files are ignored
git status
# Should show: "nothing to commit, working tree clean"
```

## 🚀 Release Process

1. **Build**: Run `./build_apk.sh`
2. **Test**: Install APK on device/emulator
3. **Distribute**: Share files from `releases/` directory
4. **Version**: Update version numbers in `pubspec.yaml` if needed
5. **Commit**: Only commit source code changes, never build files

## 📝 Notes

- The `.gitignore` files are comprehensive and cover all major build artifacts
- Manual releases give you full control over distribution timing
- Build files are automatically excluded, preventing repository bloat
- All sensitive files (keystores, env vars) are protected from accidental commits
