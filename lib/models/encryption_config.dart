/// Encryption configuration data model
class EncryptionConfig {
  final String algorithm;
  final int keyLength;
  final String mode;
  final String password;
  final int threadCount;

  const EncryptionConfig({
    required this.algorithm,
    required this.keyLength,
    required this.mode,
    required this.password,
    this.threadCount = 1,
  });

  EncryptionConfig copyWith({
    String? algorithm,
    int? keyLength,
    String? mode,
    String? password,
    int? threadCount,
  }) {
    return EncryptionConfig(
      algorithm: algorithm ?? this.algorithm,
      keyLength: keyLength ?? this.keyLength,
      mode: mode ?? this.mode,
      password: password ?? this.password,
      threadCount: threadCount ?? this.threadCount,
    );
  }

  @override
  String toString() {
    return 'EncryptionConfig(algorithm: $algorithm, keyLength: $keyLength, mode: $mode, threadCount: $threadCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EncryptionConfig &&
        other.algorithm == algorithm &&
        other.keyLength == keyLength &&
        other.mode == mode &&
        other.password == password &&
        other.threadCount == threadCount;
  }

  @override
  int get hashCode {
    return algorithm.hashCode ^
        keyLength.hashCode ^
        mode.hashCode ^
        password.hashCode ^
        threadCount.hashCode;
  }
}

/// Supported encryption algorithms with their configurations
class CryptoAlgorithm {
  final String name;
  final List<int> supportedKeyLengths;
  final List<String> supportedModes;

  const CryptoAlgorithm({
    required this.name,
    required this.supportedKeyLengths,
    required this.supportedModes,
  });

  static const List<CryptoAlgorithm> supportedAlgorithms = [
    CryptoAlgorithm(
      name: 'AES',
      supportedKeyLengths: [128, 192, 256],
      supportedModes: ['CBC', 'GCM', 'ECB', 'CFB', 'OFB'],
    ),
    CryptoAlgorithm(
      name: 'Serpent',
      supportedKeyLengths: [128, 192, 256],
      supportedModes: ['CBC', 'ECB', 'CFB', 'OFB'],
    ),
    CryptoAlgorithm(
      name: 'Twofish',
      supportedKeyLengths: [128, 192, 256],
      supportedModes: ['CBC', 'ECB', 'CFB', 'OFB'],
    ),
    CryptoAlgorithm(
      name: 'RC6',
      supportedKeyLengths: [128, 192, 256],
      supportedModes: ['CBC', 'ECB', 'CFB', 'OFB'],
    ),
    CryptoAlgorithm(
      name: 'Blowfish',
      supportedKeyLengths: [128, 192, 256, 448],
      supportedModes: ['CBC', 'ECB', 'CFB', 'OFB'],
    ),
  ];

  static CryptoAlgorithm? getAlgorithm(String name) {
    return supportedAlgorithms.cast<CryptoAlgorithm?>().firstWhere(
      (algo) => algo?.name == name,
      orElse: () => null,
    );
  }
}