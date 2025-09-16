# CMake Configuration (Archived)

This directory previously contained CMake-based build configuration for Android native build.

The build system has been migrated to NDK build system (ndk-build) with Android.mk/Application.mk files.

## Migration Details

- **Old location**: `android/app/src/main/cpp/CMakeLists.txt`
- **New location**: `android/app/src/main/jni/Android.mk` + `android/app/src/main/jni/Application.mk`
- **Build system**: Changed from CMake to NDK build

## Backup File

The original CMakeLists.txt has been preserved as `CMakeLists.txt.backup` for reference.

For current build configuration, see:
- `../jni/Android.mk` - Native module definition
- `../jni/Application.mk` - Build configuration
- `../../../build.gradle` - Gradle integration

See `NDK_BUILD_MIGRATION.md` in project root for complete migration details.