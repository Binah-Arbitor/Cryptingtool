import 'package:equatable/equatable.dart';

// Encryption algorithms supported by Crypto++
enum EncryptionAlgorithm {
  aes('AES'),
  serpent('Serpent'),
  twofish('Twofish'),
  rc6('RC6'),
  blowfish('Blowfish'),
  camellia('Camellia');

  const EncryptionAlgorithm(this.displayName);
  final String displayName;
}

// Key lengths in bits
enum KeyLength {
  bits128(128),
  bits192(192),
  bits256(256);

  const KeyLength(this.bits);
  final int bits;
  
  @override
  String toString() => '$bits-bit';
}

// Operation modes
enum OperationMode {
  cbc('CBC'),
  gcm('GCM'),
  ecb('ECB'),
  cfb('CFB'),
  ofb('OFB'),
  ctr('CTR');

  const OperationMode(this.displayName);
  final String displayName;
}

// Log levels
enum LogLevel {
  info('INFO'),
  warning('WARNING'),
  error('ERROR'),
  success('SUCCESS');

  const LogLevel(this.displayName);
  final String displayName;
}

// Algorithm compatibility map
class AlgorithmCompatibility {
  static Map<EncryptionAlgorithm, List<KeyLength>> keyLengths = {
    EncryptionAlgorithm.aes: [KeyLength.bits128, KeyLength.bits192, KeyLength.bits256],
    EncryptionAlgorithm.serpent: [KeyLength.bits128, KeyLength.bits192, KeyLength.bits256],
    EncryptionAlgorithm.twofish: [KeyLength.bits128, KeyLength.bits192, KeyLength.bits256],
    EncryptionAlgorithm.rc6: [KeyLength.bits128, KeyLength.bits192, KeyLength.bits256],
    EncryptionAlgorithm.blowfish: [KeyLength.bits128], // Blowfish typically uses variable key length, simplified here
    EncryptionAlgorithm.camellia: [KeyLength.bits128, KeyLength.bits192, KeyLength.bits256],
  };

  static Map<EncryptionAlgorithm, List<OperationMode>> operationModes = {
    EncryptionAlgorithm.aes: [OperationMode.cbc, OperationMode.gcm, OperationMode.ecb, OperationMode.cfb, OperationMode.ofb, OperationMode.ctr],
    EncryptionAlgorithm.serpent: [OperationMode.cbc, OperationMode.ecb, OperationMode.cfb, OperationMode.ofb],
    EncryptionAlgorithm.twofish: [OperationMode.cbc, OperationMode.ecb, OperationMode.cfb, OperationMode.ofb],
    EncryptionAlgorithm.rc6: [OperationMode.cbc, OperationMode.ecb, OperationMode.cfb, OperationMode.ofb],
    EncryptionAlgorithm.blowfish: [OperationMode.cbc, OperationMode.ecb, OperationMode.cfb, OperationMode.ofb],
    EncryptionAlgorithm.camellia: [OperationMode.cbc, OperationMode.ecb, OperationMode.cfb, OperationMode.ofb],
  };

  static List<KeyLength> getAvailableKeyLengths(EncryptionAlgorithm algorithm) {
    return keyLengths[algorithm] ?? [KeyLength.bits128];
  }

  static List<OperationMode> getAvailableOperationModes(EncryptionAlgorithm algorithm) {
    return operationModes[algorithm] ?? [OperationMode.cbc];
  }
}

// Encryption configuration state
class EncryptionConfig extends Equatable {
  final EncryptionAlgorithm algorithm;
  final KeyLength keyLength;
  final OperationMode operationMode;
  final String password;
  final int threadCount;

  const EncryptionConfig({
    required this.algorithm,
    required this.keyLength,
    required this.operationMode,
    required this.password,
    required this.threadCount,
  });

  EncryptionConfig copyWith({
    EncryptionAlgorithm? algorithm,
    KeyLength? keyLength,
    OperationMode? operationMode,
    String? password,
    int? threadCount,
  }) {
    return EncryptionConfig(
      algorithm: algorithm ?? this.algorithm,
      keyLength: keyLength ?? this.keyLength,
      operationMode: operationMode ?? this.operationMode,
      password: password ?? this.password,
      threadCount: threadCount ?? this.threadCount,
    );
  }

  @override
  List<Object?> get props => [algorithm, keyLength, operationMode, password, threadCount];
}

// Application state
enum AppState {
  ready,
  encrypting,
  decrypting,
  completed,
  error;
}

// File information
class FileInfo extends Equatable {
  final String name;
  final String path;
  final int sizeBytes;

  const FileInfo({
    required this.name,
    required this.path,
    required this.sizeBytes,
  });

  String get formattedSize {
    if (sizeBytes < 1024) return '$sizeBytes B';
    if (sizeBytes < 1024 * 1024) return '${(sizeBytes / 1024).toStringAsFixed(1)} KB';
    if (sizeBytes < 1024 * 1024 * 1024) return '${(sizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(sizeBytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  @override
  List<Object?> get props => [name, path, sizeBytes];
}

// Log entry
class LogEntry extends Equatable {
  final DateTime timestamp;
  final LogLevel level;
  final String message;

  const LogEntry({
    required this.timestamp,
    required this.level,
    required this.message,
  });

  String get formattedTime {
    return '${timestamp.hour.toString().padLeft(2, '0')}:'
           '${timestamp.minute.toString().padLeft(2, '0')}:'
           '${timestamp.second.toString().padLeft(2, '0')}.'
           '${timestamp.millisecond.toString().padLeft(3, '0')}';
  }

  @override
  List<Object?> get props => [timestamp, level, message];
}

// Progress information
class ProgressInfo extends Equatable {
  final double progress; // 0.0 to 1.0
  final String statusMessage;
  final AppState state;

  const ProgressInfo({
    required this.progress,
    required this.statusMessage,
    required this.state,
  });

  ProgressInfo copyWith({
    double? progress,
    String? statusMessage,
    AppState? state,
  }) {
    return ProgressInfo(
      progress: progress ?? this.progress,
      statusMessage: statusMessage ?? this.statusMessage,
      state: state ?? this.state,
    );
  }

  @override
  List<Object?> get props => [progress, statusMessage, state];
}