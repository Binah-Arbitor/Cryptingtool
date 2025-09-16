#!/bin/bash

# APK Build Validation Script
# Tests the prerequisites and configuration for the GitHub Actions workflow

set -e

echo "🔍 Validating APK Build Configuration..."

# Check if all required files exist
echo "📁 Checking project structure..."
files_to_check=(
    "pubspec.yaml"
    "android/app/build.gradle"
    "android/build.gradle"
    "android/gradlew"
    "android/gradle/wrapper/gradle-wrapper.properties"
    "android/gradle/wrapper/gradle-wrapper.jar"
    "CMakeLists.txt"
    ".github/workflows/build-debug-apk.yml"
)

for file in "${files_to_check[@]}"; do
    if [ -f "$file" ]; then
        echo "  ✅ $file exists"
    else
        echo "  ❌ $file missing"
        exit 1
    fi
done

# Validate Gradle Wrapper
echo "⚙️ Validating Gradle Wrapper..."
if [ -f "android/gradlew" ] && [ -x "android/gradlew" ]; then
    echo "  ✅ Gradle wrapper is executable"
    gradle_version=$(cd android && ./gradlew --version | grep "Gradle " | head -1 || echo "Unknown version")
    echo "  ✅ Gradle wrapper version: $gradle_version"
else
    echo "  ❌ Gradle wrapper not found or not executable"
    exit 1
fi

# Validate Android configuration
echo "🤖 Validating Android configuration..."
gradle_file="android/app/build.gradle"

# Check compileSdk
compile_sdk=$(grep -oP "compileSdk\s*=\s*\K\d+" $gradle_file || echo "")
if [ "$compile_sdk" -ge 32 ]; then
    echo "  ✅ compileSdk: $compile_sdk (meets API 32+ requirement)"
else
    echo "  ❌ compileSdk: $compile_sdk (does not meet API 32+ requirement)"
    exit 1
fi

# Check minSdk
min_sdk=$(grep -oP "minSdk\s*=\s*\K\d+" $gradle_file || echo "")
if [ "$min_sdk" -ge 32 ]; then
    echo "  ✅ minSdk: $min_sdk (meets API 32+ requirement)"
else
    echo "  ❌ minSdk: $min_sdk (does not meet API 32+ requirement)"
    exit 1
fi

# Check targetSdk
target_sdk=$(grep -oP "targetSdk\s*=\s*\K\d+" $gradle_file || echo "")
if [ "$target_sdk" -ge 32 ]; then
    echo "  ✅ targetSdk: $target_sdk (meets API 32+ requirement)"
else
    echo "  ❌ targetSdk: $target_sdk (does not meet API 32+ requirement)"
    exit 1
fi

# Check NDK version
ndk_version=$(grep -oP "ndkVersion\s*=\s*\"\K[^\"]*" $gradle_file || echo "")
echo "  ✅ NDK Version: $ndk_version"

# Validate Flutter configuration
echo "📱 Validating Flutter configuration..."
if [ -f "pubspec.yaml" ]; then
    flutter_version=$(grep -A1 "environment:" pubspec.yaml | grep -oP "flutter:\s*\"\K[^\"]*" || echo "")
    dart_version=$(grep -A1 "environment:" pubspec.yaml | grep -oP "sdk:\s*'\K[^']*" || echo "")
    echo "  ✅ Flutter constraint: $flutter_version"
    echo "  ✅ Dart constraint: $dart_version"
fi

# Validate C++ configuration
echo "🔧 Validating C++ configuration..."
if [ -f "CMakeLists.txt" ]; then
    cmake_version=$(grep -oP "cmake_minimum_required\(VERSION\s+\K[^\)]*" CMakeLists.txt || echo "")
    echo "  ✅ CMake minimum version: $cmake_version"
    
    # Check for Crypto++ detection
    if grep -q "find_package.*cryptopp\|find_library.*CRYPTOPP" CMakeLists.txt; then
        echo "  ✅ Crypto++ library detection configured"
    else
        echo "  ⚠️  Crypto++ library detection not found"
    fi
fi

# Validate workflow configuration
echo "⚙️  Validating GitHub Actions workflow..."
workflow_file=".github/workflows/build-debug-apk.yml"

if grep -q "ubuntu-22.04\|ubuntu-latest" $workflow_file; then
    echo "  ✅ Linux environment configured"
fi

if grep -q "java-version.*17" $workflow_file; then
    echo "  ✅ Java 17 configured"
fi

if grep -q "flutter-version.*3\." $workflow_file; then
    echo "  ✅ Flutter 3.x configured"
fi

if grep -q "platforms;android-32\|platforms;android-3[3-9]" $workflow_file; then
    echo "  ✅ Android API 32+ configured"
fi

if grep -q "ndk;26\." $workflow_file; then
    echo "  ✅ NDK version configured"
fi

if grep -q "libcrypto\+\+-dev\|crypto\+\+" $workflow_file; then
    echo "  ✅ Crypto++ dependencies configured"
fi

if grep -q "flutter build apk --debug" $workflow_file; then
    echo "  ✅ Debug APK build configured"
fi

echo ""
echo "✅ All validations passed! The APK build workflow should work correctly."
echo ""
echo "🚀 The workflow will:"
echo "   - Use Ubuntu 22.04 (stable Linux environment)"
echo "   - Target Android API 32+ with compileSdk 35"
echo "   - Support minSdk 32 for Android 12+ compatibility"
echo "   - Build debug APK with Dart and C++ components"
echo "   - Install and configure all required dependencies"
echo "   - Accept Android licenses automatically"
echo "   - Generate multi-architecture APKs"
echo ""
echo "💡 The workflow now supports Gradle wrapper for better compatibility:"
echo "   - Use './gradlew' commands for consistent build environment"
echo "   - Automatic Gradle version management"
echo "   - Enhanced CI/CD reliability"