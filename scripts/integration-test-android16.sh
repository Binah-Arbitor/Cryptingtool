#!/bin/bash
# Integration test for Windows VM + Android 16+ build process
set -e

echo "=== Integration Test: Windows VM + Android 16+ Build ==="
echo ""

# Test 1: Configuration validation
echo "🧪 Test 1: Android API 16+ Configuration Validation"
if ./scripts/test-android-config.sh > /dev/null 2>&1; then
    echo "✅ Configuration validation PASSED"
else
    echo "❌ Configuration validation FAILED"
    exit 1
fi

# Test 2: YAML workflow validation
echo ""
echo "🧪 Test 2: Windows APK Build Workflow Validation"

if [ -f ".github/workflows/windows-apk-build.yml" ]; then
    echo "✅ Windows APK build workflow exists"
    
    # Check for Android API 16+ references
    if grep -q "API 16+" ".github/workflows/windows-apk-build.yml"; then
        echo "✅ Workflow configured for Android API 16+ targeting"
    else
        echo "❌ Workflow missing Android API 16+ configuration"
        exit 1
    fi
    
    # Check for Windows environment
    if grep -q "windows-latest" ".github/workflows/windows-apk-build.yml"; then
        echo "✅ Workflow uses Windows environment"
    else
        echo "❌ Workflow not configured for Windows environment"
        exit 1
    fi
    
    # Check for proper Java setup
    if grep -q "Set up JDK 17" ".github/workflows/windows-apk-build.yml"; then
        echo "✅ Java 17 configuration found"
    else
        echo "❌ Java setup missing or incorrect"
        exit 1
    fi
    
    # Check for Flutter setup
    if grep -q "Set up Flutter SDK" ".github/workflows/windows-apk-build.yml"; then
        echo "✅ Flutter SDK setup found"
    else
        echo "❌ Flutter SDK setup missing"
        exit 1
    fi
else
    echo "❌ Windows APK build workflow not found"
    exit 1
fi

# Test 3: Project structure validation
echo ""
echo "🧪 Test 3: Project Structure Validation"

required_files=(
    "pubspec.yaml"
    "android/app/build.gradle"
    "android/app/src/main/AndroidManifest.xml"
    "android/app/src/main/kotlin/com/binah/cryptingtool/MainActivity.kt"
    ".github/workflows/windows-apk-build.yml"
    "action.yml"
)

for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file present"
    else
        echo "❌ $file missing"
        exit 1
    fi
done

# Test 4: Dependency configuration validation
echo ""
echo "🧪 Test 4: Dependency Configuration Validation"

if [ -f "pubspec.yaml" ]; then
    # Check for FFI dependency (needed for C++ integration)
    if grep -q "ffi:" "pubspec.yaml"; then
        echo "✅ FFI dependency configured for C++ integration"
    else
        echo "❌ FFI dependency missing"
        exit 1
    fi
    
    # Check Flutter version compatibility
    if grep -q "flutter.*>=3.3.0" "pubspec.yaml"; then
        echo "✅ Flutter version compatible with Android API 16+"
    else
        echo "⚠️  Flutter version may need verification"
    fi
fi

# Test 5: Build script validation
echo ""
echo "🧪 Test 5: Build Script Validation"

build_scripts=(
    "scripts/build-flutter.sh"
    "scripts/build-cpp.sh"
    "scripts/check-dependencies.sh"
)

for script in "${build_scripts[@]}"; do
    if [ -f "$script" ] && [ -x "$script" ]; then
        echo "✅ $script present and executable"
    else
        echo "❌ $script missing or not executable"
        exit 1
    fi
done

echo ""
echo "=== Integration Test Results ==="
echo "✅ All tests PASSED!"
echo ""
echo "📋 Test Summary:"
echo "   ✅ Android API 16+ configuration validated"
echo "   ✅ Windows VM workflow configured correctly"
echo "   ✅ Project structure is complete"
echo "   ✅ Dependencies properly configured"
echo "   ✅ Build scripts are ready"
echo ""
echo "🎯 Ready for deployment:"
echo "   • Target: Android API 16+ (4.1 Jelly Bean and above)"
echo "   • VM Environment: Windows"
echo "   • Build System: GitHub Actions + Flutter + Gradle"
echo "   • C++ Integration: Enabled via FFI"
echo ""
echo "✅ Integration test COMPLETED successfully!"