#!/bin/bash
# Validation script for crypto_bridge implementation

set -e

echo "🔐 Crypto Bridge Validation Script"
echo "=================================="

# Change to project directory
cd "$(dirname "$0")"

# Check that Crypto++ is installed
echo "📦 Checking Crypto++ installation..."
if pkg-config --exists libcrypto++; then
    echo "✓ Crypto++ development libraries found"
    pkg-config --modversion libcrypto++
else
    echo "ℹ  Using system Crypto++ library"
fi

# Build the project
echo ""
echo "🔨 Building project..."
cd build 2>/dev/null || (mkdir -p build && cd build)
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j$(nproc)

# Verify shared library was created
echo ""
echo "📚 Checking generated library..."
if [ -f "lib/libcrypting.so" ]; then
    echo "✓ Shared library created: lib/libcrypting.so"
    ls -lh lib/libcrypting.so
else
    echo "❌ Shared library not found!"
    exit 1
fi

# Check exported symbols
echo ""
echo "🔍 Checking exported symbols..."
SYMBOLS=$(nm -D lib/libcrypting.so | grep -E "(crypto_bridge|encrypt_data|get_version)" | wc -l)
if [ "$SYMBOLS" -ge 4 ]; then
    echo "✓ Found $SYMBOLS crypto symbols:"
    nm -D lib/libcrypting.so | grep -E "(crypto_bridge|encrypt_data|get_version)" | head -5
else
    echo "❌ Missing expected symbols!"
    exit 1
fi

# Run basic functionality test
echo ""
echo "🧪 Running functionality tests..."
if [ -f "crypto_bridge_test" ]; then
    echo "Running basic crypto bridge test..."
    LD_LIBRARY_PATH=./lib ./crypto_bridge_test
else
    echo "⚠  Test executable not found, compiling test..."
    g++ -std=c++11 -I../include /tmp/crypto_bridge_test.cpp -L./lib -lcrypting -lcryptopp -o crypto_bridge_test
    echo "Running basic test..."
    LD_LIBRARY_PATH=./lib ./crypto_bridge_test
fi

# Run comprehensive test if available
echo ""
echo "🔬 Running comprehensive algorithm tests..."
if [ -f "comprehensive_test" ]; then
    LD_LIBRARY_PATH=./lib ./comprehensive_test
else
    echo "Compiling comprehensive test..."
    g++ -std=c++11 -I../include /tmp/comprehensive_test.cpp -L./lib -lcrypting -lcryptopp -o comprehensive_test
    echo "Running comprehensive test..."
    LD_LIBRARY_PATH=./lib ./comprehensive_test
fi

# Summary
echo ""
echo "✅ All validation tests passed!"
echo ""
echo "📋 Implementation Summary:"
echo "  • Single file: src/crypto_bridge.cpp"
echo "  • Algorithms: AES, Serpent, Twofish, RC6, Blowfish, CAST-128"
echo "  • Modes: CBC, GCM, ECB, CFB, OFB, CTR"
echo "  • Exception-safe FFI interface"
echo "  • Hardcoded algorithm support (no factories)"
echo "  • PBKDF2 key derivation"
echo "  • Comprehensive error handling"
echo ""
echo "🔗 Integration:"
echo "  • FFI-compatible C interface"
echo "  • Status code based error handling"
echo "  • Flutter integration ready"
echo "  • Cross-platform shared library"

cd ..
echo ""
echo "📁 Generated files:"
echo "  • src/crypto_bridge.cpp (44KB+ comprehensive implementation)"
echo "  • include/crypto_bridge.h (header file)"
echo "  • build/lib/libcrypting.so (shared library)"
echo "  • CRYPTO_BRIDGE.md (integration documentation)"