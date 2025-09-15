# Android API 24+ Configuration for Windows VM

This document describes the updated configuration for building Android APKs targeting API 35+ (Android 15) with a modern minimum API 16 (Android 4.1+) on Windows VM environment.

**Status: ✅ Configuration fixed - AndroidManifest.xml updated to match build.gradle**

## Overview

The project has been modernized to:
- Target Android API 35+ (Android 15) with modern optimizations
- Require minimum Android 7.0+ (API 24) for improved stability and security
- Build on Windows VM environment using GitHub Actions
- Include comprehensive build optimizations (R8, ProGuard, resource shrinking)
- Optimize performance and reduce APK size by removing legacy compatibility code

## Configuration Changes

### Android Platform Structure

#### `android/app/build.gradle`
- **minSdk**: Set to 16 (Android 4.1+) for broad compatibility
- **compileSdk**: Set to 35 (Android 15)
- **targetSdk**: Set to 35 (Android 15)
- **Java**: Updated to version 11 for better performance
- **Kotlin**: Updated to latest version (1.9+)
- **NDK**: Updated to latest version (26.1+)
- **Multidex**: Removed (not needed for API 24+)
- **Vector Drawables**: Legacy support removed (native support in API 24+)
- **R8 Optimization**: Full mode enabled for release builds
- **Code Minification**: Enabled for release builds
- **Resource Shrinking**: Enabled for release builds
- **ABI Filters**: Configured for optimal performance

#### `android/app/src/main/AndroidManifest.xml`
- Minimum SDK version specified as 16 (Android 4.1+)
- Target SDK version updated to 35 (Android 15)
- Required permissions configured for crypto operations
- Network access permissions for crypto functionality
- Legacy external storage permissions removed (modern scoped storage)
- Performance optimizations enabled:
  - Hardware acceleration enabled
  - Native library extraction optimization
  - RTL support enabled

#### `android/app/src/main/kotlin/com/binah/cryptingtool/MainActivity.kt`
- Flutter embedding setup
- Backward compatibility considerations
- Plugin registration

### GitHub Actions Workflow

#### `.github/workflows/windows-apk-build.yml`
Enhanced Windows-based APK build workflow with:
- **Java 17** setup with Gradle caching
- **Flutter SDK** stable channel
- **Android API 16+** validation and configuration
- Enhanced error reporting and build logging
- Comprehensive build status reporting

### Dependencies

#### `pubspec.yaml`
- FFI dependency for C++ integration
- Compatible Flutter version (3.3.0+)
- Support for Android API 16+ features

## Testing

### Automated Tests

Two test scripts have been created:

1. **`scripts/test-android-config.sh`**
   - Validates Android API 16+ configuration
   - Checks build.gradle settings
   - Verifies AndroidManifest.xml configuration
   - Ensures all required files are present

2. **`scripts/integration-test-android16.sh`**
   - Comprehensive integration testing
   - Validates entire build pipeline
   - Tests workflow configuration
   - Verifies dependencies and build scripts

### Manual Testing

To test the configuration:

```bash
# Run configuration test
./scripts/test-android-config.sh

# Run integration test
./scripts/integration-test-android16.sh

# Build APK (requires Flutter SDK)
flutter build apk --debug
```

## Compatibility

### Android Versions Supported
- **Minimum**: Android 7.0 (API 24) - Nougat (2016)
- **Target**: Android 15 (API 35) - Latest with optimizations
- **Compile**: Android 15 (API 35) - Latest development features

### Device Support
- Devices running Android 7.0 and above (~94% of active devices)
- Both ARM and x86 architectures
- Phones and tablets
- Modern security and performance features

### Benefits of API 24+ Minimum
- **Enhanced Security**: Modern TLS, improved crypto APIs, and security sandbox
- **Better Performance**: Native multidex handling, improved memory management
- **Simplified Code**: No need for legacy compatibility workarounds
- **Smaller APK Size**: Removal of compatibility libraries and legacy support
- **Modern Features**: Access to notification channels, adaptive icons, etc.
- **Better Development**: Cleaner build process with fewer edge cases

## Build Process

### Windows VM Environment
1. **Java 17** with Temurin distribution (supports Java 11 bytecode)
2. **Flutter SDK** stable channel (3.16+)
3. **Android SDK** with build tools (API 35)
4. **Gradle** with caching and parallel builds enabled
5. **Kotlin** 1.9+ for better performance

### Build Steps
1. System information gathering
2. Java and Flutter setup
3. Android platform initialization
4. Dependencies management
5. Build environment configuration
6. APK compilation
7. Error analysis and reporting

## Troubleshooting

### Common Issues

1. **Android SDK not found**
   - Ensure `ANDROID_HOME` is set
   - Check `local.properties` file

2. **Minimum SDK version conflicts**
   - Verify `build.gradle` minSdk = 16
   - Check `AndroidManifest.xml` uses minSdkVersion="16" (fixed)

3. **Build failures on Windows**
   - Ensure proper path separators
   - Check Java version compatibility

### Debug Information

Build logs are automatically generated:
- `android_setup.log`
- `flutter_doctor.log`
- `apk_build.log`
- `error_summary.txt`

## Maintenance

### Updating Android API Levels
To target newer Android versions:
1. Update `compileSdk` and `targetSdk` in `build.gradle`
2. Update `targetSdkVersion` in `AndroidManifest.xml`
3. Test compatibility with existing features
4. Update documentation

### Updating Flutter Version
1. Update version in workflow YAML
2. Test compatibility with Android 16+
3. Update `pubspec.yaml` constraints if needed

## Security Considerations

- Internet permissions for crypto operations
- File access permissions with proper scoping
- Network security configuration for development
- Legacy external storage access (scoped to API 28 and below)

## Performance Optimizations

- Gradle build caching enabled
- Parallel builds configured
- R8 code shrinking enabled
- Multidex optimization for legacy devices