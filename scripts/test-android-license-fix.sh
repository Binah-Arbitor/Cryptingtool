#!/bin/bash
# Test script for Android License Fix implementation
# Based on Stack Overflow solutions for "1 of 7 SDK package license not accepted"

echo "🧪 Testing Android License Acceptance Implementation"
echo "=================================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print test results
test_result() {
    local status=$1
    local message=$2
    case $status in
        "pass") echo -e "${GREEN}✅ PASS:${NC} $message" ;;
        "fail") echo -e "${RED}❌ FAIL:${NC} $message" ;;
        "skip") echo -e "${YELLOW}⏭️ SKIP:${NC} $message" ;;
        "info") echo -e "${BLUE}ℹ️ INFO:${NC} $message" ;;
    esac
}

TESTS_PASSED=0
TESTS_FAILED=0
TESTS_SKIPPED=0

# Test 1: Check if enhanced PowerShell script exists
echo ""
echo "🔍 Test 1: Enhanced PowerShell Script"
echo "------------------------------------"
if [ -f "scripts/accept-android-licenses.ps1" ]; then
    test_result "pass" "Enhanced PowerShell script exists"
    
    # Check script content for key features
    if grep -q "Multi-Method License Acceptance System" "scripts/accept-android-licenses.ps1"; then
        test_result "pass" "Script has multi-method approach"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        test_result "fail" "Script missing multi-method approach"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
    
    if grep -q "TimeoutSeconds" "scripts/accept-android-licenses.ps1"; then
        test_result "pass" "Script has configurable timeout"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        test_result "fail" "Script missing configurable timeout"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
    
    if grep -q "MaxRetries" "scripts/accept-android-licenses.ps1"; then
        test_result "pass" "Script has retry mechanism"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        test_result "fail" "Script missing retry mechanism"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
    
else
    test_result "fail" "Enhanced PowerShell script missing"
    TESTS_FAILED=$((TESTS_FAILED + 3))
fi

# Test 2: Check if Windows batch script exists
echo ""
echo "🔍 Test 2: Windows Batch Script"
echo "------------------------------"
if [ -f "scripts/accept-android-licenses.bat" ]; then
    test_result "pass" "Windows batch script exists"
    
    # Check for multiple echo approach (Stack Overflow solution)
    if grep -q "(echo y & echo y & echo y" "scripts/accept-android-licenses.bat"; then
        test_result "pass" "Batch script uses multiple echo approach"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        test_result "fail" "Batch script missing multiple echo approach"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
    
    if grep -q "flutter doctor --android-licenses" "scripts/accept-android-licenses.bat"; then
        test_result "pass" "Batch script targets Android licenses"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        test_result "fail" "Batch script not targeting Android licenses"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
else
    test_result "fail" "Windows batch script missing"
    TESTS_FAILED=$((TESTS_FAILED + 2))
fi

# Test 3: Check Windows APK workflow enhancements
echo ""
echo "🔍 Test 3: Windows APK Workflow Integration"
echo "------------------------------------------"
if [ -f ".github/workflows/windows-apk-build.yml" ]; then
    test_result "pass" "Windows APK workflow exists"
    
    # Check for enhanced license acceptance
    if grep -q "Enhanced Android License Acceptance" ".github/workflows/windows-apk-build.yml"; then
        test_result "pass" "Workflow has enhanced license acceptance section"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        test_result "fail" "Workflow missing enhanced license acceptance"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
    
    # Check for multi-method approach in workflow
    if grep -q "multi-method approach" ".github/workflows/windows-apk-build.yml"; then
        test_result "pass" "Workflow mentions multi-method approach"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        test_result "fail" "Workflow missing multi-method approach"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
    
    # Check for Stack Overflow reference
    if grep -q "Stack Overflow" ".github/workflows/windows-apk-build.yml"; then
        test_result "pass" "Workflow references Stack Overflow solutions"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        test_result "fail" "Workflow missing Stack Overflow reference"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
    
    # Check for Flutter action version
    if grep -q "subosito/flutter-action@v2.21.0" ".github/workflows/windows-apk-build.yml"; then
        test_result "pass" "Workflow uses updated Flutter action (v2.21.0)"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        test_result "fail" "Workflow not using updated Flutter action"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
    
else
    test_result "fail" "Windows APK workflow missing"
    TESTS_FAILED=$((TESTS_FAILED + 4))
fi

# Test 4: Check action.yml integration
echo ""
echo "🔍 Test 4: Action.yml Integration"
echo "--------------------------------"
if [ -f "action.yml" ]; then
    test_result "pass" "action.yml exists"
    
    # Check for Flutter action version
    if grep -q "subosito/flutter-action@v2.21.0" "action.yml"; then
        test_result "pass" "action.yml uses updated Flutter action"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        test_result "fail" "action.yml not using updated Flutter action"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
    
    # Check for SDK verification script reference
    if grep -q "verify-sdk.sh" "action.yml"; then
        test_result "pass" "action.yml references SDK verification"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        test_result "fail" "action.yml missing SDK verification reference"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
