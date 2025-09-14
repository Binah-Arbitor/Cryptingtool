/*
 * crypto_bridge.cpp - Single file Crypto++ bridge for Flutter FFI
 * 
 * This file provides a stable, exception-safe C interface to the Crypto++ library
 * for use with Flutter applications via FFI (Foreign Function Interface).
 * 
 * Supported Algorithms:
 * - AES (Advanced Encryption Standard): 128, 192, 256-bit keys
 * - Serpent: 128, 192, 256-bit keys  
 * - Twofish: 128, 192, 256-bit keys
 * - RC6: 128, 192, 256-bit keys
 * - Blowfish: 32, 64, 128, 256, 448-bit keys
 * - CAST-128: 128-bit keys
 * 
 * Supported Modes:
 * - CBC (Cipher Block Chaining)
 * - GCM (Galois/Counter Mode) - AEAD mode with authentication
 * - ECB (Electronic Codebook) 
 * - CFB (Cipher Feedback)
 * - OFB (Output Feedback)
 * - CTR (Counter Mode)
 * 
 * Return Codes:
 * 0: Success
 * -1: Invalid parameters
 * -2: Unsupported algorithm
 * -3: Unsupported mode
 * -4: Invalid key size for algorithm
 * -5: Memory allocation error
 * -6: Encryption/decryption error
 * -7: Password too short
 * -8: Output buffer too small
 * -9: Unknown error
 */

// Use compatibility header that handles different Crypto++ installation paths
#include "crypto_compat.h"
#include <cstring>
#include <memory>

// Algorithm identifiers
enum CryptoBridgeAlgorithm {
    // Tier 1-2: Modern High Security
    ALGORITHM_AES = 1,
    ALGORITHM_SERPENT = 2,
    ALGORITHM_TWOFISH = 3,
    
    // Tier 3: Strong Security - AES Finalists & Modern Ciphers  
    ALGORITHM_RC6 = 4,
    ALGORITHM_MARS = 5,
    ALGORITHM_RC5 = 6,
    ALGORITHM_SKIPJACK = 7,
    
    // Tier 4: Reliable Security - Established Algorithms
    ALGORITHM_BLOWFISH = 8,
    ALGORITHM_CAST128 = 9,
    ALGORITHM_CAST256 = 10,
    ALGORITHM_CAMELLIA = 11,
    
    // Tier 5: Stream Ciphers - High Performance
    ALGORITHM_CHACHA20 = 12,
    ALGORITHM_SALSA20 = 13,
    ALGORITHM_XSALSA20 = 14,
    ALGORITHM_HC128 = 15,
    ALGORITHM_HC256 = 16,
    ALGORITHM_RABBIT = 17,
    ALGORITHM_SOSEMANUK = 18,
    
    // Tier 6: Specialized & National Algorithms
    ALGORITHM_ARIA = 19,
    ALGORITHM_SEED = 20,
    ALGORITHM_SM4 = 21,
    ALGORITHM_GOST28147 = 22,
    
    // Tier 7: Legacy Strong Algorithms
    ALGORITHM_DES3 = 23,
    ALGORITHM_IDEA = 24,
    ALGORITHM_RC2 = 25,
    ALGORITHM_SAFER = 26,
    ALGORITHM_SAFER_PLUS = 27,
    
    // Tier 8: Historical & Compatibility
    ALGORITHM_DES = 28,
    ALGORITHM_RC4 = 29,
    
    // Tier 9: Experimental & Research
    ALGORITHM_THREEFISH256 = 30,
    ALGORITHM_THREEFISH512 = 31,
    ALGORITHM_THREEFISH1024 = 32,
    
    // Tier 10: Additional Algorithms
    ALGORITHM_TEA = 33,
    ALGORITHM_XTEA = 34,
    ALGORITHM_SHACAL2 = 35,
    ALGORITHM_WAKE = 36,
    
    // Archive/Research Ciphers
    ALGORITHM_SQUARE = 37,
    ALGORITHM_SHARK = 38,
    ALGORITHM_PANAMA = 39,
    ALGORITHM_SEAL = 40,
    ALGORITHM_LUCIFER = 41,
    
    // Modern lightweight ciphers (placeholders)
    ALGORITHM_SIMON = 42,
    ALGORITHM_SPECK = 43
};

// Mode identifiers  
enum CryptoBridgeMode {
    MODE_CBC = 1,
    MODE_GCM = 2,
    MODE_ECB = 3,
    MODE_CFB = 4,
    MODE_OFB = 5,
    MODE_CTR = 6
};

// Operation type
enum CryptoBridgeOperation {
    OPERATION_ENCRYPT = 1,
    OPERATION_DECRYPT = 2
};

// Status codes
enum CryptoBridgeStatus {
    STATUS_SUCCESS = 0,
    STATUS_INVALID_PARAMS = -1,
    STATUS_UNSUPPORTED_ALGORITHM = -2,
    STATUS_UNSUPPORTED_MODE = -3,
    STATUS_INVALID_KEY_SIZE = -4,
    STATUS_MEMORY_ERROR = -5,
    STATUS_CRYPTO_ERROR = -6,
    STATUS_PASSWORD_TOO_SHORT = -7,
    STATUS_OUTPUT_BUFFER_TOO_SMALL = -8,
    STATUS_UNKNOWN_ERROR = -9
};

// Forward declarations for internal functions
static int validate_algorithm_key_size(int algorithm, int key_size_bits);
static int validate_algorithm_mode_combination(int algorithm, int mode);
static int derive_key_and_iv(const char* password, int password_len, 
                           unsigned char* key, int key_len,
                           unsigned char* iv, int iv_len);

