// Algorithms sorted by encryption strength (strongest first)
enum EncryptionAlgorithm {
  // Tier 1: Maximum Security - Modern & Post-Quantum Ready
  aes256('AES-256', 'Advanced Encryption Standard - 256-bit (Maximum Security)'),
  serpent256('Serpent-256', 'Serpent Block Cipher - 256-bit (Maximum Security)'),
  twofish256('Twofish-256', 'Twofish Block Cipher - 256-bit (Maximum Security)'),
  
  // Tier 2: High Security - Modern Algorithms
  aes192('AES-192', 'Advanced Encryption Standard - 192-bit (High Security)'),
  aes128('AES-128', 'Advanced Encryption Standard - 128-bit (High Security)'),
  serpent192('Serpent-192', 'Serpent Block Cipher - 192-bit (High Security)'),
  serpent128('Serpent-128', 'Serpent Block Cipher - 128-bit (High Security)'),
  twofish192('Twofish-192', 'Twofish Block Cipher - 192-bit (High Security)'),
  twofish128('Twofish-128', 'Twofish Block Cipher - 128-bit (High Security)'),
  
  // Tier 3: Strong Security - AES Finalists & Modern Ciphers
  rc6('RC6', 'Rivest Cipher 6 - Variable Key Length'),
  mars('MARS', 'IBM MARS Block Cipher'),
  rc5('RC5', 'Rivest Cipher 5 - Variable Parameters'),
  skipjack('Skipjack', 'NSA Skipjack Block Cipher'),
  
  // Tier 4: Reliable Security - Established Algorithms  
  blowfish('Blowfish', 'Blowfish Block Cipher - Variable Key (32-448 bits)'),
  cast128('CAST-128', 'CAST-128 Block Cipher (128-bit key)'),
  cast256('CAST-256', 'CAST-256 Block Cipher (128/160/192/224/256-bit key)'),
  camellia('Camellia', 'NTT/Mitsubishi Camellia Block Cipher'),
  
  // Tier 5: Stream Ciphers - High Performance
  chacha20('ChaCha20', 'ChaCha20 Stream Cipher (256-bit key)'),
  salsa20('Salsa20', 'Salsa20 Stream Cipher (128/256-bit key)'),
  xsalsa20('XSalsa20', 'Extended Salsa20 Stream Cipher (256-bit key)'),
  hc128('HC-128', 'HC-128 Stream Cipher (128-bit key)'),
  hc256('HC-256', 'HC-256 Stream Cipher (256-bit key)'),
  rabbit('Rabbit', 'Rabbit Stream Cipher (128-bit key)'),
  sosemanuk('Sosemanuk', 'Sosemanuk Stream Cipher (128-256 bit key)'),
  
  // Tier 6: Specialized & National Algorithms
  aria('ARIA', 'Korean ARIA Block Cipher (128/192/256-bit)'),
  seed('SEED', 'Korean SEED Block Cipher (128-bit key)'),
  sm4('SM4', 'Chinese SM4 Block Cipher (128-bit key)'),
  gost28147('GOST 28147-89', 'Russian GOST Block Cipher (256-bit key)'),
  
  // Tier 7: Legacy Strong Algorithms
  des3('3DES', 'Triple Data Encryption Standard (168-bit effective)'),
  idea('IDEA', 'International Data Encryption Algorithm (128-bit)'),
  rc2('RC2', 'Rivest Cipher 2 - Variable Key Length'),
  safer('SAFER', 'Secure And Fast Encryption Routine'),
  saferPlus('SAFER+', 'Enhanced SAFER Block Cipher'),
  
  // Tier 8: Historical & Compatibility
  des('DES', 'Data Encryption Standard (56-bit key) - Legacy Only'),
  rc4('RC4', 'Rivest Cipher 4 Stream Cipher - Legacy'),
  
  // Tier 9: Experimental & Research
  threefish256('Threefish-256', 'Skein Hash Function Block Cipher (256-bit)'),
  threefish512('Threefish-512', 'Skein Hash Function Block Cipher (512-bit)'),
  threefish1024('Threefish-1024', 'Skein Hash Function Block Cipher (1024-bit)'),
  
  // Tier 10: Additional Crypto++ Supported Algorithms
  tea('TEA', 'Tiny Encryption Algorithm (128-bit key)'),
  xtea('XTEA', 'Extended Tiny Encryption Algorithm (128-bit key)'),
  shacal2('SHACAL-2', 'SHA-256 based Block Cipher (128-512 bit key)'),
  wake('WAKE', 'Word Auto Key Encryption'),
  
