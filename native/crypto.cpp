#include "crypto.h"
#include <cstring>
#include <cstdlib>

// Simple Caesar cipher implementation
char* simple_encrypt(const char* text) {
    if (!text) return nullptr;
    
    size_t len = strlen(text);
    char* result = (char*)malloc(len + 1);
    if (!result) return nullptr;
    
    const int shift = 3;
    
    for (size_t i = 0; i < len; i++) {
        char c = text[i];
        if (c >= 'A' && c <= 'Z') {
            result[i] = ((c - 'A' + shift) % 26) + 'A';
        } else if (c >= 'a' && c <= 'z') {
            result[i] = ((c - 'a' + shift) % 26) + 'a';
        } else {
            result[i] = c;
        }
    }
    
    result[len] = '\0';
    return result;
}

void free_string(char* str) {
    if (str) {
        free(str);
    }
}