extern "C" {

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
) {
    try {
        // Input validation
        if (!password || !input_data || !output_data || !output_len) {
            return STATUS_INVALID_PARAMS;
        }
        
        if (password_len < 8) {
            return STATUS_PASSWORD_TOO_SHORT;
        }
        
        if (input_len <= 0 || *output_len <= 0) {
            return STATUS_INVALID_PARAMS;
        }

        // Validate algorithm and key size combination
        int validation_result = validate_algorithm_key_size(algorithm, key_size_bits);
        if (validation_result != STATUS_SUCCESS) {
            return validation_result;
        }
        
        // Validate algorithm and mode combination
        validation_result = validate_algorithm_mode_combination(algorithm, mode);
        if (validation_result != STATUS_SUCCESS) {
            return validation_result;
        }

        const int key_len = key_size_bits / 8;
        const int iv_len = (algorithm == ALGORITHM_CHACHA20) ? 12 : 16; // ChaCha20 uses 12-byte nonce, others use 16
        
        // Ensure output buffer is large enough
        int required_output_len = input_len;
        if (mode != MODE_GCM && operation == OPERATION_ENCRYPT) {
            // Add padding space for non-AEAD modes
            required_output_len += 16; // Block size padding
        }
        
        if (*output_len < required_output_len) {
            *output_len = required_output_len;
            return STATUS_OUTPUT_BUFFER_TOO_SMALL;
        }

        // Derive key and IV from password
        CryptoPP::SecByteBlock derived_key(key_len);
        CryptoPP::SecByteBlock derived_iv(iv_len);
        
        int derive_result = derive_key_and_iv(password, password_len,
                                            derived_key.data(), key_len,
                                            derived_iv.data(), iv_len);
        if (derive_result != STATUS_SUCCESS) {
            return derive_result;
        }
        
        // Copy derived IV to output if provided
        if (iv) {
            std::memcpy(iv, derived_iv.data(), iv_len);
        }

        std::string result;
        
        // Algorithm-specific processing
        switch (algorithm) {
            case ALGORITHM_AES: {
                switch (mode) {
                    case MODE_CBC: {
                        if (operation == OPERATION_ENCRYPT) {
                            CryptoPP::CBC_Mode<CryptoPP::AES>::Encryption enc;
                            enc.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data());
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(enc,
                                    new CryptoPP::StringSink(result)));
                        } else {
                            CryptoPP::CBC_Mode<CryptoPP::AES>::Decryption dec;
                            dec.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data());
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(dec,
                                    new CryptoPP::StringSink(result)));
                        }
                        break;
                    }
                    case MODE_GCM: {
                        if (operation == OPERATION_ENCRYPT) {
                            CryptoPP::GCM<CryptoPP::AES>::Encryption enc;
                            enc.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data(), iv_len);
                            CryptoPP::AuthenticatedEncryptionFilter aef(enc,
                                new CryptoPP::StringSink(result));
                            aef.Put((const CryptoPP::byte*)input_data, input_len);
                            aef.MessageEnd();
                            
                            // Extract authentication tag if provided
                            if (auth_tag) {
                                std::memcpy(auth_tag, result.data() + input_len, 16);
                                result.resize(input_len);
                            }
                        } else {
                            CryptoPP::GCM<CryptoPP::AES>::Decryption dec;
                            dec.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data(), iv_len);
                            CryptoPP::AuthenticatedDecryptionFilter adf(dec,
                                new CryptoPP::StringSink(result));
                            adf.Put((const CryptoPP::byte*)input_data, input_len);
                            if (auth_tag) {
                                adf.Put(auth_tag, 16);
                            }
                            adf.MessageEnd();
                        }
                        break;
                    }
                    case MODE_ECB: {
                        if (operation == OPERATION_ENCRYPT) {
                            CryptoPP::ECB_Mode<CryptoPP::AES>::Encryption enc;
                            enc.SetKey(derived_key.data(), key_len);
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(enc,
                                    new CryptoPP::StringSink(result)));
                        } else {
                            CryptoPP::ECB_Mode<CryptoPP::AES>::Decryption dec;
                            dec.SetKey(derived_key.data(), key_len);
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(dec,
                                    new CryptoPP::StringSink(result)));
                        }
                        break;
                    }
                    case MODE_CFB: {
                        if (operation == OPERATION_ENCRYPT) {
                            CryptoPP::CFB_Mode<CryptoPP::AES>::Encryption enc;
                            enc.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data());
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(enc,
                                    new CryptoPP::StringSink(result)));
                        } else {
                            CryptoPP::CFB_Mode<CryptoPP::AES>::Decryption dec;
                            dec.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data());
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(dec,
                                    new CryptoPP::StringSink(result)));
                        }
                        break;
                    }
                    case MODE_OFB: {
                        if (operation == OPERATION_ENCRYPT) {
                            CryptoPP::OFB_Mode<CryptoPP::AES>::Encryption enc;
                            enc.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data());
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(enc,
                                    new CryptoPP::StringSink(result)));
                        } else {
                            CryptoPP::OFB_Mode<CryptoPP::AES>::Decryption dec;
                            dec.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data());
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(dec,
                                    new CryptoPP::StringSink(result)));
                        }
                        break;
                    }
                    case MODE_CTR: {
                        if (operation == OPERATION_ENCRYPT) {
                            CryptoPP::CTR_Mode<CryptoPP::AES>::Encryption enc;
                            enc.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data());
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(enc,
                                    new CryptoPP::StringSink(result)));
                        } else {
                            CryptoPP::CTR_Mode<CryptoPP::AES>::Decryption dec;
                            dec.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data());
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(dec,
                                    new CryptoPP::StringSink(result)));
                        }
                        break;
                    }
                    default:
                        return STATUS_UNSUPPORTED_MODE;
                }
                break;
            }
            
            case ALGORITHM_SERPENT: {
                switch (mode) {
                    case MODE_CBC: {
                        if (operation == OPERATION_ENCRYPT) {
                            CryptoPP::CBC_Mode<CryptoPP::Serpent>::Encryption enc;
                            enc.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data());
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(enc,
                                    new CryptoPP::StringSink(result)));
                        } else {
                            CryptoPP::CBC_Mode<CryptoPP::Serpent>::Decryption dec;
                            dec.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data());
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(dec,
                                    new CryptoPP::StringSink(result)));
                        }
                        break;
                    }
                    case MODE_ECB: {
                        if (operation == OPERATION_ENCRYPT) {
                            CryptoPP::ECB_Mode<CryptoPP::Serpent>::Encryption enc;
                            enc.SetKey(derived_key.data(), key_len);
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(enc,
                                    new CryptoPP::StringSink(result)));
                        } else {
                            CryptoPP::ECB_Mode<CryptoPP::Serpent>::Decryption dec;
                            dec.SetKey(derived_key.data(), key_len);
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(dec,
                                    new CryptoPP::StringSink(result)));
                        }
                        break;
                    }
                    case MODE_CFB: {
                        if (operation == OPERATION_ENCRYPT) {
                            CryptoPP::CFB_Mode<CryptoPP::Serpent>::Encryption enc;
                            enc.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data());
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(enc,
                                    new CryptoPP::StringSink(result)));
                        } else {
                            CryptoPP::CFB_Mode<CryptoPP::Serpent>::Decryption dec;
                            dec.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data());
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(dec,
                                    new CryptoPP::StringSink(result)));
                        }
                        break;
                    }
                    case MODE_OFB: {
                        if (operation == OPERATION_ENCRYPT) {
                            CryptoPP::OFB_Mode<CryptoPP::Serpent>::Encryption enc;
                            enc.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data());
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(enc,
                                    new CryptoPP::StringSink(result)));
                        } else {
                            CryptoPP::OFB_Mode<CryptoPP::Serpent>::Decryption dec;
                            dec.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data());
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(dec,
                                    new CryptoPP::StringSink(result)));
                        }
                        break;
                    }
                    case MODE_CTR: {
                        if (operation == OPERATION_ENCRYPT) {
                            CryptoPP::CTR_Mode<CryptoPP::Serpent>::Encryption enc;
                            enc.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data());
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(enc,
                                    new CryptoPP::StringSink(result)));
                        } else {
                            CryptoPP::CTR_Mode<CryptoPP::Serpent>::Decryption dec;
                            dec.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data());
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(dec,
                                    new CryptoPP::StringSink(result)));
                        }
                        break;
                    }
                    default:
                        return STATUS_UNSUPPORTED_MODE;
                }
                break;
            }
            
            case ALGORITHM_TWOFISH: {
                switch (mode) {
                    case MODE_CBC: {
                        if (operation == OPERATION_ENCRYPT) {
                            CryptoPP::CBC_Mode<CryptoPP::Twofish>::Encryption enc;
                            enc.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data());
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(enc,
                                    new CryptoPP::StringSink(result)));
                        } else {
                            CryptoPP::CBC_Mode<CryptoPP::Twofish>::Decryption dec;
                            dec.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data());
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(dec,
                                    new CryptoPP::StringSink(result)));
                        }
                        break;
                    }
                    case MODE_ECB: {
                        if (operation == OPERATION_ENCRYPT) {
                            CryptoPP::ECB_Mode<CryptoPP::Twofish>::Encryption enc;
                            enc.SetKey(derived_key.data(), key_len);
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(enc,
                                    new CryptoPP::StringSink(result)));
                        } else {
                            CryptoPP::ECB_Mode<CryptoPP::Twofish>::Decryption dec;
                            dec.SetKey(derived_key.data(), key_len);
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(dec,
                                    new CryptoPP::StringSink(result)));
                        }
                        break;
                    }
                    case MODE_CFB: {
                        if (operation == OPERATION_ENCRYPT) {
                            CryptoPP::CFB_Mode<CryptoPP::Twofish>::Encryption enc;
                            enc.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data());
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(enc,
                                    new CryptoPP::StringSink(result)));
                        } else {
                            CryptoPP::CFB_Mode<CryptoPP::Twofish>::Decryption dec;
                            dec.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data());
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(dec,
                                    new CryptoPP::StringSink(result)));
                        }
                        break;
                    }
                    case MODE_OFB: {
                        if (operation == OPERATION_ENCRYPT) {
                            CryptoPP::OFB_Mode<CryptoPP::Twofish>::Encryption enc;
                            enc.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data());
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(enc,
                                    new CryptoPP::StringSink(result)));
                        } else {
                            CryptoPP::OFB_Mode<CryptoPP::Twofish>::Decryption dec;
                            dec.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data());
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(dec,
                                    new CryptoPP::StringSink(result)));
                        }
                        break;
                    }
                    case MODE_CTR: {
                        if (operation == OPERATION_ENCRYPT) {
                            CryptoPP::CTR_Mode<CryptoPP::Twofish>::Encryption enc;
                            enc.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data());
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(enc,
                                    new CryptoPP::StringSink(result)));
                        } else {
                            CryptoPP::CTR_Mode<CryptoPP::Twofish>::Decryption dec;
                            dec.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data());
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(dec,
                                    new CryptoPP::StringSink(result)));
                        }
                        break;
                    }
                    default:
                        return STATUS_UNSUPPORTED_MODE;
                }
                break;
            }
            
            case ALGORITHM_RC6: {
                switch (mode) {
                    case MODE_CBC: {
                        if (operation == OPERATION_ENCRYPT) {
                            CryptoPP::CBC_Mode<CryptoPP::RC6>::Encryption enc;
                            enc.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data());
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(enc,
                                    new CryptoPP::StringSink(result)));
                        } else {
                            CryptoPP::CBC_Mode<CryptoPP::RC6>::Decryption dec;
                            dec.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data());
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(dec,
                                    new CryptoPP::StringSink(result)));
                        }
                        break;
                    }
                    case MODE_ECB: {
                        if (operation == OPERATION_ENCRYPT) {
                            CryptoPP::ECB_Mode<CryptoPP::RC6>::Encryption enc;
                            enc.SetKey(derived_key.data(), key_len);
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(enc,
                                    new CryptoPP::StringSink(result)));
                        } else {
                            CryptoPP::ECB_Mode<CryptoPP::RC6>::Decryption dec;
                            dec.SetKey(derived_key.data(), key_len);
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(dec,
                                    new CryptoPP::StringSink(result)));
                        }
                        break;
                    }
                    case MODE_CFB: {
                        if (operation == OPERATION_ENCRYPT) {
                            CryptoPP::CFB_Mode<CryptoPP::RC6>::Encryption enc;
                            enc.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data());
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(enc,
                                    new CryptoPP::StringSink(result)));
                        } else {
                            CryptoPP::CFB_Mode<CryptoPP::RC6>::Decryption dec;
                            dec.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data());
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(dec,
                                    new CryptoPP::StringSink(result)));
                        }
                        break;
                    }
                    case MODE_OFB: {
                        if (operation == OPERATION_ENCRYPT) {
                            CryptoPP::OFB_Mode<CryptoPP::RC6>::Encryption enc;
                            enc.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data());
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(enc,
                                    new CryptoPP::StringSink(result)));
                        } else {
                            CryptoPP::OFB_Mode<CryptoPP::RC6>::Decryption dec;
                            dec.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data());
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(dec,
                                    new CryptoPP::StringSink(result)));
                        }
                        break;
                    }
                    case MODE_CTR: {
                        if (operation == OPERATION_ENCRYPT) {
                            CryptoPP::CTR_Mode<CryptoPP::RC6>::Encryption enc;
                            enc.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data());
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(enc,
                                    new CryptoPP::StringSink(result)));
                        } else {
                            CryptoPP::CTR_Mode<CryptoPP::RC6>::Decryption dec;
                            dec.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data());
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(dec,
                                    new CryptoPP::StringSink(result)));
                        }
                        break;
                    }
                    default:
                        return STATUS_UNSUPPORTED_MODE;
                }
                break;
            }
            
            case ALGORITHM_BLOWFISH: {
                switch (mode) {
                    case MODE_CBC: {
                        if (operation == OPERATION_ENCRYPT) {
                            CryptoPP::CBC_Mode<CryptoPP::Blowfish>::Encryption enc;
                            enc.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data(), 8); // Blowfish uses 8-byte IV
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(enc,
                                    new CryptoPP::StringSink(result)));
                        } else {
                            CryptoPP::CBC_Mode<CryptoPP::Blowfish>::Decryption dec;
                            dec.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data(), 8);
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(dec,
                                    new CryptoPP::StringSink(result)));
                        }
                        break;
                    }
                    case MODE_ECB: {
                        if (operation == OPERATION_ENCRYPT) {
                            CryptoPP::ECB_Mode<CryptoPP::Blowfish>::Encryption enc;
                            enc.SetKey(derived_key.data(), key_len);
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(enc,
                                    new CryptoPP::StringSink(result)));
                        } else {
                            CryptoPP::ECB_Mode<CryptoPP::Blowfish>::Decryption dec;
                            dec.SetKey(derived_key.data(), key_len);
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(dec,
                                    new CryptoPP::StringSink(result)));
                        }
                        break;
                    }
                    case MODE_CFB: {
                        if (operation == OPERATION_ENCRYPT) {
                            CryptoPP::CFB_Mode<CryptoPP::Blowfish>::Encryption enc;
                            enc.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data(), 8);
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(enc,
                                    new CryptoPP::StringSink(result)));
                        } else {
                            CryptoPP::CFB_Mode<CryptoPP::Blowfish>::Decryption dec;
                            dec.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data(), 8);
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(dec,
                                    new CryptoPP::StringSink(result)));
                        }
                        break;
                    }
                    case MODE_OFB: {
                        if (operation == OPERATION_ENCRYPT) {
                            CryptoPP::OFB_Mode<CryptoPP::Blowfish>::Encryption enc;
                            enc.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data(), 8);
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(enc,
                                    new CryptoPP::StringSink(result)));
                        } else {
                            CryptoPP::OFB_Mode<CryptoPP::Blowfish>::Decryption dec;
                            dec.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data(), 8);
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(dec,
                                    new CryptoPP::StringSink(result)));
                        }
                        break;
                    }
                    case MODE_CTR: {
                        if (operation == OPERATION_ENCRYPT) {
                            CryptoPP::CTR_Mode<CryptoPP::Blowfish>::Encryption enc;
                            enc.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data(), 8);
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(enc,
                                    new CryptoPP::StringSink(result)));
                        } else {
                            CryptoPP::CTR_Mode<CryptoPP::Blowfish>::Decryption dec;
                            dec.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data(), 8);
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(dec,
                                    new CryptoPP::StringSink(result)));
                        }
                        break;
                    }
                    default:
                        return STATUS_UNSUPPORTED_MODE;
                }
                break;
            }
            
            case ALGORITHM_CAST128: {
                switch (mode) {
                    case MODE_CBC: {
                        if (operation == OPERATION_ENCRYPT) {
                            CryptoPP::CBC_Mode<CryptoPP::CAST128>::Encryption enc;
                            enc.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data(), 8); // CAST128 uses 8-byte IV
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(enc,
                                    new CryptoPP::StringSink(result)));
                        } else {
                            CryptoPP::CBC_Mode<CryptoPP::CAST128>::Decryption dec;
                            dec.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data(), 8);
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(dec,
                                    new CryptoPP::StringSink(result)));
                        }
                        break;
                    }
                    case MODE_ECB: {
                        if (operation == OPERATION_ENCRYPT) {
                            CryptoPP::ECB_Mode<CryptoPP::CAST128>::Encryption enc;
                            enc.SetKey(derived_key.data(), key_len);
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(enc,
                                    new CryptoPP::StringSink(result)));
                        } else {
                            CryptoPP::ECB_Mode<CryptoPP::CAST128>::Decryption dec;
                            dec.SetKey(derived_key.data(), key_len);
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(dec,
                                    new CryptoPP::StringSink(result)));
                        }
                        break;
                    }
                    case MODE_CFB: {
                        if (operation == OPERATION_ENCRYPT) {
                            CryptoPP::CFB_Mode<CryptoPP::CAST128>::Encryption enc;
                            enc.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data(), 8);
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(enc,
                                    new CryptoPP::StringSink(result)));
                        } else {
                            CryptoPP::CFB_Mode<CryptoPP::CAST128>::Decryption dec;
                            dec.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data(), 8);
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(dec,
                                    new CryptoPP::StringSink(result)));
                        }
                        break;
                    }
                    case MODE_OFB: {
                        if (operation == OPERATION_ENCRYPT) {
                            CryptoPP::OFB_Mode<CryptoPP::CAST128>::Encryption enc;
                            enc.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data(), 8);
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(enc,
                                    new CryptoPP::StringSink(result)));
                        } else {
                            CryptoPP::OFB_Mode<CryptoPP::CAST128>::Decryption dec;
                            dec.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data(), 8);
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(dec,
                                    new CryptoPP::StringSink(result)));
                        }
                        break;
                    }
                    case MODE_CTR: {
                        if (operation == OPERATION_ENCRYPT) {
                            CryptoPP::CTR_Mode<CryptoPP::CAST128>::Encryption enc;
                            enc.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data(), 8);
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(enc,
                                    new CryptoPP::StringSink(result)));
                        } else {
                            CryptoPP::CTR_Mode<CryptoPP::CAST128>::Decryption dec;
                            dec.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data(), 8);
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(dec,
                                    new CryptoPP::StringSink(result)));
                        }
                        break;
                    }
                    default:
                        return STATUS_UNSUPPORTED_MODE;
                }
                break;
            }
            
            case ALGORITHM_MARS: {
                switch (mode) {
                    case MODE_CBC: {
                        if (operation == OPERATION_ENCRYPT) {
                            CryptoPP::CBC_Mode<CryptoPP::MARS>::Encryption enc;
                            enc.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data());
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(enc,
                                    new CryptoPP::StringSink(result)));
                        } else {
                            CryptoPP::CBC_Mode<CryptoPP::MARS>::Decryption dec;
                            dec.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data());
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(dec,
                                    new CryptoPP::StringSink(result)));
                        }
                        break;
                    }
                    case MODE_ECB: {
                        if (operation == OPERATION_ENCRYPT) {
                            CryptoPP::ECB_Mode<CryptoPP::MARS>::Encryption enc;
                            enc.SetKey(derived_key.data(), key_len);
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(enc,
                                    new CryptoPP::StringSink(result)));
                        } else {
                            CryptoPP::ECB_Mode<CryptoPP::MARS>::Decryption dec;
                            dec.SetKey(derived_key.data(), key_len);
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(dec,
                                    new CryptoPP::StringSink(result)));
                        }
                        break;
                    }
                    case MODE_CFB: {
                        if (operation == OPERATION_ENCRYPT) {
                            CryptoPP::CFB_Mode<CryptoPP::MARS>::Encryption enc;
                            enc.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data());
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(enc,
                                    new CryptoPP::StringSink(result)));
                        } else {
                            CryptoPP::CFB_Mode<CryptoPP::MARS>::Decryption dec;
                            dec.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data());
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(dec,
                                    new CryptoPP::StringSink(result)));
                        }
                        break;
                    }
                    case MODE_OFB: {
                        if (operation == OPERATION_ENCRYPT) {
                            CryptoPP::OFB_Mode<CryptoPP::MARS>::Encryption enc;
                            enc.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data());
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(enc,
                                    new CryptoPP::StringSink(result)));
                        } else {
                            CryptoPP::OFB_Mode<CryptoPP::MARS>::Decryption dec;
                            dec.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data());
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(dec,
                                    new CryptoPP::StringSink(result)));
                        }
                        break;
                    }
                    case MODE_CTR: {
                        if (operation == OPERATION_ENCRYPT) {
                            CryptoPP::CTR_Mode<CryptoPP::MARS>::Encryption enc;
                            enc.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data());
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(enc,
                                    new CryptoPP::StringSink(result)));
                        } else {
                            CryptoPP::CTR_Mode<CryptoPP::MARS>::Decryption dec;
                            dec.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data());
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(dec,
                                    new CryptoPP::StringSink(result)));
                        }
                        break;
                    }
                    default:
                        return STATUS_UNSUPPORTED_MODE;
                }
                break;
            }
            
            case ALGORITHM_CAMELLIA: {
                switch (mode) {
                    case MODE_CBC: {
                        if (operation == OPERATION_ENCRYPT) {
                            CryptoPP::CBC_Mode<CryptoPP::Camellia>::Encryption enc;
                            enc.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data());
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(enc,
                                    new CryptoPP::StringSink(result)));
                        } else {
                            CryptoPP::CBC_Mode<CryptoPP::Camellia>::Decryption dec;
                            dec.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data());
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(dec,
                                    new CryptoPP::StringSink(result)));
                        }
                        break;
                    }
                    case MODE_GCM: {
                        if (operation == OPERATION_ENCRYPT) {
                            CryptoPP::GCM<CryptoPP::Camellia>::Encryption enc;
                            enc.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data(), iv_len);
                            CryptoPP::AuthenticatedEncryptionFilter aef(enc,
                                new CryptoPP::StringSink(result));
                            aef.Put((const CryptoPP::byte*)input_data, input_len);
                            aef.MessageEnd();
                            
                            // Extract authentication tag if provided
                            if (auth_tag) {
                                std::memcpy(auth_tag, result.data() + input_len, 16);
                                result.resize(input_len);
                            }
                        } else {
                            CryptoPP::GCM<CryptoPP::Camellia>::Decryption dec;
                            dec.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data(), iv_len);
                            CryptoPP::AuthenticatedDecryptionFilter adf(dec,
                                new CryptoPP::StringSink(result));
                            adf.Put((const CryptoPP::byte*)input_data, input_len);
                            if (auth_tag) {
                                adf.Put(auth_tag, 16);
                            }
                            adf.MessageEnd();
                        }
                        break;
                    }
                    case MODE_ECB: {
                        if (operation == OPERATION_ENCRYPT) {
                            CryptoPP::ECB_Mode<CryptoPP::Camellia>::Encryption enc;
                            enc.SetKey(derived_key.data(), key_len);
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(enc,
                                    new CryptoPP::StringSink(result)));
                        } else {
                            CryptoPP::ECB_Mode<CryptoPP::Camellia>::Decryption dec;
                            dec.SetKey(derived_key.data(), key_len);
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(dec,
                                    new CryptoPP::StringSink(result)));
                        }
                        break;
                    }
                    case MODE_CFB: {
                        if (operation == OPERATION_ENCRYPT) {
                            CryptoPP::CFB_Mode<CryptoPP::Camellia>::Encryption enc;
                            enc.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data());
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(enc,
                                    new CryptoPP::StringSink(result)));
                        } else {
                            CryptoPP::CFB_Mode<CryptoPP::Camellia>::Decryption dec;
                            dec.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data());
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(dec,
                                    new CryptoPP::StringSink(result)));
                        }
                        break;
                    }
                    case MODE_OFB: {
                        if (operation == OPERATION_ENCRYPT) {
                            CryptoPP::OFB_Mode<CryptoPP::Camellia>::Encryption enc;
                            enc.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data());
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(enc,
                                    new CryptoPP::StringSink(result)));
                        } else {
                            CryptoPP::OFB_Mode<CryptoPP::Camellia>::Decryption dec;
                            dec.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data());
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(dec,
                                    new CryptoPP::StringSink(result)));
                        }
                        break;
                    }
                    case MODE_CTR: {
                        if (operation == OPERATION_ENCRYPT) {
                            CryptoPP::CTR_Mode<CryptoPP::Camellia>::Encryption enc;
                            enc.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data());
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(enc,
                                    new CryptoPP::StringSink(result)));
                        } else {
                            CryptoPP::CTR_Mode<CryptoPP::Camellia>::Decryption dec;
                            dec.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data());
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(dec,
                                    new CryptoPP::StringSink(result)));
                        }
                        break;
                    }
                    default:
                        return STATUS_UNSUPPORTED_MODE;
                }
                break;
            }
            
            // Stream Ciphers (CTR mode only)
            case ALGORITHM_CHACHA20: {
                if (mode != MODE_CTR) {
                    return STATUS_UNSUPPORTED_MODE;
                }
                
                if (operation == OPERATION_ENCRYPT) {
                    CryptoPP::ChaChaTLS::Encryption enc;
                    enc.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data(), 12); // ChaChaTLS uses 12-byte nonce
                    CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                        new CryptoPP::StreamTransformationFilter(enc,
                            new CryptoPP::StringSink(result), CryptoPP::StreamTransformationFilter::NO_PADDING));
                } else {
                    CryptoPP::ChaChaTLS::Decryption dec;
                    dec.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data(), 12);
                    CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                        new CryptoPP::StreamTransformationFilter(dec,
                            new CryptoPP::StringSink(result), CryptoPP::StreamTransformationFilter::NO_PADDING));
                }
                break;
            }
            
            case ALGORITHM_SALSA20: {
                if (mode != MODE_CTR) {
                    return STATUS_UNSUPPORTED_MODE;
                }
                
                if (operation == OPERATION_ENCRYPT) {
                    CryptoPP::Salsa20::Encryption enc;
                    enc.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data(), 8); // Salsa20 uses 8-byte IV
                    CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                        new CryptoPP::StreamTransformationFilter(enc,
                            new CryptoPP::StringSink(result), CryptoPP::StreamTransformationFilter::NO_PADDING));
                } else {
                    CryptoPP::Salsa20::Decryption dec;
                    dec.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data(), 8);
                    CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                        new CryptoPP::StreamTransformationFilter(dec,
                            new CryptoPP::StringSink(result), CryptoPP::StreamTransformationFilter::NO_PADDING));
                }
                break;
            }
            
            case ALGORITHM_XSALSA20: {
                if (mode != MODE_CTR) {
                    return STATUS_UNSUPPORTED_MODE;
                }
                
                if (operation == OPERATION_ENCRYPT) {
                    CryptoPP::XSalsa20::Encryption enc;
                    enc.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data(), 24); // XSalsa20 uses 24-byte nonce
                    CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                        new CryptoPP::StreamTransformationFilter(enc,
                            new CryptoPP::StringSink(result), CryptoPP::StreamTransformationFilter::NO_PADDING));
                } else {
                    CryptoPP::XSalsa20::Decryption dec;
                    dec.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data(), 24);
                    CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                        new CryptoPP::StreamTransformationFilter(dec,
                            new CryptoPP::StringSink(result), CryptoPP::StreamTransformationFilter::NO_PADDING));
                }
                break;
            }
            
            case ALGORITHM_IDEA: {
                switch (mode) {
                    case MODE_CBC: {
                        if (operation == OPERATION_ENCRYPT) {
                            CryptoPP::CBC_Mode<CryptoPP::IDEA>::Encryption enc;
                            enc.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data(), 8);
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(enc,
                                    new CryptoPP::StringSink(result)));
                        } else {
                            CryptoPP::CBC_Mode<CryptoPP::IDEA>::Decryption dec;
                            dec.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data(), 8);
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(dec,
                                    new CryptoPP::StringSink(result)));
                        }
                        break;
                    }
                    case MODE_ECB: {
                        if (operation == OPERATION_ENCRYPT) {
                            CryptoPP::ECB_Mode<CryptoPP::IDEA>::Encryption enc;
                            enc.SetKey(derived_key.data(), key_len);
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(enc,
                                    new CryptoPP::StringSink(result)));
                        } else {
                            CryptoPP::ECB_Mode<CryptoPP::IDEA>::Decryption dec;
                            dec.SetKey(derived_key.data(), key_len);
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(dec,
                                    new CryptoPP::StringSink(result)));
                        }
                        break;
                    }
                    case MODE_CFB: {
                        if (operation == OPERATION_ENCRYPT) {
                            CryptoPP::CFB_Mode<CryptoPP::IDEA>::Encryption enc;
                            enc.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data(), 8);
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(enc,
                                    new CryptoPP::StringSink(result)));
                        } else {
                            CryptoPP::CFB_Mode<CryptoPP::IDEA>::Decryption dec;
                            dec.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data(), 8);
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(dec,
                                    new CryptoPP::StringSink(result)));
                        }
                        break;
                    }
                    case MODE_OFB: {
                        if (operation == OPERATION_ENCRYPT) {
                            CryptoPP::OFB_Mode<CryptoPP::IDEA>::Encryption enc;
                            enc.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data(), 8);
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(enc,
                                    new CryptoPP::StringSink(result)));
                        } else {
                            CryptoPP::OFB_Mode<CryptoPP::IDEA>::Decryption dec;
                            dec.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data(), 8);
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(dec,
                                    new CryptoPP::StringSink(result)));
                        }
                        break;
                    }
                    case MODE_CTR: {
                        if (operation == OPERATION_ENCRYPT) {
                            CryptoPP::CTR_Mode<CryptoPP::IDEA>::Encryption enc;
                            enc.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data(), 8);
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(enc,
                                    new CryptoPP::StringSink(result)));
                        } else {
                            CryptoPP::CTR_Mode<CryptoPP::IDEA>::Decryption dec;
                            dec.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data(), 8);
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(dec,
                                    new CryptoPP::StringSink(result)));
                        }
                        break;
                    }
                    default:
                        return STATUS_UNSUPPORTED_MODE;
                }
                break;
            }
            
            case ALGORITHM_DES3: {
                switch (mode) {
                    case MODE_CBC: {
                        if (operation == OPERATION_ENCRYPT) {
                            CryptoPP::CBC_Mode<CryptoPP::DES_EDE3>::Encryption enc;
                            enc.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data(), 8);
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(enc,
                                    new CryptoPP::StringSink(result)));
                        } else {
                            CryptoPP::CBC_Mode<CryptoPP::DES_EDE3>::Decryption dec;
                            dec.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data(), 8);
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(dec,
                                    new CryptoPP::StringSink(result)));
                        }
                        break;
                    }
                    case MODE_ECB: {
                        if (operation == OPERATION_ENCRYPT) {
                            CryptoPP::ECB_Mode<CryptoPP::DES_EDE3>::Encryption enc;
                            enc.SetKey(derived_key.data(), key_len);
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(enc,
                                    new CryptoPP::StringSink(result)));
                        } else {
                            CryptoPP::ECB_Mode<CryptoPP::DES_EDE3>::Decryption dec;
                            dec.SetKey(derived_key.data(), key_len);
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(dec,
                                    new CryptoPP::StringSink(result)));
                        }
                        break;
                    }
                    default:
                        return STATUS_UNSUPPORTED_MODE;
                }
                break;
            }
            
            case ALGORITHM_RC4: {
                if (mode != MODE_CTR) {
                    return STATUS_UNSUPPORTED_MODE;
                }
                
                if (operation == OPERATION_ENCRYPT) {
                    CryptoPP::Weak::ARC4::Encryption enc;
                    enc.SetKey(derived_key.data(), key_len);
                    CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                        new CryptoPP::StreamTransformationFilter(enc,
                            new CryptoPP::StringSink(result), CryptoPP::StreamTransformationFilter::NO_PADDING));
                } else {
                    CryptoPP::Weak::ARC4::Decryption dec;
                    dec.SetKey(derived_key.data(), key_len);
                    CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                        new CryptoPP::StreamTransformationFilter(dec,
                            new CryptoPP::StringSink(result), CryptoPP::StreamTransformationFilter::NO_PADDING));
                }
                break;
            }
            
            case ALGORITHM_TEA: {
                switch (mode) {
                    case MODE_CBC: {
                        if (operation == OPERATION_ENCRYPT) {
                            CryptoPP::CBC_Mode<CryptoPP::TEA>::Encryption enc;
                            enc.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data(), 8);
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(enc,
                                    new CryptoPP::StringSink(result)));
                        } else {
                            CryptoPP::CBC_Mode<CryptoPP::TEA>::Decryption dec;
                            dec.SetKeyWithIV(derived_key.data(), key_len, derived_iv.data(), 8);
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(dec,
                                    new CryptoPP::StringSink(result)));
                        }
                        break;
                    }
                    case MODE_ECB: {
                        if (operation == OPERATION_ENCRYPT) {
                            CryptoPP::ECB_Mode<CryptoPP::TEA>::Encryption enc;
                            enc.SetKey(derived_key.data(), key_len);
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(enc,
                                    new CryptoPP::StringSink(result)));
                        } else {
                            CryptoPP::ECB_Mode<CryptoPP::TEA>::Decryption dec;
                            dec.SetKey(derived_key.data(), key_len);
                            CryptoPP::StringSource ss((const CryptoPP::byte*)input_data, input_len, true,
                                new CryptoPP::StreamTransformationFilter(dec,
                                    new CryptoPP::StringSink(result)));
                        }
                        break;
                    }
                    default:
                        return STATUS_UNSUPPORTED_MODE;
                }
                break;
            }
            
            default:
                return STATUS_UNSUPPORTED_ALGORITHM;
        }
        
        // Copy result to output buffer
        int actual_len = static_cast<int>(result.length());
        if (actual_len > *output_len) {
            *output_len = actual_len;
            return STATUS_OUTPUT_BUFFER_TOO_SMALL;
        }
        
        std::memcpy(output_data, result.data(), actual_len);
        *output_len = actual_len;
        
        return STATUS_SUCCESS;
        
    } catch (const CryptoPP::Exception& e) {
        return STATUS_CRYPTO_ERROR;
    } catch (const std::exception& e) {
        return STATUS_UNKNOWN_ERROR;
    } catch (...) {
        return STATUS_UNKNOWN_ERROR;
    }
}

