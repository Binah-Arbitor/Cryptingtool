#ifndef CRYPTO_H
#define CRYPTO_H

#ifdef __cplusplus
extern "C" {
#endif

// Simple encryption function
char* simple_encrypt(const char* text);

// Memory cleanup function
void free_string(char* str);

#ifdef __cplusplus
}
#endif

#endif // CRYPTO_H