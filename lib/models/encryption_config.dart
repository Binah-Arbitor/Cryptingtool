enum EncryptionAlgorithm {
  aes('AES', 'Advanced Encryption Standard'),
  serpent('Serpent', 'Serpent Block Cipher'),
  twofish('Twofish', 'Twofish Block Cipher'),
  rc6('RC6', 'RC6 Block Cipher'),
  blowfish('Blowfish', 'Blowfish Block Cipher'),
  cast128('CAST-128', 'CAST-128 Block Cipher');

  const EncryptionAlgorithm(this.displayName, this.description);

  final String displayName;
  final String description;

  List<int> getSupportedKeySizes() {
    switch (this) {
      case EncryptionAlgorithm.aes:
        return [128, 192, 256];
      case EncryptionAlgorithm.serpent:
        return [128, 192, 256];
      case EncryptionAlgorithm.twofish:
        return [128, 192, 256];
      case EncryptionAlgorithm.rc6:
        return [128, 192, 256];
      case EncryptionAlgorithm.blowfish:
        return [32, 64, 128, 256, 448]; // Blowfish supports variable key sizes
      case EncryptionAlgorithm.cast128:
        return [128];
    }
  }

  List<OperationMode> getSupportedModes() {
    // Most algorithms support these modes
    return [
      OperationMode.cbc,
      OperationMode.gcm,
      OperationMode.cfb,
      OperationMode.ofb,
      OperationMode.ctr,
    ];
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