/**
 * Get version string of the crypto bridge
 */
const char* crypto_bridge_version() {
    return "1.0.0";
}

} // extern "C"

// Helper function implementations
static int validate_algorithm_key_size(int algorithm, int key_size_bits) {
    switch (algorithm) {
        case ALGORITHM_AES:
        case ALGORITHM_SERPENT:
        case ALGORITHM_TWOFISH:
        case ALGORITHM_RC6:
            return (key_size_bits == 128 || key_size_bits == 192 || key_size_bits == 256) 
                   ? STATUS_SUCCESS : STATUS_INVALID_KEY_SIZE;
        
        case ALGORITHM_BLOWFISH:
            return (key_size_bits >= 32 && key_size_bits <= 448 && (key_size_bits % 8) == 0)
                   ? STATUS_SUCCESS : STATUS_INVALID_KEY_SIZE;
        
        case ALGORITHM_CAST128:
            return (key_size_bits == 128) ? STATUS_SUCCESS : STATUS_INVALID_KEY_SIZE;
            
        case ALGORITHM_CAST256:
            return (key_size_bits == 128 || key_size_bits == 160 || key_size_bits == 192 || 
                    key_size_bits == 224 || key_size_bits == 256) 
                   ? STATUS_SUCCESS : STATUS_INVALID_KEY_SIZE;
                   
        case ALGORITHM_CAMELLIA:
        case ALGORITHM_ARIA:
            return (key_size_bits == 128 || key_size_bits == 192 || key_size_bits == 256) 
                   ? STATUS_SUCCESS : STATUS_INVALID_KEY_SIZE;
                   
        case ALGORITHM_MARS:
            return (key_size_bits == 128 || key_size_bits == 192 || key_size_bits == 256) 
                   ? STATUS_SUCCESS : STATUS_INVALID_KEY_SIZE;
                   
        case ALGORITHM_RC5:
            return (key_size_bits >= 64 && key_size_bits <= 256 && (key_size_bits % 8) == 0)
                   ? STATUS_SUCCESS : STATUS_INVALID_KEY_SIZE;
                   
        case ALGORITHM_SKIPJACK:
            return (key_size_bits == 80) ? STATUS_SUCCESS : STATUS_INVALID_KEY_SIZE;
            
        case ALGORITHM_SEED:
        case ALGORITHM_SM4:
        case ALGORITHM_IDEA:
        case ALGORITHM_TEA:
        case ALGORITHM_XTEA:
        case ALGORITHM_SQUARE:
        case ALGORITHM_SHARK:
            return (key_size_bits == 128) ? STATUS_SUCCESS : STATUS_INVALID_KEY_SIZE;
            
        case ALGORITHM_GOST28147:
        case ALGORITHM_CHACHA20:
        case ALGORITHM_XSALSA20:
        case ALGORITHM_HC256:
        case ALGORITHM_PANAMA:
            return (key_size_bits == 256) ? STATUS_SUCCESS : STATUS_INVALID_KEY_SIZE;
            
        case ALGORITHM_SALSA20:
        case ALGORITHM_HC128:
        case ALGORITHM_RABBIT:
        case ALGORITHM_WAKE:
            return (key_size_bits == 128 || key_size_bits == 256) 
                   ? STATUS_SUCCESS : STATUS_INVALID_KEY_SIZE;
                   
        case ALGORITHM_SOSEMANUK:
            return (key_size_bits == 128 || key_size_bits == 256) 
                   ? STATUS_SUCCESS : STATUS_INVALID_KEY_SIZE;
                   
        case ALGORITHM_DES3:
            return (key_size_bits == 192) ? STATUS_SUCCESS : STATUS_INVALID_KEY_SIZE; // 3DES uses 192-bit keys
            
        case ALGORITHM_RC2:
            return (key_size_bits == 40 || key_size_bits == 64 || key_size_bits == 128) 
                   ? STATUS_SUCCESS : STATUS_INVALID_KEY_SIZE;
                   
        case ALGORITHM_SAFER:
            return (key_size_bits == 64 || key_size_bits == 128) 
                   ? STATUS_SUCCESS : STATUS_INVALID_KEY_SIZE;
                   
        case ALGORITHM_SAFER_PLUS:
            return (key_size_bits == 128 || key_size_bits == 192 || key_size_bits == 256) 
                   ? STATUS_SUCCESS : STATUS_INVALID_KEY_SIZE;
                   
        case ALGORITHM_DES:
            return (key_size_bits == 56) ? STATUS_SUCCESS : STATUS_INVALID_KEY_SIZE; // Effective key length
            
        case ALGORITHM_RC4:
            return (key_size_bits >= 40 && key_size_bits <= 256 && (key_size_bits % 8) == 0)
                   ? STATUS_SUCCESS : STATUS_INVALID_KEY_SIZE;
                   
        case ALGORITHM_THREEFISH256:
            return (key_size_bits == 256) ? STATUS_SUCCESS : STATUS_INVALID_KEY_SIZE;
            
        case ALGORITHM_THREEFISH512:
            return (key_size_bits == 512) ? STATUS_SUCCESS : STATUS_INVALID_KEY_SIZE;
            
        case ALGORITHM_THREEFISH1024:
            return (key_size_bits == 1024) ? STATUS_SUCCESS : STATUS_INVALID_KEY_SIZE;
            
        case ALGORITHM_SHACAL2:
            return (key_size_bits == 128 || key_size_bits == 192 || key_size_bits == 256 || 
                    key_size_bits == 384 || key_size_bits == 512) 
                   ? STATUS_SUCCESS : STATUS_INVALID_KEY_SIZE;
                   
        case ALGORITHM_SEAL:
            return (key_size_bits == 160) ? STATUS_SUCCESS : STATUS_INVALID_KEY_SIZE;
            
        // Placeholder algorithms not implemented in Crypto++
        case ALGORITHM_LUCIFER:
        case ALGORITHM_SIMON:
        case ALGORITHM_SPECK:
            return STATUS_UNSUPPORTED_ALGORITHM;
            
        default:
            return STATUS_UNSUPPORTED_ALGORITHM;
    }
}

