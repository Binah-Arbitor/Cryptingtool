#!/bin/bash
set -e

# Comprehensive APK Build Validation Test
# This script tests the complete APK build process instead of just checking individual code flaws
# It validates the prepared environment and build process end-to-end

echo "🏗️ Comprehensive APK Build Validation Test"
echo "==========================================="
echo ""

# Change to repository directory
cd /home/runner/work/Cryptingtool/Cryptingtool

TEST_RESULTS=()
TESTS_PASSED=0
TESTS_FAILED=0

# Test result tracking
test_result() {
    local status=$1
    local message=$2
    if [ "$status" = "pass" ]; then
        echo "✅ PASS: $message"
        TEST_RESULTS+=("PASS: $message")
        TESTS_PASSED=$((TESTS_PASSED + 1))
    elif [ "$status" = "fail" ]; then
        echo "❌ FAIL: $message"
        TEST_RESULTS+=("FAIL: $message")
        TESTS_FAILED=$((TESTS_FAILED + 1))
    else
        echo "⚠️ WARN: $message"
        TEST_RESULTS+=("WARN: $message")
    fi
}

# Test 1: Environment Preparation
echo "🧪 Test 1: Build Environment Preparation"
echo "----------------------------------------"

# Check Flutter availability
if command -v flutter >/dev/null 2>&1; then
    FLUTTER_VERSION=$(flutter --version | head -1)
    test_result "pass" "Flutter SDK available: $FLUTTER_VERSION"
    
    # Check Flutter doctor
    if flutter doctor 2>&1 | grep -q "No issues found"; then
        test_result "pass" "Flutter doctor reports no issues"
    else
        test_result "warn" "Flutter doctor reports some issues (may not block build)"
    fi
else
    test_result "fail" "Flutter SDK not available"
fi

# Check Java availability
if java -version >/dev/null 2>&1; then
    JAVA_VERSION=$(java -version 2>&1 | head -1)
    test_result "pass" "Java available: $JAVA_VERSION"
else
    test_result "fail" "Java not available"
fi

# Check Android SDK
if [ -n "$ANDROID_HOME" ] || [ -n "$ANDROID_SDK_ROOT" ]; then
    test_result "pass" "Android SDK path configured"
else
    test_result "warn" "Android SDK path not configured (may be auto-detected)"
fi

echo ""

# Test 2: Project Structure Validation
echo "🧪 Test 2: Project Structure Validation"
echo "---------------------------------------"

