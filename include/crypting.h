#ifndef CRYPTING_H
#define CRYPTING_H

#ifdef __cplusplus
extern "C" {
#endif

// Simple encryption/decryption functions for demonstration
int encrypt_data(const char* input, char* output, int length);
int decrypt_data(const char* input, char* output, int length);
const char* get_version();

#ifdef __cplusplus
}
#endif

#endif // CRYPTING_H