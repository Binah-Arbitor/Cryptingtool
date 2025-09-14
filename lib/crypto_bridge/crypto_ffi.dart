import 'dart:ffi' as ffi;
import 'dart:io';
import 'dart:typed_data';
import 'package:ffi/ffi.dart';

/// Constants matching the C++ crypto_bridge constants
class CryptoConstants {
  // Algorithm identifiers - Tier 1-2: Modern High Security
  static const int algorithmAES = 1;
  static const int algorithmSerpent = 2;
  static const int algorithmTwofish = 3;
  
  // Tier 3: Strong Security - AES Finalists & Modern Ciphers
  static const int algorithmRC6 = 4;
  static const int algorithmMARS = 5;
  static const int algorithmRC5 = 6;
  static const int algorithmSkipjack = 7;
  
  // Tier 4: Reliable Security - Established Algorithms
  static const int algorithmBlowfish = 8;
  static const int algorithmCAST128 = 9;
  static const int algorithmCAST256 = 10;
  static const int algorithmCamellia = 11;
  
  // Tier 5: Stream Ciphers - High Performance
  static const int algorithmChaCha20 = 12;
  static const int algorithmSalsa20 = 13;
  static const int algorithmXSalsa20 = 14;
  static const int algorithmHC128 = 15;
  static const int algorithmHC256 = 16;
  static const int algorithmRabbit = 17;
  static const int algorithmSosemanuk = 18;
  
  // Tier 6: Specialized & National Algorithms
  static const int algorithmARIA = 19;
  static const int algorithmSEED = 20;
  static const int algorithmSM4 = 21;
  static const int algorithmGOST28147 = 22;
  
  // Tier 7: Legacy Strong Algorithms
  static const int algorithmDES3 = 23;
  static const int algorithmIDEA = 24;
  static const int algorithmRC2 = 25;
  static const int algorithmSAFER = 26;
  static const int algorithmSAFERPlus = 27;
  
  // Tier 8: Historical & Compatibility
  static const int algorithmDES = 28;
  static const int algorithmRC4 = 29;
  
  // Tier 9: Experimental & Research
  static const int algorithmThreefish256 = 30;
  static const int algorithmThreefish512 = 31;
  static const int algorithmThreefish1024 = 32;
  
  // Tier 10: Additional Algorithms
  static const int algorithmTEA = 33;
  static const int algorithmXTEA = 34;
  static const int algorithmSHACAL2 = 35;
  static const int algorithmWAKE = 36;
  
  // Archive/Research Ciphers
  static const int algorithmSquare = 37;
  static const int algorithmShark = 38;
  static const int algorithmPanama = 39;
  static const int algorithmSEAL = 40;
  static const int algorithmLucifer = 41;
  
  // Modern lightweight ciphers (placeholders)
  static const int algorithmSimon = 42;
  static const int algorithmSpeck = 43;

  // Mode identifiers
  static const int modeCBC = 1;
  static const int modeGCM = 2;
  static const int modeECB = 3;
  static const int modeCFB = 4;
  static const int modeOFB = 5;
  static const int modeCTR = 6;

  // Operation types
  static const int operationEncrypt = 1;
  static const int operationDecrypt = 2;

  // Status codes
  static const int statusSuccess = 0;
  static const int statusInvalidParams = -1;
  static const int statusUnsupportedAlgorithm = -2;
  static const int statusUnsupportedMode = -3;
  static const int statusInvalidKeySize = -4;
  static const int statusMemoryError = -5;
  static const int statusCryptoError = -6;
  static const int statusPasswordTooShort = -7;
  static const int statusOutputBufferTooSmall = -8;
  static const int statusUnknownError = -9;
}

/// FFI typedefs for crypto_bridge_process
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

typedef CryptoBridgeVersionC = ffi.Pointer<ffi.Char> Function();
typedef CryptoBridgeVersion = ffi.Pointer<ffi.Char> Function();

/// Wrapper class for crypto bridge FFI operations
class CryptoFFI {
  static ffi.DynamicLibrary? _lib;
  static CryptoBridgeProcess? _process;
  static CryptoBridgeVersion? _version;

