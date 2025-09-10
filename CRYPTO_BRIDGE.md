# Crypto Bridge Documentation

## Overview

The `crypto_bridge.cpp` file provides a comprehensive, FFI-compatible C interface to the Crypto++ library for use with Flutter applications. It implements a single, self-contained function that handles all supported encryption algorithms, modes, and key lengths with explicit hardcoded support (no dynamic factories).

## Supported Algorithms and Configurations

### Algorithms
- **AES** (Advanced Encryption Standard): 128, 192, 256-bit keys
- **Serpent**: 128, 192, 256-bit keys  
- **Twofish**: 128, 192, 256-bit keys
- **RC6**: 128, 192, 256-bit keys
- **Blowfish**: 32, 64, 128, 256, 448-bit keys (variable length)
- **CAST-128**: 128-bit keys only

### Operation Modes
- **CBC** (Cipher Block Chaining): Supported by all algorithms
- **GCM** (Galois/Counter Mode): AES only - provides authenticated encryption
- **ECB** (Electronic Codebook): Supported by all algorithms
- **CFB** (Cipher Feedback): Supported by all algorithms
- **OFB** (Output Feedback): Supported by all algorithms  
- **CTR** (Counter Mode): Supported by all algorithms

## FFI Function Signature

```c
int crypto_bridge_process(
    int algorithm,              // Algorithm identifier (1-6)
    int mode,                   // Mode identifier (1-6)  
    int key_size_bits,          // Key size in bits
    int operation,              // 1=encrypt, 2=decrypt
    const char* password,       // Password string (null-terminated)
    int password_len,           // Length of password (excluding null)
    const unsigned char* input_data,    // Input data buffer
    int input_len,              // Length of input data
    unsigned char* output_data, // Output buffer (caller allocated)
    int* output_len,            // Pointer to output buffer size (in/out)
    unsigned char* iv,          // IV buffer (16 bytes, optional)
    unsigned char* auth_tag     // Auth tag for GCM (16 bytes, optional)
);
```

## Constants

### Algorithm IDs
```c
#define CRYPTO_ALGORITHM_AES      1
#define CRYPTO_ALGORITHM_SERPENT  2  
#define CRYPTO_ALGORITHM_TWOFISH  3
#define CRYPTO_ALGORITHM_RC6      4
#define CRYPTO_ALGORITHM_BLOWFISH 5
#define CRYPTO_ALGORITHM_CAST128  6
```

### Mode IDs
```c
#define CRYPTO_MODE_CBC  1
#define CRYPTO_MODE_GCM  2
#define CRYPTO_MODE_ECB  3
#define CRYPTO_MODE_CFB  4
#define CRYPTO_MODE_OFB  5
#define CRYPTO_MODE_CTR  6
```

### Operation IDs
```c
#define CRYPTO_OPERATION_ENCRYPT  1
#define CRYPTO_OPERATION_DECRYPT  2
```

### Status Codes
```c
#define CRYPTO_STATUS_SUCCESS                  0
#define CRYPTO_STATUS_INVALID_PARAMS          -1
#define CRYPTO_STATUS_UNSUPPORTED_ALGORITHM   -2
#define CRYPTO_STATUS_UNSUPPORTED_MODE        -3
#define CRYPTO_STATUS_INVALID_KEY_SIZE        -4
#define CRYPTO_STATUS_MEMORY_ERROR            -5
#define CRYPTO_STATUS_CRYPTO_ERROR            -6
#define CRYPTO_STATUS_PASSWORD_TOO_SHORT      -7
#define CRYPTO_STATUS_OUTPUT_BUFFER_TOO_SMALL -8
#define CRYPTO_STATUS_UNKNOWN_ERROR           -9
```

## Flutter Integration

### 1. Define FFI Types

Create these type definitions in your Flutter/Dart code:

```dart
// C function signature for crypto_bridge_process
typedef CryptoBridgeProcessC = ffi.Int32 Function(
  ffi.Int32 algorithm,
  ffi.Int32 mode,
  ffi.Int32 keySize,
  ffi.Int32 operation,
  ffi.Pointer<ffi.Utf8> password,
  ffi.Int32 passwordLen,
  ffi.Pointer<ffi.Uint8> inputData,
  ffi.Int32 inputLen,
  ffi.Pointer<ffi.Uint8> outputData,
  ffi.Pointer<ffi.Int32> outputLen,
  ffi.Pointer<ffi.Uint8> iv,
  ffi.Pointer<ffi.Uint8> authTag
);

// Dart function signature  
typedef CryptoBridgeProcess = int Function(
  int algorithm,
  int mode,
  int keySize,
  int operation,
  ffi.Pointer<ffi.Utf8> password,
  int passwordLen,
  ffi.Pointer<ffi.Uint8> inputData,
  int inputLen,
  ffi.Pointer<ffi.Uint8> outputData,
  ffi.Pointer<ffi.Int32> outputLen,
  ffi.Pointer<ffi.Uint8> iv,
  ffi.Pointer<ffi.Uint8> authTag
);

// Version function
typedef CryptoBridgeVersionC = ffi.Pointer<ffi.Utf8> Function();
typedef CryptoBridgeVersion = ffi.Pointer<ffi.Utf8> Function();
```

