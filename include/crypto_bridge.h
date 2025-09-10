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
    CRYPTO_ALGORITHM_AES = 1,
    CRYPTO_ALGORITHM_SERPENT = 2,
    CRYPTO_ALGORITHM_TWOFISH = 3,
    CRYPTO_ALGORITHM_RC6 = 4,
    CRYPTO_ALGORITHM_BLOWFISH = 5,
    CRYPTO_ALGORITHM_CAST128 = 6
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