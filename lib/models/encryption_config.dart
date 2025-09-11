enum EncryptionAlgorithm {
  // Block Ciphers - Sorted by encryption strength (strongest first)
  
  // Tier 1: Maximum Security (256+ bit keys, modern design)
  threefish1024('Threefish-1024', 'Threefish Block Cipher (1024-bit)'),
  threefish512('Threefish-512', 'Threefish Block Cipher (512-bit)'),
  shacal2('SHACAL-2', 'SHACAL-2 Block Cipher (SHA-based)'),
  
  // Tier 2: High Security (256-bit capable, proven algorithms)
  aes('AES', 'Advanced Encryption Standard (Rijndael)'),
  serpent('Serpent', 'Serpent Block Cipher'),
  twofish('Twofish', 'Twofish Block Cipher'),
  camellia('Camellia', 'Camellia Block Cipher'),
  aria('ARIA', 'ARIA Block Cipher (Korean Standard)'),
  threefish256('Threefish-256', 'Threefish Block Cipher (256-bit)'),
  
  // Stream Ciphers - High Security
  chacha20('ChaCha20', 'ChaCha20 Stream Cipher'),
  salsa20('Salsa20', 'Salsa20 Stream Cipher'),
  xsalsa20('XSalsa20', 'XSalsa20 Stream Cipher'),
  hc256('HC-256', 'HC-256 Stream Cipher'),
  
  // Tier 3: Good Security (192/256-bit capable)
  cast256('CAST-256', 'CAST-256 Block Cipher'),
  mars('MARS', 'MARS Block Cipher'),
  rc6('RC6', 'RC6 Block Cipher'),
  
  // Stream Ciphers - Good Security  
  chacha12('ChaCha12', 'ChaCha12 Stream Cipher'),
  chacha8('ChaCha8', 'ChaCha8 Stream Cipher'),
  hc128('HC-128', 'HC-128 Stream Cipher'),
  rabbit('Rabbit', 'Rabbit Stream Cipher'),
  sosemanuk('SOSEMANUK', 'SOSEMANUK Stream Cipher'),
  
  // Tier 4: Standard Security (128-bit minimum)
  seed('SEED', 'SEED Block Cipher (Korean Standard)'),
  idea('IDEA', 'International Data Encryption Algorithm'),
  cast128('CAST-128', 'CAST-128 Block Cipher'),
  tea('TEA', 'Tiny Encryption Algorithm'),
  xtea('XTEA', 'Extended TEA'),
  rc5('RC5', 'RC5 Block Cipher'),
  
  // Stream Ciphers - Standard Security
  seal('SEAL', 'SEAL Stream Cipher'),
  wake('WAKE-OFB', 'WAKE Output Feedback Mode'),
  
  // Tier 5: Variable Key/Legacy Strong
  blowfish('Blowfish', 'Blowfish Block Cipher (Variable Key)'),
  rc2('RC2', 'RC2 Block Cipher (Variable Key)'),
  
  // Tier 6: Legacy/Weak (for compatibility only)
  tripleDes('3DES', 'Triple Data Encryption Standard'),
  skipjack('SKIPJACK', 'SKIPJACK Block Cipher'),
  des('DES', 'Data Encryption Standard (Legacy)'),
  rc4('RC4', 'RC4 Stream Cipher (Legacy)');

  const EncryptionAlgorithm(this.displayName, this.description);

  final String displayName;
  final String description;

  List<int> getSupportedKeySizes() {
    switch (this) {
      // Threefish variants
      case EncryptionAlgorithm.threefish1024:
        return [1024];
      case EncryptionAlgorithm.threefish512:
        return [512];
      case EncryptionAlgorithm.threefish256:
        return [256];
      
      // SHACAL-2
      case EncryptionAlgorithm.shacal2:
        return [128, 192, 256, 384, 512];
      
      // Standard 128/192/256-bit algorithms
      case EncryptionAlgorithm.aes:
      case EncryptionAlgorithm.serpent:
      case EncryptionAlgorithm.twofish:
      case EncryptionAlgorithm.camellia:
      case EncryptionAlgorithm.aria:
      case EncryptionAlgorithm.cast256:
      case EncryptionAlgorithm.mars:
      case EncryptionAlgorithm.rc6:
        return [128, 192, 256];
      
      // Stream ciphers - 256-bit
      case EncryptionAlgorithm.chacha20:
      case EncryptionAlgorithm.chacha12:
      case EncryptionAlgorithm.chacha8:
      case EncryptionAlgorithm.salsa20:
      case EncryptionAlgorithm.xsalsa20:
      case EncryptionAlgorithm.hc256:
        return [256];
      
      // Stream ciphers - 128-bit
      case EncryptionAlgorithm.hc128:
      case EncryptionAlgorithm.rabbit:
      case EncryptionAlgorithm.sosemanuk:
        return [128];
      
      // 128-bit only algorithms
      case EncryptionAlgorithm.seed:
      case EncryptionAlgorithm.idea:
      case EncryptionAlgorithm.cast128:
      case EncryptionAlgorithm.tea:
      case EncryptionAlgorithm.xtea:
        return [128];
      
      // SEAL stream cipher
      case EncryptionAlgorithm.seal:
        return [160];
      
      // WAKE stream cipher
      case EncryptionAlgorithm.wake:
        return [128, 256];
      
      // Variable key algorithms
      case EncryptionAlgorithm.blowfish:
        return [32, 64, 128, 256, 448];
      case EncryptionAlgorithm.rc5:
        return [64, 128, 192, 256];
      case EncryptionAlgorithm.rc2:
        return [40, 64, 128];
      case EncryptionAlgorithm.rc4:
        return [40, 56, 64, 128, 256];
      
      // Legacy algorithms
      case EncryptionAlgorithm.tripleDes:
        return [168]; // 3 × 56-bit keys
      case EncryptionAlgorithm.skipjack:
        return [80];
      case EncryptionAlgorithm.des:
        return [56];
    }
  }

  List<OperationMode> getSupportedModes() {
    switch (this) {
      // Stream ciphers - only support stream mode (using CTR as representation)
      case EncryptionAlgorithm.chacha20:
      case EncryptionAlgorithm.chacha12:
      case EncryptionAlgorithm.chacha8:
      case EncryptionAlgorithm.salsa20:
      case EncryptionAlgorithm.xsalsa20:
      case EncryptionAlgorithm.hc128:
      case EncryptionAlgorithm.hc256:
      case EncryptionAlgorithm.rabbit:
      case EncryptionAlgorithm.sosemanuk:
      case EncryptionAlgorithm.seal:
      case EncryptionAlgorithm.wake:
      case EncryptionAlgorithm.rc4:
        return [OperationMode.ctr]; // Stream ciphers work like CTR mode
      
      // Block ciphers with full mode support
      case EncryptionAlgorithm.aes:
      case EncryptionAlgorithm.serpent:
      case EncryptionAlgorithm.twofish:
      case EncryptionAlgorithm.camellia:
      case EncryptionAlgorithm.aria:
        return [
          OperationMode.gcm,  // Authenticated encryption (preferred)
          OperationMode.cbc,  // Traditional
          OperationMode.ctr,  // Stream-like
          OperationMode.cfb,  // Cipher feedback
          OperationMode.ofb,  // Output feedback
        ];
      
      // Block ciphers with standard modes (no GCM)
      case EncryptionAlgorithm.threefish1024:
      case EncryptionAlgorithm.threefish512:
      case EncryptionAlgorithm.threefish256:
      case EncryptionAlgorithm.shacal2:
      case EncryptionAlgorithm.cast256:
      case EncryptionAlgorithm.mars:
      case EncryptionAlgorithm.rc6:
      case EncryptionAlgorithm.seed:
      case EncryptionAlgorithm.idea:
      case EncryptionAlgorithm.cast128:
      case EncryptionAlgorithm.tea:
      case EncryptionAlgorithm.xtea:
      case EncryptionAlgorithm.blowfish:
      case EncryptionAlgorithm.rc5:
      case EncryptionAlgorithm.rc2:
        return [
          OperationMode.cbc,  // Traditional
          OperationMode.ctr,  // Stream-like
          OperationMode.cfb,  // Cipher feedback
          OperationMode.ofb,  // Output feedback
          OperationMode.ecb,  // Simple (less secure)
        ];
      
      // Legacy algorithms with basic modes
      case EncryptionAlgorithm.tripleDes:
      case EncryptionAlgorithm.des:
      case EncryptionAlgorithm.skipjack:
        return [
          OperationMode.cbc,
          OperationMode.ecb,
        ];
    }
  }
}

