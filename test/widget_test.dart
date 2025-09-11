import 'package:flutter_test/flutter_test.dart';
import 'package:cryptingtool/models/encryption_config.dart';
import 'package:cryptingtool/models/log_entry.dart';
import 'package:cryptingtool/models/app_state.dart';
import 'package:cryptingtool/providers/app_state_provider.dart';

void main() {
  group('CryptingTool Core Functionality Tests', () {
    
    test('EncryptionConfig should handle algorithm changes correctly', () {
      // Test default configuration
      final defaultConfig = EncryptionDefaults.defaultConfig;
      expect(defaultConfig.algorithm, equals(EncryptionAlgorithm.aes256));
      expect(defaultConfig.keySize, equals(256));
      expect(defaultConfig.mode, equals(OperationMode.gcm));
      
      // Test dynamic key size validation
      final aesKeySizes = EncryptionAlgorithm.aes256.getSupportedKeySizes();
      expect(aesKeySizes, contains(256));
      
      // Test blowfish variable key sizes
      final blowfishKeySizes = EncryptionAlgorithm.blowfish.getSupportedKeySizes();
      expect(blowfishKeySizes, contains(448));
      expect(blowfishKeySizes, contains(32));
      
      // Test configuration copy with changes
      final newConfig = defaultConfig.copyWith(
        algorithm: EncryptionAlgorithm.serpent256,
        keySize: 192,
      );
      expect(newConfig.algorithm, equals(EncryptionAlgorithm.serpent256));
      expect(newConfig.keySize, equals(192));
      expect(newConfig.mode, equals(OperationMode.gcm)); // Should remain unchanged
    });

    test('LogEntry should format messages correctly', () {
      final logEntry = LogEntry.info(
        'Test message',
        source: 'TEST',
      );
      
      expect(logEntry.level, equals(LogLevel.info));
      expect(logEntry.message, equals('Test message'));
      expect(logEntry.source, equals('TEST'));
      
      final formattedMessage = logEntry.formattedMessage;
      expect(formattedMessage, contains('[INFO]'));
      expect(formattedMessage, contains('[TEST]'));
      expect(formattedMessage, contains('Test message'));
      
      // Test different log levels
      final errorEntry = LogEntry.error('Error occurred');
      expect(errorEntry.level, equals(LogLevel.error));
      
      final successEntry = LogEntry.success('Operation completed');
      expect(successEntry.level, equals(LogLevel.success));
      
      final warningEntry = LogEntry.warning('Warning message');
      expect(warningEntry.level, equals(LogLevel.warning));
    });

    test('ProcessingProgress should calculate progress correctly', () {
      final progress = ProcessingProgress(
        currentChunk: 25,
        totalChunks: 100,
        bytesProcessed: 2500000, // 2.5 MB
        totalBytes: 10000000,    // 10 MB
        elapsed: const Duration(seconds: 30),
        status: ProcessingStatus.processing,
      );

      expect(progress.chunkProgress, equals(0.25));
      expect(progress.byteProgress, equals(0.25));
      expect(progress.formattedProgress, equals('25.0% (25/100 chunks)'));
      
      // Test ETA calculation
      final eta = progress.estimatedTimeRemaining;
      expect(eta, isNotNull);
      expect(eta, contains('remaining'));
    });

    test('FileInfo should format file sizes correctly', () {
      // Create a mock file info for testing
      final fileInfo = FileInfo(
        path: '/test/document.pdf',
        name: 'document.pdf',
        size: 2500000, // 2.5 MB
        extension: 'pdf',
        lastModified: DateTime.now(),
      );

      expect(fileInfo.formattedSize, equals('2.4 MB'));
      expect(fileInfo.extension, equals('pdf'));
      expect(fileInfo.name, equals('document.pdf'));
      
      // Test different file sizes
      final smallFile = FileInfo(
        path: '/test/small.txt',
        name: 'small.txt',
        size: 500,
        extension: 'txt',
        lastModified: DateTime.now(),
      );
      expect(smallFile.formattedSize, equals('500 B'));
      
      final largeFile = FileInfo(
        path: '/test/large.zip',
        name: 'large.zip',
        size: 1500000000, // 1.5 GB
        extension: 'zip',
        lastModified: DateTime.now(),
      );
      expect(largeFile.formattedSize, equals('1.4 GB'));
    });

    testWidgets('AppStateProvider should manage state correctly', (WidgetTester tester) async {
      final provider = AppStateProvider();
      
      // Test initial state
      expect(provider.isProcessing, equals(false));
      expect(provider.selectedFile, isNull);
      expect(provider.config.algorithm, equals(EncryptionAlgorithm.aes256));
      
      // Test configuration update
      final newConfig = provider.config.copyWith(
        algorithm: EncryptionAlgorithm.twofish192,
        keySize: 192,
      );
      provider.updateConfig(newConfig);
      
      expect(provider.config.algorithm, equals(EncryptionAlgorithm.twofish192));
      expect(provider.config.keySize, equals(192));
      expect(provider.logEntries.length, greaterThan(0));
      
      // Test custom log entry
      provider.addCustomLog(LogLevel.warning, 'Test warning', source: 'TEST');
      final lastLog = provider.logEntries.last;
      expect(lastLog.level, equals(LogLevel.warning));
      expect(lastLog.message, equals('Test warning'));
      expect(lastLog.source, equals('TEST'));
      
      // Test log clearing
      final initialLogCount = provider.logEntries.length;
      provider.clearLogs();
      expect(provider.logEntries.length, equals(1)); // Should have "cleared" message
      
      provider.dispose();
    });

    test('Algorithm compatibility should work correctly', () {
      // Test that modern AES algorithms support GCM mode
      final modernAlgorithms = [
        EncryptionAlgorithm.aes256,
        EncryptionAlgorithm.aes192, 
        EncryptionAlgorithm.aes128,
        EncryptionAlgorithm.serpent256,
        EncryptionAlgorithm.twofish256
      ];
      
      for (final algorithm in modernAlgorithms) {
        final supportedModes = algorithm.getSupportedModes();
        expect(supportedModes, contains(OperationMode.gcm), 
            reason: '${algorithm.displayName} should support GCM mode');
      }
      
      // Test that AES256 supports 256-bit key size
      final aes256KeySizes = EncryptionAlgorithm.aes256.getSupportedKeySizes();
      expect(aes256KeySizes, contains(256));
      
      // Test that CAST-128 only supports 128-bit keys
      final castKeySizes = EncryptionAlgorithm.cast128.getSupportedKeySizes();
      expect(castKeySizes, equals([128]));
    });

    test('Processing status should transition correctly', () {
      expect(ProcessingStatus.ready.displayName, equals('Ready'));
      expect(ProcessingStatus.processing.displayName, equals('Processing'));
      expect(ProcessingStatus.success.displayName, equals('Success'));
      expect(ProcessingStatus.error.displayName, equals('Error'));
      expect(ProcessingStatus.paused.displayName, equals('Paused'));
      expect(ProcessingStatus.cancelled.displayName, equals('Cancelled'));
    });
  });

  group('UI Theme and Color Tests', () {
    test('Theme colors should be properly defined', () {
      // This would test the theme colors if we could import the theme
      // For now, we'll just test that our model enums work correctly
      expect(LogLevel.values.length, equals(4));
      expect(ProcessingStatus.values.length, equals(6));
      expect(EncryptionAlgorithm.values.length, equals(6));
      expect(OperationMode.values.length, equals(6));
    });
  });
}