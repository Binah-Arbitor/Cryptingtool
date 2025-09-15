/*
 * crypto_compat.h - Crypto++ Compatibility Header
 * 
 * This header addresses common Crypto++ include path issues found on Stack Overflow.
 * It provides automatic detection and compatibility for different Crypto++ installations:
 * 
 * Common Issues Addressed:
 * 1. Header path variations: crypto++/cryptlib.h vs cryptopp/cryptlib.h
 * 2. Different installation methods (package manager vs manual build)
 * 3. Cross-platform compatibility (Linux, macOS, Windows)
 * 4. Version compatibility checks
 * 
 * Stack Overflow References:
 * - "crypto++/cryptlib.h: No such file or directory"
 * - "Linking errors with Crypto++"
 * - "Cannot find crypto++ headers"
 */

#ifndef CRYPTO_COMPAT_H
#define CRYPTO_COMPAT_H

// Enable weak namespace for algorithms like ARC4/RC4 in Crypto++ 8.9+
// This must be defined before including any Crypto++ headers
#define CRYPTOPP_ENABLE_NAMESPACE_WEAK 1

// Try to detect Crypto++ header location automatically
// This handles the most common installation scenarios

// Method 1: Try crypto++/ prefix (common on Ubuntu/Debian with libcrypto++-dev)
#if __has_include(<crypto++/cryptlib.h>)
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
    
    // Additional algorithms - Tier 3-4 (AES finalists and strong ciphers)
    #include <crypto++/mars.h>
    #include <crypto++/rc5.h>
    #include <crypto++/skipjack.h>
    #include <crypto++/camellia.h>
    
    // Stream ciphers - Tier 5
    #include <crypto++/chacha.h>
    #include <crypto++/salsa.h>
    #include <crypto++/hc128.h>
    #include <crypto++/hc256.h>
    #include <crypto++/rabbit.h>
    #include <crypto++/sosemanuk.h>
    
    // National algorithms - Tier 6
    #include <crypto++/aria.h>
    #include <crypto++/seed.h>
    
    // Legacy algorithms - Tier 7-8  
    #include <crypto++/des.h>
    #include <crypto++/idea.h>
    #include <crypto++/rc2.h>
    #include <crypto++/safer.h>
    #include <crypto++/arc4.h>
    
    // Experimental and additional - Tier 9-10
    #include <crypto++/threefish.h>
    #include <crypto++/tea.h>
    #include <crypto++/shacal2.h>
    #include <crypto++/wake.h>
    #include <crypto++/square.h>
    #include <crypto++/shark.h>
    #include <crypto++/panama.h>
    #include <crypto++/seal.h>
    #define CRYPTO_HEADERS_FOUND 1
    #define CRYPTO_HEADER_PREFIX "crypto++/"

// Method 2: Try cryptopp/ prefix (common on some Linux distributions)
#elif __has_include(<cryptopp/cryptlib.h>)
    #include <cryptopp/cryptlib.h>
    #include <cryptopp/aes.h>
    #include <cryptopp/serpent.h>
    #include <cryptopp/twofish.h>
    #include <cryptopp/rc6.h>
    #include <cryptopp/blowfish.h>
    #include <cryptopp/cast.h>
    #include <cryptopp/modes.h>
    #include <cryptopp/gcm.h>
    #include <cryptopp/filters.h>
    #include <cryptopp/hex.h>
    #include <cryptopp/pwdbased.h>
    #include <cryptopp/sha.h>
    #include <cryptopp/secblock.h>
    #include <cryptopp/osrng.h>
    
    // Additional algorithms - Tier 3-4 (AES finalists and strong ciphers)
    #include <cryptopp/mars.h>
    #include <cryptopp/rc5.h>
    #include <cryptopp/skipjack.h>
    #include <cryptopp/camellia.h>
    
    // Stream ciphers - Tier 5
    #include <cryptopp/chacha.h>
    #include <cryptopp/salsa.h>
    #include <cryptopp/hc128.h>
    #include <cryptopp/hc256.h>
    #include <cryptopp/rabbit.h>
    #include <cryptopp/sosemanuk.h>
    
    // National algorithms - Tier 6
    #include <cryptopp/aria.h>
    #include <cryptopp/seed.h>
    
    // Legacy algorithms - Tier 7-8  
    #include <cryptopp/des.h>
    #include <cryptopp/idea.h>
    #include <cryptopp/rc2.h>
    #include <cryptopp/safer.h>
    #include <cryptopp/arc4.h>
    
    // Experimental and additional - Tier 9-10
    #include <cryptopp/threefish.h>
    #include <cryptopp/tea.h>
    #include <cryptopp/shacal2.h>
    #include <cryptopp/wake.h>
    #include <cryptopp/square.h>
    #include <cryptopp/shark.h>
    #include <cryptopp/panama.h>
    #include <cryptopp/seal.h>
    #define CRYPTO_HEADERS_FOUND 1
    #define CRYPTO_HEADER_PREFIX "cryptopp/"

