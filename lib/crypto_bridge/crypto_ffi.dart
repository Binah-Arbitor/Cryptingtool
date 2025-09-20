import 'dart:ffi' as ffi;
import 'dart:io' show Platform;
import 'dart:typed_data';
import 'package:ffi/ffi.dart';

import 'crypto_result.dart';

// --- FFI Signature Definitions ---

// C: int crypto_bridge_process(...)
typedef CryptoProcessNative = ffi.Int32 Function(
  ffi.Int32 algorithm,
  ffi.Int32 mode,
  ffi.Int32 keySizeBits,
  ffi.Int32 operation,
  ffi.Pointer<Utf8> password,
  ffi.Int32 passwordLen,
  ffi.Pointer<ffi.Uint8> inputData,
  ffi.Int32 inputLen,
  ffi.Pointer<ffi.Uint8> outputData,
  ffi.Pointer<ffi.Int32> outputLen,
  ffi.Pointer<ffi.Uint8> iv,
  ffi.Pointer<ffi.Uint8> authTag,
);

// Dart: int cryptoBridgeProcess(...)
typedef CryptoProcessDart = int Function(
  int algorithm,
  int mode,
  int keySizeBits,
  int operation,
  ffi.Pointer<Utf8> password,
  int passwordLen,
  ffi.Pointer<ffi.Uint8> inputData,
  int inputLen,
  ffi.Pointer<ffi.Uint8> outputData,
  ffi.Pointer<ffi.Int32> outputLen,
  ffi.Pointer<ffi.Uint8> iv,
  ffi.Pointer<ffi.Uint8> authTag,
);

// C: const char* crypto_bridge_version(void)
typedef CryptoVersionNative = ffi.Pointer<Utf8> Function();
// Dart: ffi.Pointer<Utf8> cryptoBridgeVersion()
typedef CryptoVersionDart = ffi.Pointer<Utf8> Function();


/// Manages FFI calls and memory for the crypto bridge
class CryptoFFI {
  static final ffi.DynamicLibrary _cryptoLib = _loadDynamicLibrary();
  static final CryptoProcessDart _cryptoProcess = _lookupCryptoProcess();
  static final CryptoVersionDart _cryptoVersion = _lookupCryptoVersion();
  static bool _initialized = false;

  /// Loads the dynamic library based on the platform
  static ffi.DynamicLibrary _loadDynamicLibrary() {
    if (Platform.isAndroid || Platform.isLinux) {
      return ffi.DynamicLibrary.open('libcrypto.so');
    } else if (Platform.isIOS || Platform.isMacOS) {
      return ffi.DynamicLibrary.open('libcrypto.dylib');
    } else if (Platform.isWindows) {
      return ffi.DynamicLibrary.open('crypto.dll');
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
  
  /// Looks up the crypto_bridge_process function
  static CryptoProcessDart _lookupCryptoProcess() {
    return _cryptoLib
      .lookup<ffi.NativeFunction<CryptoProcessNative>>('crypto_bridge_process')
      .asFunction<CryptoProcessDart>();
  }
  
  /// Looks up the crypto_bridge_version function
  static CryptoVersionDart _lookupCryptoVersion() {
    return _cryptoLib
      .lookup<ffi.NativeFunction<CryptoVersionNative>>('crypto_bridge_version')
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
    final ffi.Pointer<Utf8> versionPtr = _cryptoVersion();
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
    final ffi.Pointer<Utf8> passwordPtr = password.toNativeUtf8();
    final ffi.Pointer<ffi.Uint8> inputPtr = calloc<ffi.Uint8>(inputData.length);
    inputPtr.asTypedList(inputData.length).setAll(0, inputData);

    // Allocate memory for outputs
    // Output can be slightly larger than input (padding, etc.)
    final int outputBufferSize = inputData.length + 256; 
    final ffi.Pointer<ffi.Uint8> outputPtr = calloc<ffi.Uint8>(outputBufferSize);
    final ffi.Pointer<ffi.Int32> outputLenPtr = calloc<ffi.Int32>();
    outputLenPtr.value = outputBufferSize;

    // IV and Auth Tag are handled by the C++ layer for simplicity
    final ffi.Pointer<ffi.Uint8> ivPtr = ffi.nullptr;
    final ffi.Pointer<ffi.Uint8> authTagPtr = ffi.nullptr;
    
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
