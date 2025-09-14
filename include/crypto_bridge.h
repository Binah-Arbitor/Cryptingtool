/*
 * crypto_bridge.h - Header file for crypto_bridge.cpp
 * 
 * This header defines the C interface for the Crypto++ bridge library
 * designed for use with Flutter FFI (Foreign Function Interface).
 */

#ifndef CRYPTO_BRIDGE_H
#define CRYPTO_BRIDGE_H

#ifdef __cplusplus
extern "C" {
#endif

// Algorithm identifiers
typedef enum {
    // Tier 1-2: Modern High Security
    CRYPTO_ALGORITHM_AES = 1,
    CRYPTO_ALGORITHM_SERPENT = 2,
    CRYPTO_ALGORITHM_TWOFISH = 3,
    
    // Tier 3: Strong Security - AES Finalists & Modern Ciphers  
    CRYPTO_ALGORITHM_RC6 = 4,
    CRYPTO_ALGORITHM_MARS = 5,
    CRYPTO_ALGORITHM_RC5 = 6,
    CRYPTO_ALGORITHM_SKIPJACK = 7,
    
    // Tier 4: Reliable Security - Established Algorithms
    CRYPTO_ALGORITHM_BLOWFISH = 8,
    CRYPTO_ALGORITHM_CAST128 = 9,
    CRYPTO_ALGORITHM_CAST256 = 10,
    CRYPTO_ALGORITHM_CAMELLIA = 11,
    
    // Tier 5: Stream Ciphers - High Performance
    CRYPTO_ALGORITHM_CHACHA20 = 12,
    CRYPTO_ALGORITHM_SALSA20 = 13,
    CRYPTO_ALGORITHM_XSALSA20 = 14,
    CRYPTO_ALGORITHM_HC128 = 15,
    CRYPTO_ALGORITHM_HC256 = 16,
    CRYPTO_ALGORITHM_RABBIT = 17,
    CRYPTO_ALGORITHM_SOSEMANUK = 18,
    
    // Tier 6: Specialized & National Algorithms
    CRYPTO_ALGORITHM_ARIA = 19,
    CRYPTO_ALGORITHM_SEED = 20,
    CRYPTO_ALGORITHM_SM4 = 21,
    CRYPTO_ALGORITHM_GOST28147 = 22,
    
    // Tier 7: Legacy Strong Algorithms
    CRYPTO_ALGORITHM_DES3 = 23,
    CRYPTO_ALGORITHM_IDEA = 24,
    CRYPTO_ALGORITHM_RC2 = 25,
    CRYPTO_ALGORITHM_SAFER = 26,
    CRYPTO_ALGORITHM_SAFER_PLUS = 27,
    
    // Tier 8: Historical & Compatibility
    CRYPTO_ALGORITHM_DES = 28,
    CRYPTO_ALGORITHM_RC4 = 29,
    
    // Tier 9: Experimental & Research
    CRYPTO_ALGORITHM_THREEFISH256 = 30,
    CRYPTO_ALGORITHM_THREEFISH512 = 31,
    CRYPTO_ALGORITHM_THREEFISH1024 = 32,
    
    // Tier 10: Additional Algorithms
    CRYPTO_ALGORITHM_TEA = 33,
    CRYPTO_ALGORITHM_XTEA = 34,
    CRYPTO_ALGORITHM_SHACAL2 = 35,
    CRYPTO_ALGORITHM_WAKE = 36,
    
    // Archive/Research Ciphers
    CRYPTO_ALGORITHM_SQUARE = 37,
    CRYPTO_ALGORITHM_SHARK = 38,
    CRYPTO_ALGORITHM_PANAMA = 39,
    CRYPTO_ALGORITHM_SEAL = 40,
    CRYPTO_ALGORITHM_LUCIFER = 41,
    
    // Modern lightweight ciphers (placeholders - may not be in Crypto++)
    CRYPTO_ALGORITHM_SIMON = 42,
    CRYPTO_ALGORITHM_SPECK = 43
} CryptoBridgeAlgorithm;

// Mode identifiers
typedef enum {
    CRYPTO_MODE_CBC = 1,
    CRYPTO_MODE_GCM = 2,
    CRYPTO_MODE_ECB = 3,
    CRYPTO_MODE_CFB = 4,
    CRYPTO_MODE_OFB = 5,
    CRYPTO_MODE_CTR = 6
} CryptoBridgeMode;

// Operation type
typedef enum {
    CRYPTO_OPERATION_ENCRYPT = 1,
    CRYPTO_OPERATION_DECRYPT = 2
} CryptoBridgeOperation;

// Status codes
typedef enum {
    CRYPTO_STATUS_SUCCESS = 0,
    CRYPTO_STATUS_INVALID_PARAMS = -1,
    CRYPTO_STATUS_UNSUPPORTED_ALGORITHM = -2,
    CRYPTO_STATUS_UNSUPPORTED_MODE = -3,
    CRYPTO_STATUS_INVALID_KEY_SIZE = -4,
    CRYPTO_STATUS_MEMORY_ERROR = -5,
    CRYPTO_STATUS_CRYPTO_ERROR = -6,
    CRYPTO_STATUS_PASSWORD_TOO_SHORT = -7,
    CRYPTO_STATUS_OUTPUT_BUFFER_TOO_SMALL = -8,
    CRYPTO_STATUS_UNKNOWN_ERROR = -9
} CryptoBridgeStatus;

/**
 * Main FFI function for encryption and decryption operations
 * 
 * @param algorithm Algorithm identifier (CryptoBridgeAlgorithm enum)
 * @param mode Mode identifier (CryptoBridgeMode enum)
 * @param key_size_bits Key size in bits
 * @param operation Operation type (CryptoBridgeOperation enum)
 * @param password Password string (null-terminated)
 * @param password_len Length of password (excluding null terminator)
 * @param input_data Input data buffer
 * @param input_len Length of input data
 * @param output_data Output data buffer (allocated by caller)
 * @param output_len Pointer to output buffer size (in/out parameter)
 * @param iv Initialization vector (16 bytes, can be null for auto-generation)
 * @param auth_tag Authentication tag for GCM mode (16 bytes, can be null)
 * 
 * @return Status code (0 = success, negative = error)
 */
int crypto_bridge_process(
    int algorithm,
    int mode, 
    int key_size_bits,
    int operation,
    const char* password,
    int password_len,
    const unsigned char* input_data,
    int input_len,
    unsigned char* output_data,
    int* output_len,
    unsigned char* iv,
    unsigned char* auth_tag
);

/**
 * Get version string of the crypto bridge
 * 
 * @return Version string (e.g., "1.0.0")
 */
const char* crypto_bridge_version(void);

#ifdef __cplusplus
}
#endif

#endif // CRYPTO_BRIDGE_H