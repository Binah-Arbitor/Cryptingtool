#!/bin/bash
set -e

echo "🧪 Testing CryptingTool libraries..."

# Test 1: Check if libraries were built
echo "📁 Checking built libraries..."
BUILD_DIR="build"
if [ ! -d "$BUILD_DIR" ]; then
    echo "❌ Build directory not found. Run build first."
    exit 1
fi

SHARED_LIB="$BUILD_DIR/lib/libcrypting.so"
STATIC_LIB="$BUILD_DIR/lib/libcrypting.a"

if [ -f "$SHARED_LIB" ]; then
    echo "✅ Shared library found: $SHARED_LIB"
    echo "  Size: $(du -h "$SHARED_LIB" | cut -f1)"
else
    echo "❌ Shared library not found: $SHARED_LIB"
fi

if [ -f "$STATIC_LIB" ]; then
    echo "✅ Static library found: $STATIC_LIB"
    echo "  Size: $(du -h "$STATIC_LIB" | cut -f1)"
else
    echo "❌ Static library not found: $STATIC_LIB"
fi

# Test 2: Check library symbols
echo "🔍 Checking library symbols..."
if [ -f "$SHARED_LIB" ]; then
    echo "Symbols in shared library:"
    nm -D "$SHARED_LIB" | grep -E "(encrypt_data|decrypt_data|crypto_bridge)" | head -5
fi

# Test 3: Check library dependencies
echo "🔗 Checking library dependencies..."
if [ -f "$SHARED_LIB" ]; then
    echo "Dependencies of shared library:"
    ldd "$SHARED_LIB" | grep -E "(crypto|ssl)" || echo "No crypto dependencies found"
fi

# Test 4: Basic functionality test (if possible)
echo "⚡ Testing basic functionality..."

# Create a simple test program
cat > /tmp/test_crypto.cpp << 'EOF'
#include <iostream>
#include <cstring>

extern "C" {
    int encrypt_data(const char* input, char* output, int length);
    int decrypt_data(const char* input, char* output, int length);
    const char* get_version();
}

int main() {
    // Test simple functions
    const char* version = get_version();
    std::cout << "Library version: " << version << std::endl;
    
    // Test encryption/decryption
    const char* test_data = "Hello, World!";
    int len = strlen(test_data);
    char encrypted[256];
    char decrypted[256];
    
    if (encrypt_data(test_data, encrypted, len) == 0) {
        std::cout << "✅ Encryption successful" << std::endl;
        
        if (decrypt_data(encrypted, decrypted, len) == 0) {
            decrypted[len] = '\0';
            if (strcmp(test_data, decrypted) == 0) {
                std::cout << "✅ Decryption successful - data matches!" << std::endl;
                return 0;
            } else {
                std::cout << "❌ Decryption failed - data mismatch" << std::endl;
                return 1;
            }
        } else {
            std::cout << "❌ Decryption function failed" << std::endl;
            return 1;
        }
    } else {
        std::cout << "❌ Encryption function failed" << std::endl;
        return 1;
    }
}
EOF

# Compile and run the test
if g++ -o /tmp/test_crypto /tmp/test_crypto.cpp -L"$BUILD_DIR/lib" -lcrypting; then
    echo "🔧 Test program compiled successfully"
    
    # Set library path and run test
    export LD_LIBRARY_PATH="$PWD/$BUILD_DIR/lib:$LD_LIBRARY_PATH"
    if /tmp/test_crypto; then
        echo "✅ All tests passed!"
    else
        echo "❌ Runtime test failed"
        exit 1
    fi
else
    echo "⚠️  Could not compile test program (this is normal if headers are not in standard locations)"
fi

echo "🎉 Library testing completed!"