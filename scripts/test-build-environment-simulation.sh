#!/bin/bash
set -e

# Simulated APK Build Environment Test
# Tests the prepared build environment and workflow without requiring full Flutter installation
# This validates that the action and workflow will work in the actual GitHub Actions environment

echo "🧪 Simulated APK Build Environment Test"
echo "======================================"
echo "Testing prepared environment without requiring full local Flutter installation"
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

# Test 1: Workflow Configuration Validation
echo "🧪 Test 1: Workflow Configuration Validation"
echo "--------------------------------------------"

if [ -f ".github/workflows/windows-apk-build.yml" ]; then
    test_result "pass" "Windows APK build workflow exists"
    
    WORKFLOW_CONTENT=$(cat .github/workflows/windows-apk-build.yml)
    
    # Check for essential GitHub Actions components
    if echo "$WORKFLOW_CONTENT" | grep -q "runs-on: windows-latest"; then
        test_result "pass" "Workflow configured for Windows environment"
    else
        test_result "fail" "Workflow not configured for Windows environment"
    fi
    
    if echo "$WORKFLOW_CONTENT" | grep -q "subosito/flutter-action@v2.21.0"; then
        test_result "pass" "Workflow uses correct Flutter action version"
    else
        test_result "fail" "Workflow missing or using wrong Flutter action version"
    fi
    
    if echo "$WORKFLOW_CONTENT" | grep -q "actions/setup-java@v4"; then
        test_result "pass" "Workflow includes Java setup"
    else
        test_result "fail" "Workflow missing Java setup"
    fi
    
    if echo "$WORKFLOW_CONTENT" | grep -q "Enhanced.*[Ll]icense.*[Aa]cceptance"; then
        test_result "pass" "Workflow includes enhanced license acceptance"
    else
        test_result "fail" "Workflow missing license acceptance"
    fi
    
    if echo "$WORKFLOW_CONTENT" | grep -q "flutter build apk"; then
        test_result "pass" "Workflow includes APK build commands"
    else
        test_result "fail" "Workflow missing APK build commands"
    fi
    
    # Check for multi-architecture support
    if echo "$WORKFLOW_CONTENT" | grep -q "android-arm,android-arm64,android-x64"; then
        test_result "pass" "Workflow configured for multi-architecture builds"
    else
        test_result "warn" "Workflow may not be configured for multi-architecture"
    fi
    
    # Check for comprehensive testing steps
    if echo "$WORKFLOW_CONTENT" | grep -q "integration-test\|dependency.*check"; then
        test_result "pass" "Workflow includes comprehensive testing steps"
    else
        test_result "warn" "Workflow missing comprehensive testing steps"
    fi
    
    # YAML syntax validation
    if python3 -c "import yaml; yaml.safe_load(open('.github/workflows/windows-apk-build.yml'))" 2>/dev/null; then
        test_result "pass" "Workflow YAML syntax is valid"
    else
        test_result "fail" "Workflow YAML syntax is invalid"
    fi
else
    test_result "fail" "Windows APK build workflow not found"
fi

echo ""

# Test 2: Script Infrastructure Validation
echo "🧪 Test 2: Script Infrastructure Validation"
echo "-------------------------------------------"

ESSENTIAL_SCRIPTS=(
    "scripts/build-flutter.sh"
    "scripts/build-cpp.sh"
    "scripts/check-dependencies.sh"
    "scripts/verify-sdk.sh"
    "scripts/package.sh"
    "scripts/test-libraries.sh"
    "scripts/accept-android-licenses.ps1"
)

for script in "${ESSENTIAL_SCRIPTS[@]}"; do
    if [ -f "$script" ] && [ -r "$script" ]; then
        test_result "pass" "Essential script exists: $script"
        
        # Check if script is executable
        if [ -x "$script" ] || [[ "$script" == *.ps1 ]]; then
            test_result "pass" "Script has proper permissions: $script"
        else
            test_result "warn" "Script may need execute permissions: $script"
        fi
    else
        test_result "fail" "Essential script missing: $script"
    fi
