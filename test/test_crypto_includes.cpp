/*
 * test_crypto_includes.cpp - Test to verify crypto++ includes work correctly
 * 
 * This test verifies that all crypto++ header includes from crypto_bridge.cpp
 * are accessible and can be compiled successfully.
 */

#include <iostream>

// Test the main crypto++ includes from crypto_bridge.cpp
#include <crypto++/cryptlib.h>
#include <crypto++/aes.h>
#include <crypto++/serpent.h>
#include <crypto++/twofish.h>
#include <crypto++/rc6.h>
#include <crypto++/blowfish.h>
#include <crypto++/cast.h>
#include <crypto++/modes.h>
#include <crypto++/gcm.h>
#include <crypto++/filters.h>
#include <crypto++/hex.h>
#include <crypto++/pwdbased.h>
#include <crypto++/sha.h>
#include <crypto++/secblock.h>
#include <crypto++/osrng.h>

int main() {
    std::cout << "Testing crypto++ includes..." << std::endl;
    
    // Test basic functionality to ensure linking works
    try {
        // Test AES
        CryptoPP::AES::Encryption aesEncryption;
        std::cout << "✓ AES include and basic instantiation works" << std::endl;
        
        // Test random number generation
        CryptoPP::AutoSeededRandomPool rng;
        std::cout << "✓ Random number generator works" << std::endl;
        
        // Test SecByteBlock
        CryptoPP::SecByteBlock key(16);
        rng.GenerateBlock(key, key.size());
        std::cout << "✓ SecByteBlock works" << std::endl;
        
        // Test SHA256
        CryptoPP::SHA256 hash;
        std::cout << "✓ SHA256 include works" << std::endl;
        
        std::cout << std::endl;
        std::cout << "✅ All crypto++ includes test passed!" << std::endl;
        std::cout << "The #include <crypto++/cryptlib.h> error has been resolved." << std::endl;
        
        return 0;
        
    } catch (const CryptoPP::Exception& e) {
        std::cerr << "❌ Crypto++ exception: " << e.what() << std::endl;
        return 1;
    } catch (const std::exception& e) {
        std::cerr << "❌ Standard exception: " << e.what() << std::endl;
        return 1;
    }
}