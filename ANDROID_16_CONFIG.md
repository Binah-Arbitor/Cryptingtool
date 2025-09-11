# Android 16+ Configuration for Windows VM

This document describes the updated configuration for building Android APKs targeting API 16+ (Android 4.1 Jelly Bean and above) on Windows VM environment.

## Overview

The project has been configured to:
- Target Android API 16+ (Android 4.1 Jelly Bean and above)
- Build on Windows VM environment using GitHub Actions
- Maintain all existing C++ cryptographic functionality
- Ensure backward compatibility with older Android devices

## Configuration Changes

### Android Platform Structure

#### `android/app/build.gradle`
- **minSdk**: Set to 16 (Android 4.1+)
- **compileSdk**: Set to 35 (Android 15)
- **targetSdk**: Set to 35 (Android 15)
- **NDK Version**: Updated to 26.1.10909125
- **Java Version**: Updated to 11 for better performance
- **Multidex**: Enabled for legacy Android support
- **Vector Drawables**: Support enabled for API < 21
- **Build Optimizations**: R8 shrinking, ProGuard rules, lint optimizations
- **Release Build**: MinifyEnabled and ShrinkResources enabled

#### `android/app/src/main/AndroidManifest.xml`
- Minimum SDK version specified as 16
- Target SDK version updated to 35 (Android 15)
- Required permissions configured for crypto operations
- Network access permissions for crypto functionality
- File access permissions with proper scoping

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
- **Minimum**: Android 4.1 (API 16) - Jelly Bean
- **Target**: Android 15 (API 35) - Latest
- **Compile**: Android 15 (API 35) - Latest

### Device Support
- Devices running Android 4.1 and above
- Both ARM and x86 architectures
- Phones and tablets
- Legacy device support with multidex

### Features for Legacy Support
- **Multidex**: Enabled for apps exceeding method count limits
- **Vector Drawables**: Backward compatibility for API < 21
- **Legacy External Storage**: Support for older file access patterns
- **Network Security**: Clear text traffic allowed for development

## Build Process

### Windows VM Environment
1. **Java 17** with Temurin distribution
2. **Flutter SDK** stable channel
3. **Android SDK** with build tools
4. **Gradle** with caching enabled

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
   - Check `AndroidManifest.xml` uses-sdk

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
3. Update Android Gradle Plugin version in `settings.gradle`
4. Update Kotlin version for compatibility
5. Update NDK version if needed
6. Test compatibility with existing features
7. Update documentation

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
- Parallel builds configured with increased memory
- R8 code shrinking enabled
- ProGuard rules for release builds
- Multidex optimization for legacy devices
- Dependency resolution strategy optimizations
- Build feature flags for unused features disabled
- G1 garbage collector enabled for Gradle daemon
- Lint optimizations to skip unnecessary checks