  /// Initialize the crypto bridge library
  static bool initialize() {
    try {
      // Load the C++ library
      if (Platform.isWindows) {
        _lib = ffi.DynamicLibrary.open('crypting.dll');
      } else if (Platform.isMacOS) {
        _lib = ffi.DynamicLibrary.open('libcrypting.dylib');
      } else {
        // Linux - try from build directory first
        try {
          _lib = ffi.DynamicLibrary.open('./build/lib/libcrypting.so');
        } catch (e) {
          _lib = ffi.DynamicLibrary.open('libcrypting.so');
        }
      }

      _process = _lib!.lookupFunction<CryptoBridgeProcessC, CryptoBridgeProcess>(
          'crypto_bridge_process');
      _version = _lib!.lookupFunction<CryptoBridgeVersionC, CryptoBridgeVersion>(
          'crypto_bridge_version');

      return true;
    } catch (e) {
      print('Failed to load crypto bridge library: $e');
      return false;
    }
  }

  /// Get crypto bridge version
  static String? getVersion() {
    if (_version == null) return null;
    try {
      final versionPtr = _version!();
      return versionPtr.cast<ffi.Utf8>().toDartString();
    } catch (e) {
      return null;
    }
  }

  /// Process encryption/decryption operation
  static Future<CryptoResult> processData({
    required int algorithm,
    required int mode,
    required int keySize,
    required int operation,
    required String password,
    required Uint8List inputData,
  }) async {
    if (_process == null) {
      return CryptoResult.error('Crypto bridge not initialized');
    }

    if (password.length < 8) {
      return CryptoResult.error('Password must be at least 8 characters');
    }

    final passwordPtr = password.toNativeUtf8();
    final inputPtr = malloc<ffi.Uint8>(inputData.length);
    final outputPtr = malloc<ffi.Uint8>(inputData.length + 64); // Extra space for padding/tag
    final outputLenPtr = malloc<ffi.Int32>();
    final ivPtr = malloc<ffi.Uint8>(16); // 16 bytes for IV
    final authTagPtr = malloc<ffi.Uint8>(16); // 16 bytes for auth tag

    try {
      // Copy input data
      for (int i = 0; i < inputData.length; i++) {
        inputPtr[i] = inputData[i];
      }
      outputLenPtr.value = inputData.length + 64;

      // Call crypto_bridge_process
      final result = _process!(
        algorithm,
        mode,
        keySize,
        operation,
        passwordPtr,
        password.length,
        inputPtr,
        inputData.length,
        outputPtr,
        outputLenPtr,
        ivPtr,
        authTagPtr,
      );

      if (result == CryptoConstants.statusSuccess) {
        // Extract output data
        final outputLen = outputLenPtr.value;
        final outputData = Uint8List(outputLen);
        for (int i = 0; i < outputLen; i++) {
          outputData[i] = outputPtr[i];
        }

        // Extract IV
        final iv = Uint8List(16);
        for (int i = 0; i < 16; i++) {
          iv[i] = ivPtr[i];
        }

        // Extract auth tag (for GCM mode)
        final authTag = Uint8List(16);
        for (int i = 0; i < 16; i++) {
          authTag[i] = authTagPtr[i];
        }

        return CryptoResult.success(outputData, iv, authTag);
      } else {
        return CryptoResult.error(_getErrorMessage(result));
      }
    } catch (e) {
      return CryptoResult.error('Native call failed: $e');
    } finally {
      malloc.free(passwordPtr);
      malloc.free(inputPtr);
      malloc.free(outputPtr);
      malloc.free(outputLenPtr);
      malloc.free(ivPtr);
      malloc.free(authTagPtr);
    }
  }

  /// Convert error code to human readable message
  static String _getErrorMessage(int errorCode) {
    switch (errorCode) {
      case CryptoConstants.statusInvalidParams:
        return 'Invalid parameters';
      case CryptoConstants.statusUnsupportedAlgorithm:
        return 'Unsupported algorithm';
      case CryptoConstants.statusUnsupportedMode:
        return 'Unsupported mode';
      case CryptoConstants.statusInvalidKeySize:
        return 'Invalid key size for algorithm';
      case CryptoConstants.statusMemoryError:
        return 'Memory allocation error';
      case CryptoConstants.statusCryptoError:
        return 'Cryptographic operation error';
      case CryptoConstants.statusPasswordTooShort:
        return 'Password too short (minimum 8 characters)';
      case CryptoConstants.statusOutputBufferTooSmall:
        return 'Output buffer too small';
      case CryptoConstants.statusUnknownError:
        return 'Unknown error';
      default:
        return 'Unknown error code: $errorCode';
    }
  }
}

/// Result of a crypto operation
class CryptoResult {
  final bool success;
  final String? error;
  final Uint8List? data;
  final Uint8List? iv;
  final Uint8List? authTag;

  CryptoResult.success(this.data, this.iv, this.authTag)
      : success = true,
        error = null;

  CryptoResult.error(this.error)
      : success = false,
        data = null,
        iv = null,
        authTag = null;
}