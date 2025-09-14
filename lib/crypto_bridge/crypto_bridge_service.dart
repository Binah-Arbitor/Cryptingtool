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
  static int _mapAlgorithm(EncryptionAlgorithm algorithm) {
    switch (algorithm) {
      // Tier 1: Maximum Security - Modern & Post-Quantum Ready
      case EncryptionAlgorithm.aes256:
        return CryptoConstants.algorithmAES;
      case EncryptionAlgorithm.serpent256:
        return CryptoConstants.algorithmSerpent;
      case EncryptionAlgorithm.twofish256:
        return CryptoConstants.algorithmTwofish;
        
      // Tier 2: High Security - Modern Algorithms
      case EncryptionAlgorithm.aes192:
      case EncryptionAlgorithm.aes128:
        return CryptoConstants.algorithmAES;
      case EncryptionAlgorithm.serpent192:
      case EncryptionAlgorithm.serpent128:
        return CryptoConstants.algorithmSerpent;
      case EncryptionAlgorithm.twofish192:
      case EncryptionAlgorithm.twofish128:
        return CryptoConstants.algorithmTwofish;
        
      // Tier 3: Strong Security - AES Finalists & Modern Ciphers
      case EncryptionAlgorithm.rc6:
        return CryptoConstants.algorithmRC6;
      case EncryptionAlgorithm.mars:
        return CryptoConstants.algorithmMARS;
      case EncryptionAlgorithm.rc5:
        return CryptoConstants.algorithmRC5;
      case EncryptionAlgorithm.skipjack:
        return CryptoConstants.algorithmSkipjack;
        
      // Tier 4: Reliable Security - Established Algorithms  
      case EncryptionAlgorithm.blowfish:
        return CryptoConstants.algorithmBlowfish;
      case EncryptionAlgorithm.cast128:
        return CryptoConstants.algorithmCAST128;
      case EncryptionAlgorithm.cast256:
        return CryptoConstants.algorithmCAST256;
      case EncryptionAlgorithm.camellia:
        return CryptoConstants.algorithmCamellia;
        
      // Tier 5: Stream Ciphers - High Performance
      case EncryptionAlgorithm.chacha20:
        return CryptoConstants.algorithmChaCha20;
      case EncryptionAlgorithm.salsa20:
        return CryptoConstants.algorithmSalsa20;
      case EncryptionAlgorithm.xsalsa20:
        return CryptoConstants.algorithmXSalsa20;
      case EncryptionAlgorithm.hc128:
        return CryptoConstants.algorithmHC128;
      case EncryptionAlgorithm.hc256:
        return CryptoConstants.algorithmHC256;
      case EncryptionAlgorithm.rabbit:
        return CryptoConstants.algorithmRabbit;
      case EncryptionAlgorithm.sosemanuk:
        return CryptoConstants.algorithmSosemanuk;
        
      // Tier 6: Specialized & National Algorithms
      case EncryptionAlgorithm.aria:
        return CryptoConstants.algorithmARIA;
      case EncryptionAlgorithm.seed:
        return CryptoConstants.algorithmSEED;
      case EncryptionAlgorithm.sm4:
        return CryptoConstants.algorithmSM4;
      case EncryptionAlgorithm.gost28147:
        return CryptoConstants.algorithmGOST28147;
        
      // Tier 7: Legacy Strong Algorithms
      case EncryptionAlgorithm.des3:
        return CryptoConstants.algorithmDES3;
      case EncryptionAlgorithm.idea:
        return CryptoConstants.algorithmIDEA;
      case EncryptionAlgorithm.rc2:
        return CryptoConstants.algorithmRC2;
      case EncryptionAlgorithm.safer:
        return CryptoConstants.algorithmSAFER;
      case EncryptionAlgorithm.saferPlus:
        return CryptoConstants.algorithmSAFERPlus;
        
      // Tier 8: Historical & Compatibility
      case EncryptionAlgorithm.des:
        return CryptoConstants.algorithmDES;
      case EncryptionAlgorithm.rc4:
        return CryptoConstants.algorithmRC4;
        
      // Tier 9: Experimental & Research
      case EncryptionAlgorithm.threefish256:
        return CryptoConstants.algorithmThreefish256;
      case EncryptionAlgorithm.threefish512:
        return CryptoConstants.algorithmThreefish512;
      case EncryptionAlgorithm.threefish1024:
        return CryptoConstants.algorithmThreefish1024;
        
      // Tier 10: Additional Crypto++ Supported Algorithms
      case EncryptionAlgorithm.tea:
        return CryptoConstants.algorithmTEA;
      case EncryptionAlgorithm.xtea:
        return CryptoConstants.algorithmXTEA;
      case EncryptionAlgorithm.shacal2:
        return CryptoConstants.algorithmSHACAL2;
      case EncryptionAlgorithm.wake:
        return CryptoConstants.algorithmWAKE;
        
      // Archive/Research Ciphers
      case EncryptionAlgorithm.square:
        return CryptoConstants.algorithmSquare;
      case EncryptionAlgorithm.shark:
        return CryptoConstants.algorithmShark;
      case EncryptionAlgorithm.panama:
        return CryptoConstants.algorithmPanama;
      case EncryptionAlgorithm.seal:
        return CryptoConstants.algorithmSEAL;
      case EncryptionAlgorithm.lucifer:
        return CryptoConstants.algorithmLucifer;
        
      // Modern lightweight ciphers
      case EncryptionAlgorithm.simon:
        return CryptoConstants.algorithmSimon;
      case EncryptionAlgorithm.speck:
        return CryptoConstants.algorithmSpeck;
        
      // If we missed any, throw an error
      default:
        throw ArgumentError('Unsupported algorithm: $algorithm');
    }
  }

  /// Map Flutter mode enum to C++ constant
  static int _mapMode(OperationMode mode) {
    switch (mode) {
      case OperationMode.cbc:
        return CryptoConstants.modeCBC;
      case OperationMode.gcm:
        return CryptoConstants.modeGCM;
      case OperationMode.ecb:
        return CryptoConstants.modeECB;
      case OperationMode.cfb:
        return CryptoConstants.modeCFB;
      case OperationMode.ofb:
        return CryptoConstants.modeOFB;
      case OperationMode.ctr:
        return CryptoConstants.modeCTR;
      default:
        throw ArgumentError('Unsupported mode: $mode');
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
  static List<int> getSupportedKeySizes(EncryptionAlgorithm algorithm) {
    return algorithm.getSupportedKeySizes();
  }

  /// Check if mode is supported for algorithm
  static bool isModeSupported(EncryptionAlgorithm algorithm, OperationMode mode) {
    return algorithm.getSupportedModes().contains(mode);
  }
}