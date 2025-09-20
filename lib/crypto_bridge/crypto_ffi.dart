import 'dart:ffi';
import 'dart:io' show Platform;
import 'dart:typed_data';
import 'package:ffi/ffi.dart';

import 'crypto_result.dart';

// --- FFI Signature Definitions ---

// C: int crypto_bridge_process(...)
typedef CryptoProcessNative = Int32 Function(
  Int32 algorithm,
  Int32 mode,
  Int32 key_size_bits,
  Int32 operation,
  Pointer<Utf8> password,
  Int32 password_len,
  Pointer<Uint8> input_data,
  Int32 input_len,
  Pointer<Uint8> output_data,
  Pointer<Int32> output_len,
  Pointer<Uint8> iv,
  Pointer<Uint8> auth_tag,
);

// Dart: int cryptoBridgeProcess(...)
typedef CryptoProcessDart = int Function(
  int algorithm,
  int mode,
  int keySizeBits,
  int operation,
  Pointer<Utf8> password,
  int passwordLen,
  Pointer<Uint8> inputData,
  int inputLen,
  Pointer<Uint8> outputData,
  Pointer<Int32> outputLen,
  Pointer<Uint8> iv,
  Pointer<Uint8> authTag,
);

// C: const char* crypto_bridge_version(void)
typedef CryptoVersionNative = Pointer<Utf8> Function();
// Dart: Pointer<Utf8> cryptoBridgeVersion()
typedef CryptoVersionDart = Pointer<Utf8> Function();


/// Manages FFI calls and memory for the crypto bridge
class CryptoFFI {
  static final DynamicLibrary _cryptoLib = _loadDynamicLibrary();
  static final CryptoProcessDart _cryptoProcess = _lookupCryptoProcess();
  static final CryptoVersionDart _cryptoVersion = _lookupCryptoVersion();
  static bool _initialized = false;

  /// Loads the dynamic library based on the platform
  static DynamicLibrary _loadDynamicLibrary() {
    if (Platform.isAndroid || Platform.isLinux) {
      return DynamicLibrary.open('libcrypto.so');
    } else if (Platform.isIOS || Platform.isMacOS) {
      return DynamicLibrary.open('libcrypto.dylib');
    } else if (Platform.isWindows) {
      return DynamicLibrary.open('crypto.dll');
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
  
  /// Looks up the crypto_bridge_process function
  static CryptoProcessDart _lookupCryptoProcess() {
    return _cryptoLib
      .lookup<NativeFunction<CryptoProcessNative>>('crypto_bridge_process')
      .asFunction<CryptoProcessDart>();
  }
  
  /// Looks up the crypto_bridge_version function
  static CryptoVersionDart _lookupCryptoVersion() {
    return _cryptoLib
      .lookup<NativeFunction<CryptoVersionNative>>('crypto_bridge_version')
      .asFunction<CryptoVersionDart>();
  }

  /// Initializes the FFI bindings
  static bool initialize() {
    // Here, we can just check if the functions were loaded
    _initialized = true;
    return _initialized;
  }
  
  /// Gets the version of the native crypto library
  static String getVersion() {
    final Pointer<Utf8> versionPtr = _cryptoVersion();
    return versionPtr.toDartString();
  }

  /// High-level wrapper for the native crypto_bridge_process function.
  /// Handles all memory allocation, conversion, and deallocation.
  static Future<CryptoResult> processData({
    required int algorithm,
    required int mode,
    required int keySize,
    required int operation,
    required String password,
    required Uint8List inputData,
  }) async {
    if (!_initialized) {
      return CryptoResult.error('FFI not initialized');
    }

    // Allocate memory for inputs
    final Pointer<Utf8> passwordPtr = password.toNativeUtf8();
    final Pointer<Uint8> inputPtr = calloc<Uint8>(inputData.length);
    inputPtr.asTypedList(inputData.length).setAll(0, inputData);

    // Allocate memory for outputs
    // Output can be slightly larger than input (padding, etc.)
    final int outputBufferSize = inputData.length + 256; 
    final Pointer<Uint8> outputPtr = calloc<Uint8>(outputBufferSize);
    final Pointer<Int32> outputLenPtr = calloc<Int32>();
    outputLenPtr.value = outputBufferSize;

    // IV and Auth Tag are handled by the C++ layer for simplicity
    final Pointer<Uint8> ivPtr = nullptr;
    final Pointer<Uint8> authTagPtr = nullptr;
    
    try {
      final int status = _cryptoProcess(
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

      if (status == 0) { // Success
        final int actualOutputLen = outputLenPtr.value;
        final Uint8List resultData = outputPtr.asTypedList(actualOutputLen);
        return CryptoResult.success(Uint8List.fromList(resultData));
      } else {
        return CryptoResult.error('Native call failed with status code: $status');
      }
    } finally {
      // CRITICAL: Free all allocated memory to prevent leaks
      calloc.free(passwordPtr);
      calloc.free(inputPtr);
      calloc.free(outputPtr);
      calloc.free(outputLenPtr);
    }
  }
}
