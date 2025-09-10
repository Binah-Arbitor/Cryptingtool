#ifndef CRYPTING_H
#define CRYPTING_H

#ifdef __cplusplus
extern "C" {
#endif

// Simple encryption/decryption functions for demonstration
int encrypt_data(const char* input, char* output, int length);
int decrypt_data(const char* input, char* output, int length);
const char* get_version();

// Crypto++ Bridge Functions - see crypto_bridge.h for detailed documentation
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

const char* crypto_bridge_version(void);

#ifdef __cplusplus
}
#endif

#endif // CRYPTING_H