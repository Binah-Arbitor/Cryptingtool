#include "../include/crypting.h"
#include <string.h>

// Simple XOR encryption for demonstration
int encrypt_data(const char* input, char* output, int length) {
    if (!input || !output || length <= 0) {
        return -1;
    }
    
    const char key = 0x42; // Simple key
    for (int i = 0; i < length; i++) {
        output[i] = input[i] ^ key;
    }
    return 0;
}

// Simple XOR decryption (same as encryption with XOR)
int decrypt_data(const char* input, char* output, int length) {
    return encrypt_data(input, output, length);
}

const char* get_version() {
    return "1.0.0";
}