#!/bin/bash
# Quick verification script for crypto++ installation
# Based on Stack Overflow solutions for crypto++ include errors

set -e

echo "🔐 Quick Crypto++ Installation Verification"
echo "============================================"
echo ""

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

echo "📝 Creating test program..."

cat << 'EOF' > crypto_test.cpp
#include <iostream>
#include <crypto++/cryptlib.h>
#include <crypto++/aes.h>
#include <crypto++/osrng.h>
#include <crypto++/modes.h>
#include <crypto++/filters.h>

int main() {
    try {
        // Test basic AES functionality
        CryptoPP::AutoSeededRandomPool rng;
        
        CryptoPP::byte key[CryptoPP::AES::DEFAULT_KEYLENGTH];
        CryptoPP::byte iv[CryptoPP::AES::BLOCKSIZE];
        
        rng.GenerateBlock(key, sizeof(key));
        rng.GenerateBlock(iv, sizeof(iv));
        
        std::string plaintext = "Hello, Crypto++!";
        std::string ciphertext, recovered;
        
        // Encryption
        CryptoPP::CBC_Mode<CryptoPP::AES>::Encryption enc;
        enc.SetKeyWithIV(key, sizeof(key), iv);
        
        CryptoPP::StringSource ss1(plaintext, true, 
            new CryptoPP::StreamTransformationFilter(enc,
                new CryptoPP::StringSink(ciphertext)));
        
        // Decryption
        CryptoPP::CBC_Mode<CryptoPP::AES>::Decryption dec;
        dec.SetKeyWithIV(key, sizeof(key), iv);
        
        CryptoPP::StringSource ss2(ciphertext, true, 
            new CryptoPP::StreamTransformationFilter(dec,
                new CryptoPP::StringSink(recovered)));
        
        if (plaintext == recovered) {
            std::cout << "SUCCESS: Crypto++ is working correctly!" << std::endl;
            return 0;
        } else {
            std::cout << "FAILURE: Encryption/decryption mismatch!" << std::endl;
            return 1;
        }
        
    } catch (const CryptoPP::Exception& e) {
        std::cout << "CRYPTO++ ERROR: " << e.what() << std::endl;
        return 1;
    } catch (const std::exception& e) {
        std::cout << "STD ERROR: " << e.what() << std::endl;
        return 1;
    }
}
EOF

echo "🔨 Testing compilation with different approaches..."

# Test 1: Standard approach
echo -n "   Standard linking (-lcryptopp): "
if g++ -std=c++11 -o crypto_test1 crypto_test.cpp -lcryptopp 2>/dev/null; then
    echo -e "${GREEN}✓${NC}"
    COMPILE_SUCCESS=true
    TEST_EXE="crypto_test1"
else
    echo -e "${RED}✗${NC}"
    
    # Test 2: Alternative library names
    echo -n "   Alternative linking (-lcrypto++): "
    if g++ -std=c++11 -o crypto_test2 crypto_test.cpp -lcrypto++ 2>/dev/null; then
        echo -e "${GREEN}✓${NC}"
        COMPILE_SUCCESS=true
        TEST_EXE="crypto_test2"
    else
        echo -e "${RED}✗${NC}"
        
        # Test 3: With explicit include path
        echo -n "   With include path: "
        if g++ -std=c++11 -I/usr/include -o crypto_test3 crypto_test.cpp -lcryptopp 2>/dev/null; then
            echo -e "${GREEN}✓${NC}"
            COMPILE_SUCCESS=true
            TEST_EXE="crypto_test3"
        else
            echo -e "${RED}✗${NC}"
            COMPILE_SUCCESS=false
        fi
    fi
fi

if [ "$COMPILE_SUCCESS" = true ]; then
    echo ""
    echo "🧪 Running functionality test..."
    if ./$TEST_EXE; then
        echo ""
        echo -e "${GREEN}✅ PASSED: Crypto++ installation is working correctly!${NC}"
        echo ""
        echo "Your #include <crypto++/cryptlib.h> errors should be resolved."
    else
        echo ""
        echo -e "${YELLOW}⚠️  COMPILATION SUCCESS but RUNTIME FAILURE${NC}"
        echo "The library compiles but has runtime issues."
    fi
else
    echo ""
    echo -e "${RED}❌ FAILED: Crypto++ compilation failed${NC}"
    echo ""
    echo "This indicates the crypto++ library or headers are not properly installed."
    echo ""
    echo "Solutions to try:"
    echo ""
    echo "📦 Ubuntu/Debian:"
    echo "   sudo apt-get update"
    echo "   sudo apt-get install libcrypto++-dev"
    echo ""
    echo "📦 CentOS/RHEL/Fedora:"
    echo "   sudo yum install cryptopp-devel  # or dnf install cryptopp-devel"
    echo ""
    echo "📦 macOS:"
    echo "   brew install cryptopp"
    echo ""
    echo "📦 Arch Linux:"
    echo "   sudo pacman -S crypto++"
    echo ""
    echo "🔨 Build from source (latest):"
    echo "   wget https://github.com/weidai11/cryptopp/releases/download/CRYPTOPP_8_9_0/cryptopp890.zip"
    echo "   unzip cryptopp890.zip && cd cryptopp"
    echo "   make && sudo make install && sudo ldconfig"
fi

# Cleanup
cd /
rm -rf "$TEMP_DIR"

echo ""
echo "🔍 For more troubleshooting, run: ./scripts/troubleshoot.sh"