static int validate_algorithm_mode_combination(int algorithm, int mode) {
    // Stream ciphers only support CTR-like operation
    switch (algorithm) {
        case ALGORITHM_CHACHA20:
        case ALGORITHM_SALSA20:
        case ALGORITHM_XSALSA20:
        case ALGORITHM_HC128:
        case ALGORITHM_HC256:
        case ALGORITHM_RABBIT:
        case ALGORITHM_SOSEMANUK:
        case ALGORITHM_RC4:
        case ALGORITHM_WAKE:
        case ALGORITHM_PANAMA:
        case ALGORITHM_SEAL:
            return (mode == MODE_CTR) ? STATUS_SUCCESS : STATUS_UNSUPPORTED_MODE;
    }
    
    // Block cipher mode validation
    switch (mode) {
        case MODE_CBC:
        case MODE_ECB:
        case MODE_CFB:
        case MODE_OFB:
        case MODE_CTR:
            return STATUS_SUCCESS;
        
        case MODE_GCM:
            // Only AES, Serpent, Twofish, Camellia, and ARIA support GCM mode effectively
            switch (algorithm) {
                case ALGORITHM_AES:
                case ALGORITHM_SERPENT:
                case ALGORITHM_TWOFISH:
                case ALGORITHM_CAMELLIA:
                case ALGORITHM_ARIA:
                    return STATUS_SUCCESS;
                default:
                    return STATUS_UNSUPPORTED_MODE;
            }
        
        default:
            return STATUS_UNSUPPORTED_MODE;
    }
}

static int derive_key_and_iv(const char* password, int password_len,
                           unsigned char* key, int key_len,
                           unsigned char* iv, int iv_len) {
    try {
        // Use PBKDF2 with SHA256 for key derivation
        CryptoPP::PKCS5_PBKDF2_HMAC<CryptoPP::SHA256> pbkdf2;
        
        // Simple salt (in production, this should be random and stored)
        const CryptoPP::byte salt[] = "CryptingTool2024";
        const int iterations = 10000;
        
        // Derive key
        pbkdf2.DeriveKey(key, key_len,
                        0x00, // purpose byte
                        (const CryptoPP::byte*)password, password_len,
                        salt, sizeof(salt) - 1, // exclude null terminator
                        iterations);
        
        // Derive IV (using different purpose byte)
        pbkdf2.DeriveKey(iv, iv_len,
                        0x01, // different purpose byte for IV
                        (const CryptoPP::byte*)password, password_len,
                        salt, sizeof(salt) - 1,
                        iterations);
        
        return STATUS_SUCCESS;
    } catch (...) {
        return STATUS_CRYPTO_ERROR;
    }
}