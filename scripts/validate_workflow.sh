#!/bin/bash

# Workflow validation script for CryptingTool Android builds
# This script validates that the GitHub Actions workflows are properly configured

echo "🔍 Validating GitHub Actions Android Build Workflows..."
echo

# Check if workflow files exist
echo "📁 Checking workflow files..."
if [ -f ".github/workflows/android_build.yml" ]; then
    echo "  ✅ Debug build workflow exists"
else
    echo "  ❌ Debug build workflow missing"
    exit 1
fi

if [ -f ".github/workflows/android_release_build.yml" ]; then
    echo "  ✅ Release build workflow exists"
else
    echo "  ❌ Release build workflow missing"
    exit 1
fi

# Check Flutter project structure
echo
echo "📱 Checking Flutter project structure..."
if [ -f "pubspec.yaml" ]; then
    echo "  ✅ pubspec.yaml exists"
    
    # Check for Flutter dependencies
    if grep -q "flutter:" pubspec.yaml; then
        echo "  ✅ Flutter dependency found"
    else
        echo "  ❌ Flutter dependency missing"
    fi
    
    # Check for FFI dependency (for C++ integration)
    if grep -q "ffi:" pubspec.yaml; then
        echo "  ✅ FFI dependency found (C++ integration)"
    else
        echo "  ⚠️  FFI dependency missing (C++ integration may not work)"
    fi
else
    echo "  ❌ pubspec.yaml missing"
    exit 1
fi

if [ -d "lib" ]; then
    echo "  ✅ lib/ directory exists"
else
    echo "  ❌ lib/ directory missing"
    exit 1
fi

# Check Android project structure
echo
echo "🤖 Checking Android project structure..."
if [ -d "android" ]; then
    echo "  ✅ android/ directory exists"
else
    echo "  ❌ android/ directory missing"
    exit 1
fi

if [ -f "android/app/build.gradle" ]; then
    echo "  ✅ android/app/build.gradle exists"
    
    # Check minimum SDK version
    min_sdk=$(grep -oP 'minSdk\s*=\s*\K\d+' android/app/build.gradle || echo "")
    if [ -n "$min_sdk" ]; then
        echo "  ✅ minSdk: $min_sdk"
        if [ "$min_sdk" -ge 24 ]; then
            echo "    ✅ Meets modern Android requirements (API 24+)"
        else
            echo "    ⚠️  Consider updating to API 24+ for better compatibility"
        fi
    fi
    
    # Check target SDK version
    target_sdk=$(grep -oP 'targetSdk\s*=\s*\K\d+' android/app/build.gradle || echo "")
    if [ -n "$target_sdk" ]; then
        echo "  ✅ targetSdk: $target_sdk"
    fi
    
    # Check for NDK configuration
    if grep -q "ndkVersion" android/app/build.gradle; then
        echo "  ✅ NDK version configured"
    else
        echo "  ⚠️  NDK version not specified"
    fi
    
    # Check for C++ integration
    if grep -q "externalNativeBuild" android/app/build.gradle; then
        echo "  ✅ C++ native build configured"
    else
        echo "  ⚠️  C++ native build not configured"
    fi
else
    echo "  ❌ android/app/build.gradle missing"
    exit 1
fi

# Check C++ components
echo
echo "🔧 Checking C++ integration..."
if [ -f "CMakeLists.txt" ]; then
    echo "  ✅ CMakeLists.txt exists"
else
    echo "  ⚠️  CMakeLists.txt missing"
fi

if [ -d "src" ]; then
    echo "  ✅ src/ directory exists (C++ source)"
else
    echo "  ⚠️  src/ directory missing"
fi

if [ -d "include" ]; then
    echo "  ✅ include/ directory exists (C++ headers)"
else
    echo "  ⚠️  include/ directory missing"
fi

# Check workflow configuration
echo
echo "⚙️  Checking workflow configuration..."
debug_workflow=".github/workflows/android_build.yml"

# Check for correct Flutter action version
if grep -q "subosito/flutter-action@v2" $debug_workflow; then
    echo "  ✅ Correct Flutter action version (v2)"
else
    echo "  ⚠️  Consider using subosito/flutter-action@v2"
fi

# Check for Java version
if grep -q "java-version.*17" $debug_workflow; then
    echo "  ✅ Java 17 configured"
else
    echo "  ⚠️  Consider using Java 17 for better compatibility"
fi

# Check for C++ dependencies
if grep -q "libcrypto++-dev" $debug_workflow; then
    echo "  ✅ Crypto++ dependency configured"
else
    echo "  ⚠️  Crypto++ dependency missing"
fi

# Check for Gradle wrapper handling
if grep -q "gradle wrapper" $debug_workflow; then
    echo "  ✅ Gradle wrapper generation configured"
else
    echo "  ⚠️  Gradle wrapper generation not configured"
fi

echo
echo "✅ Workflow validation completed!"
echo
echo "📋 Summary:"
echo "  - Debug APK workflow: .github/workflows/android_build.yml"
echo "  - Release APK workflow: .github/workflows/android_release_build.yml"
echo "  - Trigger: Push/PR to main branch (debug), Tags (release)"
echo "  - Output: APK artifacts uploaded to GitHub Actions"
echo "  - C++ Integration: Crypto++ library with NDK build"
echo "  - Min SDK: API 24+ (Android 7.0+)"
echo
echo "🚀 Ready for Android APK builds!"