import 'dart:typed_data';
import '../models/encryption_config.dart';
import 'crypto_ffi.dart';

/// Service for performing cryptographic operations using the C++ backend
class CryptoBridgeService {
  static bool _initialized = false;

  /// Initialize the crypto bridge service
  static Future<bool> initialize() async {
    if (_initialized) return true;
    
    _initialized = CryptoFFI.initialize();
    if (_initialized) {
      final version = CryptoFFI.getVersion();
      print('Crypto Bridge initialized - Version: $version');
    } else {
      print('Failed to initialize Crypto Bridge');
    }
    
    return _initialized;
  }

  /// Check if the service is initialized
  static bool get isInitialized => _initialized;

  /// Get the crypto bridge version
  static String? getVersion() => CryptoFFI.getVersion();

  /// Encrypt data using the specified configuration
  static Future<CryptoResult> encrypt({
    required EncryptionConfig config,
    required Uint8List data,
  }) async {
    if (!_initialized) {
      return CryptoResult.error('Crypto bridge not initialized');
    }

    return await CryptoFFI.processData(
      algorithm: _mapAlgorithm(config.algorithm),
      mode: _mapMode(config.mode),
      keySize: config.keySize,
      operation: CryptoConstants.operationEncrypt,
      password: config.password,
      inputData: data,
    );
  }

  /// Decrypt data using the specified configuration
  static Future<CryptoResult> decrypt({
    required EncryptionConfig config,
    required Uint8List data,
  }) async {
    if (!_initialized) {
      return CryptoResult.error('Crypto bridge not initialized');
    }

    return await CryptoFFI.processData(
      algorithm: _mapAlgorithm(config.algorithm),
      mode: _mapMode(config.mode),
      keySize: config.keySize,
      operation: CryptoConstants.operationDecrypt,
      password: config.password,
      inputData: data,
    );
  }

  /// Map Flutter algorithm enum to C++ constant
  static int _mapAlgorithm(CryptoAlgorithm algorithm) {
    switch (algorithm) {
      case CryptoAlgorithm.aes:
        return CryptoConstants.algorithmAES;
      case CryptoAlgorithm.serpent:
        return CryptoConstants.algorithmSerpent;
      case CryptoAlgorithm.twofish:
        return CryptoConstants.algorithmTwofish;
      case CryptoAlgorithm.rc6:
        return CryptoConstants.algorithmRC6;
      case CryptoAlgorithm.blowfish:
        return CryptoConstants.algorithmBlowfish;
      case CryptoAlgorithm.cast128:
        return CryptoConstants.algorithmCAST128;
    }
  }

  /// Map Flutter mode enum to C++ constant
  static int _mapMode(CryptoMode mode) {
    switch (mode) {
      case CryptoMode.cbc:
        return CryptoConstants.modeCBC;
      case CryptoMode.gcm:
        return CryptoConstants.modeGCM;
      case CryptoMode.ecb:
        return CryptoConstants.modeECB;
      case CryptoMode.cfb:
        return CryptoConstants.modeCFB;
      case CryptoMode.ofb:
        return CryptoConstants.modeOFB;
      case CryptoMode.ctr:
        return CryptoConstants.modeCTR;
    }
  }

  /// Test the crypto bridge with a simple round-trip
  static Future<bool> testRoundTrip() async {
    if (!_initialized) return false;

    const testPassword = 'TestPassword123';
    const testMessage = 'Hello, CryptingTool!';
    final testData = Uint8List.fromList(testMessage.codeUnits);

    try {
      // Test AES-256-CBC encryption/decryption
      final encryptResult = await CryptoFFI.processData(
        algorithm: CryptoConstants.algorithmAES,
        mode: CryptoConstants.modeCBC,
        keySize: 256,
        operation: CryptoConstants.operationEncrypt,
        password: testPassword,
        inputData: testData,
      );

      if (!encryptResult.success) {
        print('Test encryption failed: ${encryptResult.error}');
        return false;
      }

      final decryptResult = await CryptoFFI.processData(
        algorithm: CryptoConstants.algorithmAES,
        mode: CryptoConstants.modeCBC,
        keySize: 256,
        operation: CryptoConstants.operationDecrypt,
        password: testPassword,
        inputData: encryptResult.data!,
      );

      if (!decryptResult.success) {
        print('Test decryption failed: ${decryptResult.error}');
        return false;
      }

      final decryptedMessage = String.fromCharCodes(decryptResult.data!);
      if (decryptedMessage == testMessage) {
        print('Crypto bridge test passed: Round-trip successful');
        return true;
      } else {
        print('Test failed: Message mismatch');
        print('Expected: $testMessage');
        print('Got: $decryptedMessage');
        return false;
      }
    } catch (e) {
      print('Test failed with exception: $e');
      return false;
    }
  }

  /// Get supported key sizes for an algorithm
  static List<int> getSupportedKeySizes(CryptoAlgorithm algorithm) {
    switch (algorithm) {
      case CryptoAlgorithm.aes:
      case CryptoAlgorithm.serpent:
      case CryptoAlgorithm.twofish:
      case CryptoAlgorithm.rc6:
        return [128, 192, 256];
      case CryptoAlgorithm.blowfish:
        return [32, 64, 128, 256, 448];
      case CryptoAlgorithm.cast128:
        return [128];
    }
  }

  /// Check if mode is supported for algorithm
  static bool isModeSupported(CryptoAlgorithm algorithm, CryptoMode mode) {
    // All algorithms support these modes
    const commonModes = [
      CryptoMode.cbc,
      CryptoMode.ecb,
      CryptoMode.cfb,
      CryptoMode.ofb,
      CryptoMode.ctr,
    ];
    
    if (commonModes.contains(mode)) {
      return true;
    }

    // GCM mode only supported by AES
    if (mode == CryptoMode.gcm) {
      return algorithm == CryptoAlgorithm.aes;
    }

    return false;
  }
}