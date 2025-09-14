#!/usr/bin/env bash

# Test the crypto bridge integration
echo "🧪 Testing Crypto Bridge Integration"

cd "$(dirname "$0")"

# Build the library if not already built
if [ ! -f "../build/lib/libcrypting.so" ]; then
    echo "Building crypto library..."
    mkdir -p ../build
    cd ../build
    cmake .. && make -j$(nproc)
    cd ..
fi

# Test the crypto bridge C++ functionality
echo "✅ Testing C++ library functionality..."
export LD_LIBRARY_PATH="$PWD/../build/lib:$LD_LIBRARY_PATH"

# Create a simple test program
cat > /tmp/test_crypto_bridge.cpp << 'EOF'
#include <iostream>
#include <cstring>
#include <vector>

extern "C" {
    int crypto_bridge_process(
        int algorithm, int mode, int key_size_bits, int operation,
        const char* password, int password_len,
        const unsigned char* input_data, int input_len,
        unsigned char* output_data, int* output_len,
        unsigned char* iv, unsigned char* auth_tag);
    
    const char* crypto_bridge_version();
}

// Constants from C++
const int ALGORITHM_AES = 1;
const int MODE_CBC = 1;
const int OPERATION_ENCRYPT = 1;
const int OPERATION_DECRYPT = 2;

int main() {
    std::cout << "🔧 Testing crypto bridge FFI integration..." << std::endl;
    
    // Get version
    const char* version = crypto_bridge_version();
    std::cout << "Version: " << version << std::endl;
    
    // Test data
    const std::string password = "TestPassword123";
    const std::string message = "Hello, CryptingTool Backend!";
    
    // Encryption test
    std::vector<unsigned char> encrypted_data(message.length() + 64);
    int encrypted_len = message.length() + 64;
    unsigned char iv[16];
    unsigned char auth_tag[16];
    
    int encrypt_result = crypto_bridge_process(
        ALGORITHM_AES, MODE_CBC, 256, OPERATION_ENCRYPT,
        password.c_str(), password.length(),
        (const unsigned char*)message.c_str(), message.length(),
        encrypted_data.data(), &encrypted_len,
        iv, auth_tag
    );
    
    if (encrypt_result == 0) {
        std::cout << "✅ Encryption successful (" << encrypted_len << " bytes)" << std::endl;
        
        // Decryption test
        std::vector<unsigned char> decrypted_data(encrypted_len + 64);
        int decrypted_len = encrypted_len + 64;
        
        int decrypt_result = crypto_bridge_process(
            ALGORITHM_AES, MODE_CBC, 256, OPERATION_DECRYPT,
            password.c_str(), password.length(),
            encrypted_data.data(), encrypted_len,
            decrypted_data.data(), &decrypted_len,
            iv, auth_tag
        );
        
        if (decrypt_result == 0) {
            std::string decrypted_message((char*)decrypted_data.data(), decrypted_len);
            if (decrypted_message == message) {
                std::cout << "✅ Decryption successful - Round trip complete!" << std::endl;
                std::cout << "✅ Backend integration working correctly" << std::endl;
                return 0;
            } else {
                std::cout << "❌ Message mismatch after round trip" << std::endl;
                return 1;
            }
        } else {
            std::cout << "❌ Decryption failed with error: " << decrypt_result << std::endl;
            return 1;
        }
    } else {
        std::cout << "❌ Encryption failed with error: " << encrypt_result << std::endl;
        return 1;
    }
}
EOF

# Compile and run the test
if g++ -o /tmp/test_crypto_bridge /tmp/test_crypto_bridge.cpp -L"../build/lib" -lcrypting; then
    echo "🔧 Backend integration test compiled successfully"
    
    if LD_LIBRARY_PATH="../build/lib:$LD_LIBRARY_PATH" /tmp/test_crypto_bridge; then
        echo "🎉 Backend integration test PASSED!"
    else
        echo "❌ Backend integration test FAILED!"
        exit 1
    fi
else
    echo "❌ Could not compile backend integration test"
    exit 1
fi

echo "🎉 All backend tests completed successfully!"