// Method 3: Try direct includes (custom installations or vcpkg)
#elif __has_include(<cryptlib.h>)
    #include <cryptlib.h>
    #include <aes.h>
    #include <serpent.h>
    #include <twofish.h>
    #include <rc6.h>
    #include <blowfish.h>
    #include <cast.h>
    #include <modes.h>
    #include <gcm.h>
    #include <filters.h>
    #include <hex.h>
    #include <pwdbased.h>
    #include <sha.h>
    #include <secblock.h>
    #include <osrng.h>
    
    // Additional algorithms - Tier 3-4 (AES finalists and strong ciphers)
    #include <mars.h>
    #include <rc5.h>
    #include <skipjack.h>
    #include <camellia.h>
    
    // Stream ciphers - Tier 5
    #include <chacha.h>
    #include <salsa.h>
    #include <hc128.h>
    #include <hc256.h>
    #include <rabbit.h>
    #include <sosemanuk.h>
    
    // National algorithms - Tier 6
    #include <aria.h>
    #include <seed.h>
    
    // Legacy algorithms - Tier 7-8  
    #include <des.h>
    #include <idea.h>
    #include <rc2.h>
    #include <safer.h>
    #include <arc4.h>
    
    // Experimental and additional - Tier 9-10
    #include <threefish.h>
    #include <tea.h>
    #include <shacal2.h>
    #include <wake.h>
    #include <square.h>
    #include <shark.h>
    #include <panama.h>
    #include <seal.h>
    #define CRYPTO_HEADERS_FOUND 1
    #define CRYPTO_HEADER_PREFIX ""

#else
    // None of the common header locations found
    #define CRYPTO_HEADERS_FOUND 0
    #error "Crypto++ headers not found! Please install Crypto++ library:\
    \n\nUbuntu/Debian: sudo apt-get install libcrypto++-dev\
    \nCentOS/RHEL:   sudo yum install cryptopp-devel\
    \nFedora:        sudo dnf install cryptopp-devel\
    \nArch Linux:    sudo pacman -S crypto++\
    \nmacOS:         brew install cryptopp\
    \nWindows:       vcpkg install cryptopp\
    \n\nFor manual installation, see: https://cryptopp.com/wiki/Linux"
#endif

#if CRYPTO_HEADERS_FOUND

// Version check and compatibility
#ifdef CRYPTOPP_VERSION
    #define CRYPTO_VERSION_MAJOR ((CRYPTOPP_VERSION / 100) % 100)
    #define CRYPTO_VERSION_MINOR (CRYPTOPP_VERSION % 100)
    
    // Ensure we have a recent enough version
    #if CRYPTOPP_VERSION < 890
        #warning "Crypto++ version is older than 8.9.0. Some features may not work correctly."
    #endif
#else
    #warning "Unable to detect Crypto++ version. Compatibility not guaranteed."
#endif

// Success message for debugging
#ifdef DEBUG
    #pragma message("Crypto++ headers found using prefix: " CRYPTO_HEADER_PREFIX)
    #ifdef CRYPTOPP_VERSION
        #pragma message("Crypto++ version detected")
    #endif
#endif

#endif // CRYPTO_HEADERS_FOUND

#endif // CRYPTO_COMPAT_H