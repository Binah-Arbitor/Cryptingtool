#!/bin/bash

echo "🔍 CryptingTool Component Setup Validation"
echo "========================================="
echo ""

# Exit codes
SUCCESS=0
WARNING=1
ERROR=2

exit_code=$SUCCESS

# Test counter
tests_passed=0
tests_total=0

# Function to run a test
run_test() {
    local test_name="$1"
    local test_command="$2"
    local expected_exit_code="${3:-0}"
    
    tests_total=$((tests_total + 1))
    echo "🧪 Test $tests_total: $test_name"
    
    if eval "$test_command" >/dev/null 2>&1; then
        echo "   ✅ PASSED"
        tests_passed=$((tests_passed + 1))
    else
        echo "   ❌ FAILED"
        exit_code=$ERROR
    fi
}

# Test script syntax validation
echo "📋 Phase 1: Script Syntax Validation"
echo "======================================"
run_test "verify-crypto.sh syntax" "bash -n scripts/verify-crypto.sh"
run_test "troubleshoot.sh syntax" "bash -n scripts/troubleshoot.sh"
run_test "test-libraries.sh syntax" "bash -n scripts/test-libraries.sh"
run_test "validate_apk_build.sh syntax" "bash -n scripts/validate_apk_build.sh"
echo ""

# Test CMakeLists.txt validation
echo "📋 Phase 2: CMakeLists.txt Validation"
echo "======================================"
run_test "Main CMakeLists.txt exists" "test -f CMakeLists.txt"
run_test "Android CMakeLists.txt exists" "test -f android/app/src/main/cpp/CMakeLists.txt"
echo ""

# Test C++ build capability
echo "📋 Phase 3: Build System Tests"
echo "==============================="
run_test "Build directory exists" "test -d build"
run_test "Library files exist" "test -f build/lib/libcrypting.so && test -f build/lib/libcrypting.a"
echo ""

# Test dependency detection
echo "📋 Phase 4: Dependency Detection"
echo "================================="
run_test "Crypto++ detection" "pkg-config --exists libcrypto++"
run_test "CMake availability" "command -v cmake"
run_test "Build tools availability" "command -v make && command -v gcc"
echo ""

# Test validation scripts
echo "📋 Phase 5: Validation Scripts"
echo "==============================="
run_test "Crypto verification script" "./scripts/verify-crypto.sh"
run_test "Troubleshooting script" "./scripts/troubleshoot.sh"
run_test "Library testing script" "./scripts/test-libraries.sh"
echo ""

# Test project structure
echo "📋 Phase 6: Project Structure"
echo "============================="
run_test "Source files exist" "test -f src/crypting.cpp && test -f src/crypto_bridge.cpp"
run_test "Include directory exists" "test -d include"
run_test "Flutter lib directory exists" "test -d lib"
run_test "Android structure exists" "test -f android/app/build.gradle"
run_test "GitHub workflow exists" "test -f .github/workflows/build-debug-apk.yml"
echo ""

# Summary
echo "📊 VALIDATION SUMMARY"
echo "====================="
echo "Tests passed: $tests_passed/$tests_total"

if [ $tests_passed -eq $tests_total ]; then
    echo "🎉 ✅ ALL TESTS PASSED! Component setup is fully functional."
    exit_code=$SUCCESS
elif [ $tests_passed -gt $((tests_total * 3 / 4)) ]; then
    echo "⚠️  Most tests passed, but some issues need attention."
    exit_code=$WARNING
else
    echo "❌ Multiple tests failed. Component setup needs fixes."
    exit_code=$ERROR
fi

echo ""
echo "🚀 Setup Status: $([ $exit_code -eq $SUCCESS ] && echo "READY FOR DEVELOPMENT" || echo "NEEDS ATTENTION")"

exit $exit_code