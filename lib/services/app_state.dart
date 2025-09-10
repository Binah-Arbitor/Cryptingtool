import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';

import '../models/encryption_config.dart';
import '../models/file_info.dart';
import '../models/log_entry.dart';
import 'cryptography_service.dart';

// Service providers
final cryptographyServiceProvider = Provider<CryptographyService>((ref) {
  return CryptographyService();
});

// File selection state
final selectedFileProvider = StateProvider<FileInfo?>((ref) => null);

// Encryption configuration state
final encryptionConfigProvider = StateProvider<EncryptionConfig>((ref) {
  return const EncryptionConfig(
    algorithm: 'AES',
    keyLength: 256,
    mode: 'GCM',
    password: '',
    threadCount: 1,
  );
});

// Algorithm selection state
final selectedAlgorithmProvider = StateProvider<String>((ref) => 'AES');

// Dynamic key lengths based on selected algorithm
final availableKeyLengthsProvider = Provider<List<int>>((ref) {
  final algorithm = ref.watch(selectedAlgorithmProvider);
  final cryptoAlgo = CryptoAlgorithm.getAlgorithm(algorithm);
  return cryptoAlgo?.supportedKeyLengths ?? [256];
});

// Dynamic modes based on selected algorithm
final availableModesProvider = Provider<List<String>>((ref) {
  final algorithm = ref.watch(selectedAlgorithmProvider);
  final cryptoAlgo = CryptoAlgorithm.getAlgorithm(algorithm);
  return cryptoAlgo?.supportedModes ?? ['GCM'];
});

// Selected key length state
final selectedKeyLengthProvider = StateProvider<int>((ref) {
  final availableKeyLengths = ref.watch(availableKeyLengthsProvider);
  return availableKeyLengths.isNotEmpty ? availableKeyLengths.last : 256;
});

// Selected mode state
final selectedModeProvider = StateProvider<String>((ref) {
  final availableModes = ref.watch(availableModesProvider);
  return availableModes.isNotEmpty ? availableModes.first : 'GCM';
});

// Password state
final passwordProvider = StateProvider<String>((ref) => '');

// Password visibility state
final passwordVisibilityProvider = StateProvider<bool>((ref) => false);

// Thread count state
final threadCountProvider = StateProvider<int>((ref) => 1);

// Maximum thread count based on system
final maxThreadCountProvider = Provider<int>((ref) {
  final service = ref.watch(cryptographyServiceProvider);
  return service.logicalProcessorCount;
});

// Operation status state
final operationStatusProvider = StateProvider<String>((ref) => 'Ready');

// Progress state
final operationProgressProvider = StateProvider<double>((ref) => 0.0);

// Log entries state
final logEntriesProvider = StateNotifierProvider<LogEntriesNotifier, List<LogEntry>>((ref) {
  return LogEntriesNotifier();
});

class LogEntriesNotifier extends StateNotifier<List<LogEntry>> {
  LogEntriesNotifier() : super([]);

  void addLogEntry(LogEntry entry) {
    state = [...state, entry];
  }

  void clearLogs() {
    state = [];
  }
}

// File picker functionality
final filePickerProvider = Provider<Future<FileInfo?> Function()>((ref) {
  return () async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final stat = await file.stat();
        
        final fileInfo = FileInfo(
          path: file.path,
          name: result.files.single.name,
          sizeBytes: stat.size,
        );

        // Update the selected file
        ref.read(selectedFileProvider.notifier).state = fileInfo;
        
        // Add log entry
        ref.read(logEntriesProvider.notifier).addLogEntry(
          LogEntry.info('Selected file: ${fileInfo.name} (${fileInfo.formattedSize})'),
        );
        
        return fileInfo;
      }
    } catch (e) {
      ref.read(logEntriesProvider.notifier).addLogEntry(
        LogEntry.error('Failed to select file: $e'),
      );
    }
    
    return null;
  };
});

// Can encrypt/decrypt check
final canPerformOperationProvider = Provider<bool>((ref) {
  final selectedFile = ref.watch(selectedFileProvider);
  final password = ref.watch(passwordProvider);
  
  return selectedFile != null && password.isNotEmpty;
});

