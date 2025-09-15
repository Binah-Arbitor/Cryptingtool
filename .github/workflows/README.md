# APK Build Workflow

This document describes the GitHub Actions workflow for building debug APK files for the Cryptingtool Flutter application.

## Workflow Configuration

### Requirements Met
- ✅ **Linux Environment**: Ubuntu 22.04 LTS (latest stable)
- ✅ **Android API Target**: API 32+ (compileSdk: 35, targetSdk: 35)
- ✅ **Minimum Support**: API 16 (Android 4.1+) for broad compatibility
- ✅ **Debug Build**: Configured for debug APK generation
- ✅ **Multi-language Support**: Dart (Flutter) + C++ components
- ✅ **Automatic License Acceptance**: Android SDK licenses accepted automatically
- ✅ **Modern Toolchain**: Java 17, Flutter 3.24.5, NDK 26.1.10909125

### Architecture Support
- ARM64 (arm64-v8a) - Modern 64-bit Android devices
- ARM (armeabi-v7a) - Older 32-bit Android devices
- x86_64 - Android emulators and x86 devices

## Workflow Features

### Performance & Stability Optimizations
- **Ubuntu 22.04 LTS**: Latest long-term support version for maximum stability
- **Java 17 Temurin**: Eclipse Temurin distribution for optimal performance
- **Gradle Caching**: Automatic dependency caching to speed up builds
- **Flutter Caching**: Cached Flutter SDK installation
- **Build Timeout**: 45-minute timeout prevents hanging builds
- **Shallow Git Clone**: Faster repository checkout

### Build Process
1. **Environment Setup**
   - Java 17 JDK with Gradle caching
   - Flutter 3.24.5 stable with caching
   - Android SDK with API levels 32-35
   - NDK 26.1.10909125 for native C++ builds

2. **Dependencies Installation**
   - Crypto++ library and development headers
   - CMake and Ninja build system
   - Build-essential tools

3. **Build Steps**
   - Flutter dependencies installation
   - C++ components compilation (with Crypto++ integration)
   - Android environment configuration
   - Multi-architecture APK generation

4. **Artifacts & Results**
   - Debug APK files uploaded with 30-day retention
   - Build logs uploaded on failure (7-day retention)
   - APK analysis and verification

## Triggering the Workflow

### Automatic Triggers
- Push to `main`, `develop`, or `master` branches
- Pull requests to these branches

### Manual Trigger
Use the `workflow_dispatch` event from the GitHub Actions tab:
- Optional Flutter version input (defaults to 3.24.5)

## Output Artifacts

### Generated APKs
- `app-arm64-v8a-debug.apk` - ARM64 devices
- `app-armeabi-v7a-debug.apk` - ARM32 devices  
- `app-x86_64-debug.apk` - x86 devices/emulators
- `app-debug.apk` - Universal APK (all architectures)

### Build Information
Each APK includes:
- Package ID: `com.binah.cryptingtool`
- Minimum SDK: 16 (Android 4.1+)
- Target SDK: 35 (Android 15)
- Debug configuration with full debugging symbols

## Validation

Run the validation script to check configuration:
```bash
./scripts/validate_apk_build.sh
```

This verifies:
- Project structure integrity
- Android SDK configuration compliance
- C++ dependency detection
- Workflow configuration validation

## Troubleshooting

### Common Issues
1. **Build Failures**: Check uploaded build logs in the Actions artifacts
2. **Dependency Issues**: Verify Crypto++ library installation in workflow logs
3. **NDK Problems**: Ensure NDK version matches between `build.gradle` and workflow

### Debug Information
The workflow provides extensive logging:
- Dependency verification steps
- Build progress with verbose output
- APK analysis and file sizes
- Complete Flutter doctor output