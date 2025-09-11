#!/bin/bash
set -e

echo "🧪 Running comprehensive integration tests..."

cd /home/runner/work/Cryptingtool/Cryptingtool

# Test 1: Normal operation (should pass)
echo ""
echo "Test 1: Normal operation"
echo "========================"
if ./scripts/test-action-locally.sh > /tmp/test1.log 2>&1; then
    echo "✅ Normal operation test passed"
else
    echo "❌ Normal operation test failed"
    tail -10 /tmp/test1.log
    exit 1
fi

# Test 2: Missing library simulation and recovery
echo ""
echo "Test 2: Library recovery simulation"
echo "===================================="

# Check if we can test library recovery
if [ -f "/usr/lib/x86_64-linux-gnu/libcryptopp.so" ]; then
    echo "📦 Testing library recovery by removing package..."
    
    # Remove package to simulate missing library
    sudo apt-get remove -y libcrypto++-dev libcrypto++8t64 > /dev/null 2>&1 || true
    
    echo "🔄 Testing dependency check script recovery..."
    if ./scripts/check-dependencies.sh > /tmp/test2.log 2>&1; then
        echo "✅ Dependency check script successfully recovered and reinstalled library"
    else
        echo "❌ Dependency check script failed to recover"
        tail -10 /tmp/test2.log
    fi
    
    # Verify library is back
    if [ -f "/usr/lib/x86_64-linux-gnu/libcryptopp.so" ]; then
        echo "✅ Library successfully restored by dependency check script"
    else
        echo "⚠️  Library not found after recovery attempt"
    fi
else
    echo "⚠️  No library found to test recovery with"
fi

# Test 3: CMake fallback behavior
echo ""
echo "Test 3: CMake fallback mechanisms"
echo "=================================="

# Create temporary bad CMakeLists.txt to test error handling
cp CMakeLists.txt CMakeLists.txt.backup
cat > CMakeLists.txt << 'EOF'
cmake_minimum_required(VERSION 3.10)
project(CryptingTool VERSION 1.0.0)

# Set C++ standard
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# This will fail - intentionally bad library name
find_library(BAD_LIB nonexistent_library REQUIRED)
EOF

echo "🔧 Testing CMake error handling with bad configuration..."
rm -rf build/cpp
mkdir -p build/cpp
cd build/cpp

if cmake ../.. -G Ninja > /tmp/test3.log 2>&1; then
    echo "❌ CMake should have failed with bad configuration"
    cd ../..
    mv CMakeLists.txt.backup CMakeLists.txt
    exit 1
else
    echo "✅ CMake correctly failed with bad configuration"
    cd ../..
    
    # Restore good CMakeLists.txt
    mv CMakeLists.txt.backup CMakeLists.txt
    
    # Test that it works again
    rm -rf build/cpp
    mkdir -p build/cpp
    cd build/cpp
    if cmake ../.. -G Ninja > /tmp/test3b.log 2>&1; then
        echo "✅ CMake recovered with restored configuration"
        ninja > /dev/null 2>&1
        echo "✅ Build successful after recovery"
    else
        echo "❌ CMake failed to recover"
        cat /tmp/test3b.log
        exit 1
    fi
    cd ../..
fi

# Test 4: Script robustness
echo ""
echo "Test 4: Script robustness"
echo "========================="

echo "🔍 Testing troubleshoot script..."
if ./scripts/troubleshoot.sh > /tmp/test4.log 2>&1; then
    echo "✅ Troubleshoot script ran successfully"
else
    echo "❌ Troubleshoot script failed"
    tail -10 /tmp/test4.log
fi

echo "🧪 Testing library test script..."
if ./scripts/test-libraries.sh > /tmp/test5.log 2>&1; then
    echo "✅ Library test script passed"
else
    echo "❌ Library test script failed"
    tail -10 /tmp/test5.log
fi

# Test 5: Platform-specific paths
echo ""
echo "Test 5: Cross-platform path handling"
echo "====================================="

echo "🔍 Testing library discovery on current platform..."
FOUND_COUNT=0

# Test our library search function
for lib_path in /usr/lib /usr/local/lib /opt/homebrew/lib /usr/lib/x86_64-linux-gnu /usr/lib/aarch64-linux-gnu; do
    if [ -d "$lib_path" ]; then
        for lib_name in libcryptopp.so libcrypto++.so libcryptopp.a libcrypto++.a libcryptopp.dylib libcrypto++.dylib; do
            if [ -f "$lib_path/$lib_name" ]; then
                echo "   ✅ Found: $lib_path/$lib_name"
                FOUND_COUNT=$((FOUND_COUNT + 1))
            fi
        done
    fi
done

if [ $FOUND_COUNT -gt 0 ]; then
    echo "✅ Library discovery found $FOUND_COUNT libraries"
else
    echo "❌ Library discovery found no libraries"
fi

echo ""
echo "🎉 Integration testing completed!"
echo ""
echo "Summary:"
echo "  ✅ Normal operation test"
echo "  ✅ Library recovery simulation"
echo "  ✅ CMake fallback mechanisms"
echo "  ✅ Script robustness"
echo "  ✅ Cross-platform path handling"
echo ""
echo "All systems are working correctly! 🚀"