### 2. Load the Library

```dart
class CryptoBridge {
  static ffi.DynamicLibrary? _lib;
  static CryptoBridgeProcess? _process;
  static CryptoBridgeVersion? _version;

  static void initialize() {
    try {
      if (Platform.isWindows) {
        _lib = ffi.DynamicLibrary.open('crypting.dll');
      } else if (Platform.isMacOS) {
        _lib = ffi.DynamicLibrary.open('libcrypting.dylib');
      } else {
        _lib = ffi.DynamicLibrary.open('libcrypting.so');
      }

      _process = _lib!.lookupFunction<CryptoBridgeProcessC, CryptoBridgeProcess>('crypto_bridge_process');
      _version = _lib!.lookupFunction<CryptoBridgeVersionC, CryptoBridgeVersion>('crypto_bridge_version');
    } catch (e) {
      print('Failed to load crypto bridge: $e');
    }
  }
}
```

### 3. Usage Example

```dart
class CryptoExample {
  static Future<String?> encryptAES256GCM(String plaintext, String password) async {
    if (CryptoBridge._process == null) return null;

    // Convert strings to C-compatible format
    final passwordPtr = password.toNativeUtf8();
    final inputPtr = malloc<ffi.Uint8>(plaintext.length);
    final outputPtr = malloc<ffi.Uint8>(plaintext.length + 32); // Extra space for padding
    final outputLenPtr = malloc<ffi.Int32>();
    final ivPtr = malloc<ffi.Uint8>(16);
    final authTagPtr = malloc<ffi.Uint8>(16);

    try {
      // Copy input data
      for (int i = 0; i < plaintext.length; i++) {
        inputPtr[i] = plaintext.codeUnitAt(i);
      }
      outputLenPtr.value = plaintext.length + 32;

      // Call crypto_bridge_process
      final result = CryptoBridge._process!(
        1,  // CRYPTO_ALGORITHM_AES
        2,  // CRYPTO_MODE_GCM
        256, // 256-bit key
        1,  // CRYPTO_OPERATION_ENCRYPT
        passwordPtr,
        password.length,
        inputPtr,
        plaintext.length,
        outputPtr,
        outputLenPtr,
        ivPtr,
        authTagPtr
      );

      if (result == 0) {
        // Success - convert result to base64 or hex
        final encryptedBytes = outputPtr.asTypedList(outputLenPtr.value);
        final ivBytes = ivPtr.asTypedList(16);
        final authTagBytes = authTagPtr.asTypedList(16);
        
        // Combine encrypted data + IV + auth tag for storage
        final combined = <int>[];
        combined.addAll(ivBytes);
        combined.addAll(authTagBytes);
        combined.addAll(encryptedBytes);
        
        return base64Encode(combined);
      } else {
        print('Encryption failed with error: $result');
        return null;
      }
    } finally {
      // Always free allocated memory
      malloc.free(passwordPtr);
      malloc.free(inputPtr);
      malloc.free(outputPtr);
      malloc.free(outputLenPtr);
      malloc.free(ivPtr);
      malloc.free(authTagPtr);
    }
  }
}
```

## Key Derivation

The crypto bridge uses PBKDF2 with SHA-256 for key derivation from passwords:
- **Hash Function**: SHA-256
- **Iterations**: 10,000
- **Salt**: "CryptingTool2024" (hardcoded for consistency)
- **Key and IV**: Derived separately using different purpose bytes

## Memory Management

- **Output Buffer**: Must be allocated by the caller with sufficient size
- **Buffer Size**: For encryption, allow extra space for padding (typically +16 bytes)
- **IV Buffer**: Always 16 bytes (except Blowfish/CAST-128 which use 8 bytes internally)
- **Auth Tag**: 16 bytes for GCM mode only

## Error Handling

Always check the return value:
- **0**: Success
- **Negative values**: Various error conditions (see status codes above)

For buffer size errors (-8), the function updates `*output_len` with the required size.

## Security Notes

1. **Password Requirements**: Minimum 8 characters
2. **IV Generation**: Deterministically derived from password for consistency
3. **GCM Mode**: Provides both encryption and authentication
4. **CBC/ECB Modes**: Add PKCS padding automatically
5. **Stream Modes** (CFB/OFB/CTR): No padding required

## Building

Ensure you have the Crypto++ library installed and link it in your CMakeLists.txt:

```cmake
find_library(CRYPTOPP_LIB cryptopp REQUIRED)
target_link_libraries(your_target ${CRYPTOPP_LIB})
```

## Testing

The implementation has been thoroughly tested with:
- All algorithm/mode combinations
- Various key sizes
- Encryption/decryption roundtrips
- Error condition handling
- Invalid parameter validation

See `comprehensive_test.cpp` for complete test coverage.