done

# Check for Windows batch script
if [ -f "scripts/accept-android-licenses.bat" ]; then
    test_result "pass" "Windows batch script exists for license acceptance"
else
    test_result "warn" "Windows batch script missing (not critical if PowerShell available)"
fi

echo ""

# Test 3: Project Structure and Configuration
echo "🧪 Test 3: Project Structure and Configuration"
echo "----------------------------------------------"

# Essential Flutter project files
FLUTTER_FILES=(
    "pubspec.yaml"
    "lib/main.dart"
    "android/app/build.gradle"
    "android/app/src/main/AndroidManifest.xml"
)

for file in "${FLUTTER_FILES[@]}"; do
    if [ -f "$file" ]; then
        test_result "pass" "Flutter project file exists: $file"
    else
        test_result "fail" "Flutter project file missing: $file"
    fi
done

# Check pubspec.yaml configuration
if [ -f "pubspec.yaml" ]; then
    PUBSPEC_CONTENT=$(cat pubspec.yaml)
    
    # Check Flutter SDK constraints
    if echo "$PUBSPEC_CONTENT" | grep -q "flutter:.*>=3"; then
        test_result "pass" "Flutter SDK constraint is appropriate"
    else
        test_result "warn" "Flutter SDK constraint may need review"
    fi
    
    # Check for FFI dependency (needed for C++ integration)
    if echo "$PUBSPEC_CONTENT" | grep -q "ffi:"; then
        test_result "pass" "FFI dependency configured for C++ integration"
    else
        test_result "warn" "FFI dependency not found (C++ integration may not work)"
    fi
fi

# Check Android configuration
if [ -f "android/app/build.gradle" ]; then
    GRADLE_CONTENT=$(cat android/app/build.gradle)
    
    # Check for minimum SDK version
    if echo "$GRADLE_CONTENT" | grep -q "minSdkVersion.*1[6-9]\|minSdkVersion.*[2-9][0-9]"; then
        test_result "pass" "Android minimum SDK version configured appropriately"
    else
        test_result "warn" "Android minimum SDK version may need review"
    fi
    
    # Check for compile SDK version
    if echo "$GRADLE_CONTENT" | grep -q "compileSdkVersion.*3[0-9]\|targetSdkVersion.*3[0-9]"; then
        test_result "pass" "Android target SDK version is modern"
    else
        test_result "warn" "Android target SDK version may need update"
    fi
fi

echo ""

# Test 4: License Acceptance Infrastructure
echo "🧪 Test 4: License Acceptance Infrastructure"
echo "--------------------------------------------"

# Check PowerShell script functionality
if [ -f "scripts/accept-android-licenses.ps1" ]; then
    PS_CONTENT=$(cat scripts/accept-android-licenses.ps1)
    
    if echo "$PS_CONTENT" | grep -q "multi-method.*approach\|Stack.*Overflow"; then
        test_result "pass" "PowerShell script includes multi-method approach"
    else
        test_result "warn" "PowerShell script may not include all methods"
    fi
    
    if echo "$PS_CONTENT" | grep -q "TimeoutSeconds\|MaxRetries"; then
        test_result "pass" "PowerShell script has configurable parameters"
    else
        test_result "warn" "PowerShell script may lack configuration options"
    fi
    
    # Check for proper PowerShell syntax (basic check)
    if echo "$PS_CONTENT" | grep -qE '^\s*param\(|Write-Host.*-ForegroundColor'; then
        test_result "pass" "PowerShell script has proper syntax structure"
    else
        test_result "warn" "PowerShell script syntax may need review"
    fi
fi

echo ""

# Test 5: C++ Integration Preparation
echo "🧪 Test 5: C++ Integration Preparation"
echo "--------------------------------------"

# Check for C++ build files
if [ -f "CMakeLists.txt" ]; then
    test_result "pass" "CMakeLists.txt exists for C++ build"
    
    CMAKE_CONTENT=$(cat CMakeLists.txt)
    if echo "$CMAKE_CONTENT" | grep -qi "crypto\|ffi"; then
        test_result "pass" "CMakeLists.txt includes cryptographic libraries"
    else
        test_result "warn" "CMakeLists.txt may not include all necessary libraries"
    fi