  // Archive/Research Ciphers
  square('Square', 'Square Block Cipher - AES Predecessor'),
  shark('SHARK', 'SHARK Block Cipher'),
  
  // Additional stream ciphers
  panama('Panama', 'Panama Stream Cipher'),
  seal('SEAL', 'Software-optimized Encryption Algorithm'),
  
  // Block cipher modes as separate options for compatibility
  lucifer('Lucifer', 'IBM Lucifer - DES Predecessor'),
  
  // Modern lightweight ciphers
  simon('Simon', 'NSA Simon Lightweight Block Cipher'),
  speck('Speck', 'NSA Speck Lightweight Block Cipher');

  const EncryptionAlgorithm(this.displayName, this.description);

  final String displayName;
  final String description;

  List<int> getSupportedKeySizes() {
    switch (this) {
      // AES Family
      case EncryptionAlgorithm.aes256:
        return [256];
      case EncryptionAlgorithm.aes192:
        return [192];
      case EncryptionAlgorithm.aes128:
        return [128];
        
      // Serpent Family
      case EncryptionAlgorithm.serpent256:
        return [256];
      case EncryptionAlgorithm.serpent192:
        return [192];
      case EncryptionAlgorithm.serpent128:
        return [128];
        
      // Twofish Family  
      case EncryptionAlgorithm.twofish256:
        return [256];
      case EncryptionAlgorithm.twofish192:
        return [192];
      case EncryptionAlgorithm.twofish128:
        return [128];
        
      // Variable key size algorithms
      case EncryptionAlgorithm.rc6:
        return [128, 192, 256];
      case EncryptionAlgorithm.mars:
        return [128, 192, 256];
      case EncryptionAlgorithm.rc5:
        return [64, 128, 192, 256];
      case EncryptionAlgorithm.blowfish:
        return [128, 192, 256, 320, 384, 448]; // Most common sizes
        
      // Fixed key size algorithms
      case EncryptionAlgorithm.skipjack:
        return [80];
      case EncryptionAlgorithm.cast128:
        return [128];
      case EncryptionAlgorithm.cast256:
        return [128, 160, 192, 224, 256];
      case EncryptionAlgorithm.camellia:
        return [128, 192, 256];
        
      // Stream ciphers
      case EncryptionAlgorithm.chacha20:
        return [256];
      case EncryptionAlgorithm.salsa20:
        return [128, 256];
      case EncryptionAlgorithm.xsalsa20:
        return [256];
      case EncryptionAlgorithm.hc128:
        return [128];
      case EncryptionAlgorithm.hc256:
        return [256];
      case EncryptionAlgorithm.rabbit:
        return [128];
      case EncryptionAlgorithm.sosemanuk:
        return [128, 256];
        
      // National algorithms
      case EncryptionAlgorithm.aria:
        return [128, 192, 256];
      case EncryptionAlgorithm.seed:
        return [128];
      case EncryptionAlgorithm.sm4:
        return [128];
      case EncryptionAlgorithm.gost28147:
        return [256];
        
      // Legacy algorithms
      case EncryptionAlgorithm.des3:
        return [168]; // Effective key length
      case EncryptionAlgorithm.idea:
        return [128];
      case EncryptionAlgorithm.rc2:
        return [40, 64, 128]; // Common key sizes
      case EncryptionAlgorithm.safer:
        return [64, 128];
      case EncryptionAlgorithm.saferPlus:
        return [128, 192, 256];
        
      // Historical
      case EncryptionAlgorithm.des:
        return [56]; // Effective key length (with parity: 64)
      case EncryptionAlgorithm.rc4:
        return [40, 56, 64, 128, 256]; // Common sizes
        
      // Threefish family
      case EncryptionAlgorithm.threefish256:
        return [256];
      case EncryptionAlgorithm.threefish512:
        return [512];
      case EncryptionAlgorithm.threefish1024:
        return [1024];
        
      // Additional algorithms
      case EncryptionAlgorithm.tea:
      case EncryptionAlgorithm.xtea:
        return [128];
      case EncryptionAlgorithm.shacal2:
        return [128, 192, 256, 384, 512];
      case EncryptionAlgorithm.wake:
        return [128];
        
      // Research/Archive ciphers
      case EncryptionAlgorithm.square:
        return [128];
      case EncryptionAlgorithm.shark:
        return [128];
      case EncryptionAlgorithm.panama:
        return [256];
      case EncryptionAlgorithm.seal:
        return [160];
      case EncryptionAlgorithm.lucifer:
        return [128];
        
      // Lightweight ciphers
      case EncryptionAlgorithm.simon:
        return [64, 96, 128];
      case EncryptionAlgorithm.speck:
        return [64, 96, 128];
    }
  }