enum OperationMode {
  cbc('CBC', 'Cipher Block Chaining'),
  gcm('GCM', 'Galois/Counter Mode'),
  ecb('ECB', 'Electronic Codebook'),
  cfb('CFB', 'Cipher Feedback'),
  ofb('OFB', 'Output Feedback'),
  ctr('CTR', 'Counter Mode');

  const OperationMode(this.displayName, this.description);

  final String displayName;
  final String description;
}

class EncryptionConfig {
  final EncryptionAlgorithm algorithm;
  final int keySize;
  final OperationMode mode;
  final String password;
  final int threadCount;

  const EncryptionConfig({
    required this.algorithm,
    required this.keySize,
    required this.mode,
    required this.password,
    required this.threadCount,
  });

  EncryptionConfig copyWith({
    EncryptionAlgorithm? algorithm,
    int? keySize,
    OperationMode? mode,
    String? password,
    int? threadCount,
  }) {
    return EncryptionConfig(
      algorithm: algorithm ?? this.algorithm,
      keySize: keySize ?? this.keySize,
      mode: mode ?? this.mode,
      password: password ?? this.password,
      threadCount: threadCount ?? this.threadCount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'algorithm': algorithm.name,
      'keySize': keySize,
      'mode': mode.name,
      'password': password,
      'threadCount': threadCount,
    };
  }

  factory EncryptionConfig.fromJson(Map<String, dynamic> json) {
    return EncryptionConfig(
      algorithm: EncryptionAlgorithm.values.firstWhere(
        (e) => e.name == json['algorithm'],
      ),
      keySize: json['keySize'],
      mode: OperationMode.values.firstWhere(
        (e) => e.name == json['mode'],
      ),
      password: json['password'],
      threadCount: json['threadCount'],
    );
  }

  @override
  String toString() {
    return 'EncryptionConfig(algorithm: ${algorithm.displayName}, keySize: $keySize, mode: ${mode.displayName}, threadCount: $threadCount)';
  }
}

// Default configuration
class EncryptionDefaults {
  static const EncryptionAlgorithm defaultAlgorithm = EncryptionAlgorithm.aes;
  static const int defaultKeySize = 256;
  static const OperationMode defaultMode = OperationMode.gcm;
  static const int defaultThreadCount = 4;
  static const String defaultPassword = '';

  static EncryptionConfig get defaultConfig => const EncryptionConfig(
    algorithm: defaultAlgorithm,
    keySize: defaultKeySize,
    mode: defaultMode,
    password: defaultPassword,
    threadCount: defaultThreadCount,
  );
}