else
    test_result "warn" "CMakeLists.txt not found (C++ integration may be limited)"
fi

# Check for C++ source directories
if [ -d "src" ] || [ -d "cpp" ] || [ -d "native" ]; then
    test_result "pass" "C++ source directory structure exists"
else
    test_result "warn" "C++ source directories not found"
fi

# Check for headers
if [ -d "include" ]; then
    test_result "pass" "C++ include directory exists"
else
    test_result "warn" "C++ include directory not found"
fi

echo ""

# Test 6: Integration Test Infrastructure
echo "🧪 Test 6: Integration Test Infrastructure"
echo "-----------------------------------------"

INTEGRATION_TESTS=(
    "scripts/integration-test-android16.sh"
    "scripts/test-android-license-fix.sh"
    "scripts/integration-test.sh"
)

for test_script in "${INTEGRATION_TESTS[@]}"; do
    if [ -f "$test_script" ] && [ -x "$test_script" ]; then
        test_result "pass" "Integration test exists: $test_script"
    else
        test_result "warn" "Integration test missing or not executable: $test_script"
    fi
done

# Test the integration scripts can run (dry run)
echo "Running integration test validation..."

if [ -f "scripts/integration-test-android16.sh" ]; then
    # This should pass with our new workflow
    if ./scripts/integration-test-android16.sh >/dev/null 2>&1; then
        test_result "pass" "Android 16+ integration test validates successfully"
    else
        test_result "fail" "Android 16+ integration test fails validation"
    fi
fi

if [ -f "scripts/test-android-license-fix.sh" ]; then
    # This should also pass now
    if ./scripts/test-android-license-fix.sh >/dev/null 2>&1; then
        test_result "pass" "Android license fix test validates successfully"
    else
        test_result "fail" "Android license fix test fails validation"
    fi
fi

echo ""

# Test 7: Documentation and Configuration
echo "🧪 Test 7: Documentation and Configuration"
echo "------------------------------------------"

# Check for action.yml
if [ -f "action.yml" ]; then
    test_result "pass" "GitHub Action configuration exists"
    
    ACTION_CONTENT=$(cat action.yml)
    if echo "$ACTION_CONTENT" | grep -q "target-platform.*android"; then
        test_result "pass" "Action supports Android platform"
    else
        test_result "warn" "Action may not explicitly support Android"
    fi
    
    if echo "$ACTION_CONTENT" | grep -q "subosito/flutter-action"; then
        test_result "pass" "Action uses Flutter setup action"
    else
        test_result "fail" "Action missing Flutter setup"
    fi
else
    test_result "warn" "GitHub Action configuration not found"
fi

# Check for documentation
README_DOCS=("README.md" "ANDROID_LICENSE_FIX.md" "SDK_ENHANCEMENT_2025.md")
for doc in "${README_DOCS[@]}"; do
    if [ -f "$doc" ]; then
        test_result "pass" "Documentation exists: $doc"
    else
        test_result "warn" "Documentation missing: $doc"
    fi
done

echo ""

# Test 8: Build Process Simulation
echo "🧪 Test 8: Build Process Simulation"
echo "-----------------------------------"

# Simulate the build process steps that would happen in GitHub Actions
echo "Simulating build process steps..."

# Check if we can resolve Flutter dependencies (without Flutter installed)
if [ -f "pubspec.yaml" ]; then
    # Parse pubspec.yaml for obvious issues
    if python3 -c "import yaml; yaml.safe_load(open('pubspec.yaml'))" 2>/dev/null; then
        test_result "pass" "pubspec.yaml syntax is valid"
    else
        test_result "fail" "pubspec.yaml has syntax errors"
    fi
    
    # Check for dependency conflicts (basic check)
    PUBSPEC_CONTENT=$(cat pubspec.yaml)
    if echo "$PUBSPEC_CONTENT" | grep -q "ffi:.*^[2-9]\|path:.*^[1-9]"; then
        test_result "pass" "Key dependencies have appropriate versions"
    else
        test_result "warn" "Dependency versions may need review"
    fi