  List<OperationMode> getSupportedModes() {
    // Stream ciphers only support stream mode (we'll represent as CTR)
    if (_isStreamCipher()) {
      return [OperationMode.ctr]; // Stream ciphers operate in counter-like mode
    }
    
    // Block ciphers support various modes
    switch (this) {
      // Modern block ciphers - full mode support
      case EncryptionAlgorithm.aes256:
      case EncryptionAlgorithm.aes192:
      case EncryptionAlgorithm.aes128:
      case EncryptionAlgorithm.serpent256:
      case EncryptionAlgorithm.serpent192:
      case EncryptionAlgorithm.serpent128:
      case EncryptionAlgorithm.twofish256:
      case EncryptionAlgorithm.twofish192:
      case EncryptionAlgorithm.twofish128:
      case EncryptionAlgorithm.camellia:
      case EncryptionAlgorithm.aria:
        return [
          OperationMode.gcm,    // Authenticated encryption (preferred)
          OperationMode.cbc,    // Standard mode
          OperationMode.cfb,    // Cipher feedback
          OperationMode.ofb,    // Output feedback  
          OperationMode.ctr,    // Counter mode
          OperationMode.ecb,    // Electronic codebook (less secure)
        ];
        
      // Good block ciphers - most modes
      case EncryptionAlgorithm.rc6:
      case EncryptionAlgorithm.mars:
      case EncryptionAlgorithm.cast256:
      case EncryptionAlgorithm.seed:
      case EncryptionAlgorithm.sm4:
      case EncryptionAlgorithm.idea:
      case EncryptionAlgorithm.blowfish:
        return [
          OperationMode.cbc,
          OperationMode.cfb,
          OperationMode.ofb,
          OperationMode.ctr,
          OperationMode.ecb,
        ];
        
      // Older/simpler block ciphers - basic modes
      case EncryptionAlgorithm.cast128:
      case EncryptionAlgorithm.skipjack:
      case EncryptionAlgorithm.rc5:
      case EncryptionAlgorithm.des3:
      case EncryptionAlgorithm.des:
      case EncryptionAlgorithm.rc2:
      case EncryptionAlgorithm.safer:
      case EncryptionAlgorithm.saferPlus:
      case EncryptionAlgorithm.tea:
      case EncryptionAlgorithm.xtea:
        return [
          OperationMode.cbc,
          OperationMode.cfb,
          OperationMode.ofb,
          OperationMode.ecb,
        ];
        
      // Research/specialized algorithms - limited modes
      case EncryptionAlgorithm.threefish256:
      case EncryptionAlgorithm.threefish512:
      case EncryptionAlgorithm.threefish1024:
      case EncryptionAlgorithm.shacal2:
      case EncryptionAlgorithm.square:
      case EncryptionAlgorithm.shark:
      case EncryptionAlgorithm.gost28147:
      case EncryptionAlgorithm.lucifer:
      case EncryptionAlgorithm.simon:
      case EncryptionAlgorithm.speck:
        return [
          OperationMode.cbc,
          OperationMode.ecb,
        ];
        
      // Special cases or algorithms with unique properties
      default:
        return [OperationMode.cbc, OperationMode.ecb];
    }
  }
  
  bool _isStreamCipher() {
    return [
      EncryptionAlgorithm.chacha20,
      EncryptionAlgorithm.salsa20,
      EncryptionAlgorithm.xsalsa20,
      EncryptionAlgorithm.hc128,
      EncryptionAlgorithm.hc256,
      EncryptionAlgorithm.rabbit,
      EncryptionAlgorithm.sosemanuk,
      EncryptionAlgorithm.rc4,
      EncryptionAlgorithm.wake,
      EncryptionAlgorithm.panama,
      EncryptionAlgorithm.seal,
    ].contains(this);
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
  static const EncryptionAlgorithm defaultAlgorithm = EncryptionAlgorithm.aes256; // Strongest AES
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