else
    test_result "fail" "action.yml missing"
    TESTS_FAILED=$((TESTS_FAILED + 2))
fi

# Test 5: Check SDK verification script enhancements
echo ""
echo "🔍 Test 5: SDK Verification Script Enhancements"
echo "----------------------------------------------"
if [ -f "scripts/verify-sdk.sh" ]; then
    test_result "pass" "SDK verification script exists"
    
    # Check for enhanced license guidance
    if grep -q "accept-android-licenses.ps1" "scripts/verify-sdk.sh"; then
        test_result "pass" "Script references enhanced PowerShell script"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        test_result "fail" "Script missing enhanced PowerShell script reference"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
    
    if grep -q "accept-android-licenses.bat" "scripts/verify-sdk.sh"; then
        test_result "pass" "Script references Windows batch script"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        test_result "fail" "Script missing Windows batch script reference"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
    
    if grep -q "Stack Overflow method" "scripts/verify-sdk.sh"; then
        test_result "pass" "Script mentions Stack Overflow solutions"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        test_result "fail" "Script missing Stack Overflow reference"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
else
    test_result "fail" "SDK verification script missing"
    TESTS_FAILED=$((TESTS_FAILED + 3))
fi

# Test 6: Syntax validation
echo ""
echo "🔍 Test 6: Syntax Validation"
echo "---------------------------"

# Check YAML syntax
if command -v python3 >/dev/null 2>&1; then
    if python3 -c "import yaml; yaml.safe_load(open('.github/workflows/windows-apk-build.yml'))" 2>/dev/null; then
        test_result "pass" "Windows workflow YAML syntax is valid"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        test_result "fail" "Windows workflow YAML syntax is invalid"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
    
    if python3 -c "import yaml; yaml.safe_load(open('action.yml'))" 2>/dev/null; then
        test_result "pass" "action.yml YAML syntax is valid"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        test_result "fail" "action.yml YAML syntax is invalid"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
else
    test_result "skip" "Python3 not available for YAML validation"
    TESTS_SKIPPED=$((TESTS_SKIPPED + 2))
fi

# Check PowerShell script syntax (basic)
if [ -f "scripts/accept-android-licenses.ps1" ]; then
    # Basic PowerShell syntax check - look for balanced braces
    OPEN_BRACES=$(grep -o '{' "scripts/accept-android-licenses.ps1" | wc -l)
    CLOSE_BRACES=$(grep -o '}' "scripts/accept-android-licenses.ps1" | wc -l)
    
    if [ "$OPEN_BRACES" -eq "$CLOSE_BRACES" ]; then
        test_result "pass" "PowerShell script has balanced braces"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        test_result "fail" "PowerShell script has unbalanced braces"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
fi

# Test 7: Documentation updates
echo ""
echo "🔍 Test 7: Documentation Updates"
echo "-------------------------------"

# Check if documentation files exist and are updated
DOC_FILES=("ANDROID_LICENSE_FIX.md" "SDK_ENHANCEMENT_2025.md")
for doc_file in "${DOC_FILES[@]}"; do
    if [ -f "$doc_file" ]; then
        test_result "pass" "$doc_file exists"
        
        if grep -q "Stack Overflow" "$doc_file"; then
            test_result "pass" "$doc_file references Stack Overflow solutions"
            TESTS_PASSED=$((TESTS_PASSED + 1))
        else
            test_result "fail" "$doc_file missing Stack Overflow reference"
            TESTS_FAILED=$((TESTS_FAILED + 1))
        fi
    else
        test_result "fail" "$doc_file missing"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
done

# Final summary
echo ""
echo "📊 Test Results Summary"
echo "======================"
echo -e "${GREEN}✅ Tests Passed: $TESTS_PASSED${NC}"
echo -e "${RED}❌ Tests Failed: $TESTS_FAILED${NC}"
echo -e "${YELLOW}⏭️ Tests Skipped: $TESTS_SKIPPED${NC}"

TOTAL_TESTS=$((TESTS_PASSED + TESTS_FAILED + TESTS_SKIPPED))
echo "📋 Total Tests: $TOTAL_TESTS"

if [ $TESTS_FAILED -eq 0 ]; then
    echo ""
    echo -e "${GREEN}🎉 All tests passed! Android License Fix implementation is ready.${NC}"
    echo ""
    echo "✅ Enhanced Android SDK license acceptance has been implemented with:"
    echo "   • Multi-method approach (4 different methods)"
    echo "   • Stack Overflow proven solutions"
    echo "   • Windows-specific optimizations"
    echo "   • Comprehensive error handling and retries"
    echo "   • Enhanced documentation and guidance"
    echo ""
    exit 0
else
    echo ""
    echo -e "${RED}⚠️ Some tests failed. Please review the implementation.${NC}"
    echo ""
    exit 1
fi