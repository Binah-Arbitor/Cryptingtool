# NDK Build System Migration

## Overview

This project has been migrated from CMake-based build system to NDK build system (ndk-build) as requested. The change follows Stack Overflow best practices for Android native development.

## Changes Made

### 1. Build System Configuration

**Before (CMake):**
```gradle
externalNativeBuild {
    cmake {
        path "src/main/cpp/CMakeLists.txt"
        version "3.22.1"
    }
}
```

**After (NDK Build):**
```gradle
externalNativeBuild {
    ndkBuild {
        path "src/main/jni/Android.mk"
    }
}
```

### 2. Build Files Created

#### `android/app/src/main/jni/Android.mk`
- Defines the native module `cryptingtool`
- Configures source files from `src/crypting.cpp` and `src/crypto_bridge.cpp`
- Sets up include directories and compiler flags
- Handles both release and debug build configurations

#### `android/app/src/main/jni/Application.mk`
- Configures supported ABIs: `arm64-v8a`, `armeabi-v7a`, `x86_64`
- Sets Android API level to 32 (Android 12+)
- Configures STL to use `c++_shared`
- Enables modern C++17 features

### 3. Build Arguments Updated

**Release Build:**
```gradle
externalNativeBuild {
    ndkBuild {
        arguments "APP_OPTIM=release", 
                 "APP_ABI=arm64-v8a,armeabi-v7a,x86_64",
                 "APP_STL=c++_shared",
                 "APP_PLATFORM=android-32"
        abiFilters 'arm64-v8a', 'armeabi-v7a', 'x86_64'
        targets "cryptingtool"
    }
}
```

**Debug Build:**
```gradle
externalNativeBuild {
    ndkBuild {
        arguments "APP_OPTIM=debug", 
                 "APP_ABI=arm64-v8a,armeabi-v7a,x86_64",
                 "APP_STL=c++_shared",
                 "APP_PLATFORM=android-32"
        abiFilters 'arm64-v8a', 'armeabi-v7a', 'x86_64'
        targets "cryptingtool"
    }
}
```

## Benefits of NDK Build System

### 1. Traditional Android Development
- Uses Android.mk makefiles (traditional NDK approach)
- More familiar to Android native developers
- Direct control over build process

### 2. Simplified Configuration
- Less complex than CMake for simple projects
- Built-in Android-specific optimizations
- Better integration with older NDK workflows

### 3. Stack Overflow Compatibility
- Follows common patterns found in Stack Overflow solutions
- Compatible with most NDK build tutorials and examples
- Easier troubleshooting with community resources

## Technical Details

### Compiler Flags
- **C++ Standard**: C++17
- **Optimizations**: `-Os` for release, `-O0 -g` for debug
- **Android Specific**: `-DANDROID`, `-DCRYPTOPP_DISABLE_ASM=1`
- **Exception Handling**: `-fno-exceptions -fno-rtti` for performance

### Library Configuration
- **Output**: `libcryptingtool.so`
- **STL**: `c++_shared` (modern C++ standard library)
- **Linking**: Android log library (`-llog`)

### Architecture Support
- **arm64-v8a**: Modern 64-bit ARM devices
- **armeabi-v7a**: 32-bit ARM devices
- **x86_64**: 64-bit Intel devices (emulators)

## Validation

The build configuration has been validated using the existing APK build validation script:
```bash
./scripts/validate_apk_build.sh
```

All validations pass, confirming:
- ✅ Proper NDK version configuration (26.1.10909125)
- ✅ Compatible Android API levels (32-35)
- ✅ Correct source file references
- ✅ Build system integration

## Migration Impact

### Maintained Features
- Same source files (`src/crypting.cpp`, `src/crypto_bridge.cpp`)
- Same include directories (`include/`)
- Same NDK version (26.1.10909125)
- Same supported architectures
- Same build optimizations

### Build System Changes
- Moved from `src/main/cpp/` to `src/main/jni/`
- Changed from `CMakeLists.txt` to `Android.mk`/`Application.mk`
- Updated Gradle configuration to use `ndkBuild`

This migration successfully transitions the project to use the NDK build system while maintaining all existing functionality and build targets.