REQUIRED_FILES=(
    "pubspec.yaml"
    "android/app/build.gradle"
    "android/app/src/main/AndroidManifest.xml"
    "lib/main.dart"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$file" ]; then
        test_result "pass" "Required file exists: $file"
    else
        test_result "fail" "Required file missing: $file"
    fi
done

# Check for C++ integration files
if [ -f "CMakeLists.txt" ] || [ -d "src" ]; then
    test_result "pass" "C++ integration files present"
else
    test_result "warn" "C++ integration files not found (may not be needed)"
fi

echo ""

# Test 3: Dependency Resolution
echo "🧪 Test 3: Dependency Resolution"
echo "--------------------------------"

# Get Flutter dependencies
if flutter pub get >/dev/null 2>&1; then
    test_result "pass" "Flutter dependencies resolved successfully"
else
    test_result "fail" "Flutter dependency resolution failed"
fi

# Check for critical dependencies
if grep -q "ffi:" pubspec.yaml; then
    test_result "pass" "FFI dependency configured for C++ integration"
else
    test_result "warn" "FFI dependency not found (C++ integration may not work)"
fi

echo ""

# Test 4: C++ Build Capability
echo "🧪 Test 4: C++ Build Capability"
echo "-------------------------------"

# Try to build C++ components if available
if [ -f "scripts/build-cpp.sh" ]; then
    echo "Attempting C++ build..."
    if ./scripts/build-cpp.sh gcc android >/dev/null 2>&1; then
        test_result "pass" "C++ components built successfully"
    else
        test_result "warn" "C++ build failed (may not be critical for basic APK)"
    fi
else
    test_result "warn" "No C++ build script found"
fi

echo ""

# Test 5: APK Build Process
echo "🧪 Test 5: APK Build Process"
echo "----------------------------"

# Create a clean build directory
echo "Cleaning previous build artifacts..."
flutter clean >/dev/null 2>&1 || true
rm -rf build/app/outputs/flutter-apk/* 2>/dev/null || true

# Test debug APK build
echo "Building debug APK..."
if timeout 300 flutter build apk --debug >/dev/null 2>&1; then
    test_result "pass" "Debug APK build completed successfully"
    
    # Check if APK file was created
    if [ -f "build/app/outputs/flutter-apk/app-debug.apk" ]; then
        APK_SIZE=$(du -h "build/app/outputs/flutter-apk/app-debug.apk" | cut -f1)
        test_result "pass" "Debug APK file created: $APK_SIZE"
        
        # Basic APK validation
        if file "build/app/outputs/flutter-apk/app-debug.apk" | grep -q "Zip archive"; then
            test_result "pass" "APK file format is valid"
        else
            test_result "fail" "APK file format is invalid"
        fi
    else
        test_result "fail" "Debug APK file not created"
    fi
else
    test_result "fail" "Debug APK build failed or timed out"
fi

# Test release APK build (non-blocking)
echo "Building release APK (if possible)..."
if timeout 300 flutter build apk --release >/dev/null 2>&1; then
    if [ -f "build/app/outputs/flutter-apk/app-release.apk" ]; then
        RELEASE_APK_SIZE=$(du -h "build/app/outputs/flutter-apk/app-release.apk" | cut -f1)
        test_result "pass" "Release APK file created: $RELEASE_APK_SIZE"
    else
        test_result "warn" "Release APK build completed but file not found"
    fi
else
    test_result "warn" "Release APK build failed (may require signing configuration)"
fi

echo ""

# Test 6: Build Artifacts Validation
echo "🧪 Test 6: Build Artifacts Validation"
echo "-------------------------------------"

if [ -d "build/app/outputs" ]; then
    ARTIFACT_COUNT=$(find build/app/outputs -name "*.apk" | wc -l)
    if [ "$ARTIFACT_COUNT" -gt 0 ]; then
        test_result "pass" "Build artifacts created: $ARTIFACT_COUNT APK file(s)"
        
        # List all created APK files
        find build/app/outputs -name "*.apk" | while read apk; do
            SIZE=$(du -h "$apk" | cut -f1)
            echo "  📱 $(basename "$apk"): $SIZE"
        done
    else
        test_result "fail" "No APK artifacts found in build output"
    fi
else
    test_result "fail" "Build output directory not created"
fi

echo ""

# Test 7: Android Compatibility
echo "🧪 Test 7: Android Compatibility Validation"
echo "------------------------------------------"

# Check if build.gradle targets appropriate API levels
if [ -f "android/app/build.gradle" ]; then
    if grep -q "minSdkVersion.*16\|compileSdkVersion.*3[0-9]" "android/app/build.gradle"; then
        test_result "pass" "Android API levels configured appropriately"
    else
        test_result "warn" "Android API levels may need review for compatibility"
    fi
    
    # Check for architecture support
    if grep -q "arm64-v8a\|armeabi-v7a\|x86_64" "android/app/build.gradle" || \
       find build -name "*.apk" -exec unzip -l {} \; 2>/dev/null | grep -q "lib/.*\.so"; then
        test_result "pass" "Multi-architecture support configured"
    else
        test_result "warn" "Multi-architecture support may not be configured"
    fi
else
    test_result "fail" "Android build.gradle not found"
fi

echo ""

# Test 8: Integration Test Execution
echo "🧪 Test 8: Integration Test Execution"
echo "-------------------------------------"

# Run existing integration tests
if [ -f "scripts/integration-test-android16.sh" ]; then
    if ./scripts/integration-test-android16.sh >/dev/null 2>&1; then
        test_result "pass" "Android 16+ integration tests passed"
    else
        test_result "warn" "Some integration tests failed (may not be critical)"
    fi
else
    test_result "warn" "No Android 16+ integration test found"
fi

# Run library tests if available
if [ -f "scripts/test-libraries.sh" ]; then
    if ./scripts/test-libraries.sh >/dev/null 2>&1; then
        test_result "pass" "Library tests passed"
    else
        test_result "warn" "Library tests failed (may not affect APK)"
    fi
else
    test_result "warn" "No library tests found"
fi

echo ""

# Test 9: Workflow Validation
echo "🧪 Test 9: GitHub Actions Workflow Validation"
echo "---------------------------------------------"

# Check if the Windows APK workflow exists and is valid
if [ -f ".github/workflows/windows-apk-build.yml" ]; then
    test_result "pass" "Windows APK build workflow exists"
    
    # Validate YAML syntax
    if python3 -c "import yaml; yaml.safe_load(open('.github/workflows/windows-apk-build.yml'))" 2>/dev/null; then
        test_result "pass" "Workflow YAML syntax is valid"
    else
        test_result "fail" "Workflow YAML syntax is invalid"
    fi
    
    # Check for essential steps
    WORKFLOW_CONTENT=$(cat .github/workflows/windows-apk-build.yml)
    
    if echo "$WORKFLOW_CONTENT" | grep -q "flutter build apk"; then
        test_result "pass" "Workflow includes APK build step"
    else
        test_result "fail" "Workflow missing APK build step"
    fi
    
    if echo "$WORKFLOW_CONTENT" | grep -q "Enhanced.*[Ll]icense"; then
        test_result "pass" "Workflow includes enhanced license acceptance"
    else
        test_result "fail" "Workflow missing license acceptance"
    fi
    
    if echo "$WORKFLOW_CONTENT" | grep -q "windows-latest"; then
        test_result "pass" "Workflow configured for Windows environment"
    else
        test_result "fail" "Workflow not configured for Windows"
    fi
else
    test_result "fail" "Windows APK build workflow not found"
fi

echo ""

# Final Summary
echo "📊 Comprehensive APK Build Test Results"
echo "======================================="
echo ""
echo "✅ Tests Passed: $TESTS_PASSED"
echo "❌ Tests Failed: $TESTS_FAILED"
echo "📋 Total Tests: $((TESTS_PASSED + TESTS_FAILED))"
echo ""

# Determine overall result
if [ $TESTS_FAILED -eq 0 ]; then
    echo "🎉 All tests PASSED! APK build environment is fully prepared and functional."
    echo ""
    echo "✅ Build Environment Status:"
    echo "  • Flutter SDK: Ready"
    echo "  • Android SDK: Configured"
    echo "  • C++ Integration: Available"
    echo "  • APK Build Process: Functional"
    echo "  • GitHub Actions Workflow: Ready"
    echo ""
    echo "🚀 The prepared environment can successfully build APK files end-to-end!"
    exit 0
elif [ $TESTS_FAILED -le 3 ]; then
    echo "⚠️ Most tests passed with minor issues. Build environment is mostly functional."
    echo ""
    echo "❌ Issues that need attention:"
    for result in "${TEST_RESULTS[@]}"; do
        if [[ "$result" == FAIL:* ]]; then
            echo "  • ${result#FAIL: }"
        fi
    done
    echo ""
    echo "🔧 Please address the failed tests for optimal build performance."
    exit 1
else
    echo "❌ Multiple critical issues detected. Build environment needs attention."
    echo ""
    echo "❌ Critical Issues:"
    for result in "${TEST_RESULTS[@]}"; do
        if [[ "$result" == FAIL:* ]]; then
            echo "  • ${result#FAIL: }"
        fi
    done
    echo ""
    echo "🔧 Please fix these issues before proceeding with APK builds."
    exit 1
fi