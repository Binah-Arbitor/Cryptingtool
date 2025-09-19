# Android Build Workflows for CryptingTool

This document describes the GitHub Actions workflows for building Android APKs for the CryptingTool Flutter application.

## 📋 Available Workflows

### 1. Debug APK Build (`android_build.yml`)

**Trigger:** 
- Push to `main` branch
- Pull Request to `main` branch

**What it does:**
- Builds a debug APK for testing and development
- Includes all debugging symbols and capabilities
- Suitable for internal testing and development

**Output:** `app-debug.apk` uploaded as GitHub Actions artifact

### 2. Release APK Build (`android_release_build.yml`)

**Trigger:**
- Git tags starting with `v` (e.g., `v1.0.0`, `v2.1.3`)
- Manual workflow dispatch

**What it does:**
- Builds an optimized release APK
- Enables code shrinking and obfuscation
- Optimized for distribution

**Output:** `app-release.apk` uploaded as GitHub Actions artifact

## 🔧 Technical Details

### Dependencies Installed
- **Java 17** (Temurin distribution)
- **Flutter SDK** (stable channel)
- **Android SDK** with build tools
- **C++ Build Tools**: GCC, CMake, Ninja
- **Crypto++ Library**: For cryptographic operations

### Build Configuration
- **Minimum SDK**: API 24 (Android 7.0)
- **Target SDK**: API 34 (Android 14)
- **NDK Version**: 26.1.10909125
- **Architectures**: arm64-v8a, armeabi-v7a, x86_64

### C++ Integration
- Uses NDK build system
- Integrates Crypto++ library
- Builds native libraries for encryption/decryption operations

## 🚀 Usage

### Running Debug Build

1. **Automatic**: Push code to `main` branch or create a PR
   ```bash
   git push origin main
   ```

2. **Manual**: Go to GitHub Actions tab and trigger manually

### Running Release Build

1. **Create and push a tag**:
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```

2. **Manual**: Go to GitHub Actions → "Flutter Android Release Build" → "Run workflow"

### Downloading APKs

1. Go to the GitHub Actions tab
2. Click on the completed workflow run
3. Scroll down to "Artifacts" section
4. Download `debug-apk` or `release-apk`

## 📱 APK Information

### Debug APK
- **File**: `app-debug.apk`
- **Package ID**: `com.binah.cryptingtool`
- **Signed**: Debug keystore (for testing only)
- **Debuggable**: Yes
- **Optimized**: No

### Release APK
- **File**: `app-release.apk`
- **Package ID**: `com.binah.cryptingtool`
- **Signed**: Debug keystore (⚠️ Update for production)
- **Debuggable**: No
- **Optimized**: Yes (R8, ProGuard)

## ⚠️ Production Considerations

### For Production Release:
1. **Update Signing Configuration**: Replace debug keystore with production keystore
2. **Update Package ID**: Consider using a production-specific package ID
3. **Test Thoroughly**: Test on various Android devices and API levels
4. **Update Metadata**: Ensure app name, version, and permissions are correct

### Security Notes:
- Current configuration uses debug signing for both debug and release builds
- For production, configure proper signing with secure keystores
- Review and update app permissions as needed
- Consider enabling additional security features

## 🔍 Troubleshooting

### Common Issues:

1. **Gradle Wrapper Missing**
   - The workflow automatically generates the Gradle wrapper if missing
   - If this fails, check Gradle installation in the build environment

2. **C++ Build Failures**
   - Ensure Crypto++ library is properly installed
   - Check NDK version compatibility
   - Verify CMakeLists.txt configuration

3. **Flutter Build Failures**
   - Check `pubspec.yaml` for correct dependencies
   - Ensure Flutter version compatibility
   - Verify Android SDK licenses are accepted

4. **APK Not Generated**
   - Check build logs for specific error messages
   - Verify all required dependencies are installed
   - Ensure Android project configuration is correct

### Validation:
Run the validation script to check configuration:
```bash
./scripts/validate_workflow.sh
```

## 📈 Workflow Optimization

The workflows include several optimizations:
- **Parallel builds**: Gradle parallel processing enabled
- **Caching**: Build caching for faster subsequent builds
- **Minimal installs**: Only necessary dependencies are installed
- **Error handling**: Comprehensive error checking and reporting

## 📞 Support

For issues related to the build workflows:
1. Check the troubleshooting section above
2. Review GitHub Actions logs for specific error messages
3. Run local validation scripts
4. Create an issue in the repository with build logs