// Current encryption config provider
final currentEncryptionConfigProvider = Provider<EncryptionConfig>((ref) {
  final algorithm = ref.watch(selectedAlgorithmProvider);
  final keyLength = ref.watch(selectedKeyLengthProvider);
  final mode = ref.watch(selectedModeProvider);
  final password = ref.watch(passwordProvider);
  final threadCount = ref.watch(threadCountProvider);

  return EncryptionConfig(
    algorithm: algorithm,
    keyLength: keyLength,
    mode: mode,
    password: password,
    threadCount: threadCount,
  );
});

// Operations provider
final operationsProvider = Provider<CryptographyOperations>((ref) {
  return CryptographyOperations(ref);
});

class CryptographyOperations {
  final Ref ref;
  
  CryptographyOperations(this.ref);

  Future<void> encryptFile() async {
    final file = ref.read(selectedFileProvider);
    final config = ref.read(currentEncryptionConfigProvider);
    
    if (file == null) return;
    
    try {
      final service = ref.read(cryptographyServiceProvider);
      
      // Initialize service if needed
      await service.initialize();
      
      // Listen to service responses
      service.responseStream.listen((response) {
        _handleServiceResponse(response);
      });
      
      // Start encryption
      await service.encryptFile(file, config);
    } catch (e) {
      ref.read(logEntriesProvider.notifier).addLogEntry(
        LogEntry.error('Encryption failed: $e'),
      );
      ref.read(operationStatusProvider.notifier).state = 'Error: $e';
    }
  }

  Future<void> decryptFile() async {
    final file = ref.read(selectedFileProvider);
    final config = ref.read(currentEncryptionConfigProvider);
    
    if (file == null) return;
    
    try {
      final service = ref.read(cryptographyServiceProvider);
      
      // Initialize service if needed
      await service.initialize();
      
      // Listen to service responses
      service.responseStream.listen((response) {
        _handleServiceResponse(response);
      });
      
      // Start decryption
      await service.decryptFile(file, config);
    } catch (e) {
      ref.read(logEntriesProvider.notifier).addLogEntry(
        LogEntry.error('Decryption failed: $e'),
      );
      ref.read(operationStatusProvider.notifier).state = 'Error: $e';
    }
  }

  void _handleServiceResponse(Map<String, dynamic> response) {
    final type = response['type'] as String;
    
    switch (type) {
      case 'log':
        final level = response['level'] as String;
        final message = response['message'] as String;
        
        LogEntry entry;
        switch (level) {
          case 'info':
            entry = LogEntry.info(message);
            break;
          case 'warning':
            entry = LogEntry.warning(message);
            break;
          case 'error':
            entry = LogEntry.error(message);
            break;
          case 'success':
            entry = LogEntry.success(message);
            break;
          default:
            entry = LogEntry.info(message);
        }
        
        ref.read(logEntriesProvider.notifier).addLogEntry(entry);
        break;
        
      case 'progress':
        final progress = response['progress'] as double;
        final status = response['status'] as String;
        
        ref.read(operationProgressProvider.notifier).state = progress;
        ref.read(operationStatusProvider.notifier).state = status;
        break;
        
      case 'complete':
        final success = response['success'] as bool;
        final outputPath = response['outputPath'] as String?;
        
        if (success) {
          ref.read(operationStatusProvider.notifier).state = 'Success';
          ref.read(operationProgressProvider.notifier).state = 1.0;
          
          if (outputPath != null) {
            ref.read(logEntriesProvider.notifier).addLogEntry(
              LogEntry.success('Output saved to: $outputPath'),
            );
          }
        } else {
          ref.read(operationStatusProvider.notifier).state = 'Error';
        }
        break;
        
      case 'error':
        final message = response['message'] as String;
        ref.read(logEntriesProvider.notifier).addLogEntry(
          LogEntry.error(message),
        );
        ref.read(operationStatusProvider.notifier).state = 'Error: $message';
        break;
    }
  }
}