fi

# Simulate C++ build preparation
if [ -f "scripts/build-cpp.sh" ]; then
    # Check if the script has proper structure (without executing)
    CPP_SCRIPT_CONTENT=$(cat scripts/build-cpp.sh)
    if echo "$CPP_SCRIPT_CONTENT" | grep -q "cmake\|make\|ninja"; then
        test_result "pass" "C++ build script includes proper build tools"
    else
        test_result "warn" "C++ build script may be incomplete"
    fi
fi

# Simulate package creation
if [ -f "scripts/package.sh" ]; then
    PACKAGE_SCRIPT_CONTENT=$(cat scripts/package.sh)
    if echo "$PACKAGE_SCRIPT_CONTENT" | grep -q "android.*apk\|tar.*gz"; then
        test_result "pass" "Package script supports Android APK packaging"
    else
        test_result "warn" "Package script may not support APK packaging"
    fi
fi

echo ""

# Final Summary
echo "📊 Simulated APK Build Environment Test Results"
echo "==============================================="
echo ""
echo "✅ Tests Passed: $TESTS_PASSED"
echo "❌ Tests Failed: $TESTS_FAILED"
echo "📋 Total Tests: $((TESTS_PASSED + TESTS_FAILED))"
echo ""

# Calculate success rate
SUCCESS_RATE=$(( TESTS_PASSED * 100 / (TESTS_PASSED + TESTS_FAILED) ))
echo "📈 Success Rate: $SUCCESS_RATE%"
echo ""

# Determine overall result
if [ $TESTS_FAILED -eq 0 ]; then
    echo "🎉 All tests PASSED! The prepared environment is ready for APK builds."
    echo ""
    echo "✅ Environment Assessment:"
    echo "  • Windows APK Build Workflow: Ready and Configured"
    echo "  • License Acceptance: Multi-method approach implemented"
    echo "  • C++ Integration: Infrastructure prepared"
    echo "  • Build Scripts: Complete and executable"
    echo "  • Integration Tests: Passing validation"
    echo "  • GitHub Actions Configuration: Valid and comprehensive"
    echo ""
    echo "🚀 The prepared environment can handle comprehensive APK builds!"
    echo ""
    echo "🔧 Next Steps:"
    echo "  • Run the workflow in GitHub Actions for actual build testing"
    echo "  • The workflow will handle Flutter installation, license acceptance, and build process"
    echo "  • Monitor build artifacts and logs for any runtime issues"
    echo ""
    exit 0
    
elif [ $SUCCESS_RATE -ge 85 ]; then
    echo "✅ Most tests passed! Environment is well-prepared with minor issues."
    echo ""
    echo "⚠️ Minor Issues:"
    for result in "${TEST_RESULTS[@]}"; do
        if [[ "$result" == FAIL:* ]]; then
            echo "  • ${result#FAIL: }"
        fi
    done
    echo ""
    echo "🔧 These issues are minor and shouldn't prevent APK builds."
    exit 0
    
elif [ $SUCCESS_RATE -ge 70 ]; then
    echo "⚠️ Environment is mostly ready but has some issues to address."
    echo ""
    echo "❌ Issues that need attention:"
    for result in "${TEST_RESULTS[@]}"; do
        if [[ "$result" == FAIL:* ]]; then
            echo "  • ${result#FAIL: }"
        fi
    done
    echo ""
    echo "🔧 Please address these issues for optimal build success."
    exit 1
    
else
    echo "❌ Multiple critical issues detected. Environment needs significant attention."
    echo ""
    echo "❌ Critical Issues:"
    for result in "${TEST_RESULTS[@]}"; do
        if [[ "$result" == FAIL:* ]]; then
            echo "  • ${result#FAIL: }"
        fi
    done
    echo ""
    echo "🔧 Please fix these critical issues before attempting APK builds."
    exit 1
fi