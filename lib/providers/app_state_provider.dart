import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import '../models/encryption_config.dart';
import '../models/log_entry.dart';
import '../models/app_state.dart';
import '../crypto_bridge/crypto_bridge_service.dart';

class AppStateProvider with ChangeNotifier {
  // Configuration
  EncryptionConfig _config = EncryptionDefaults.defaultConfig;
  
  // File management
  FileInfo? _selectedFile;
  
  // Processing state
  ProcessingProgress _progress = ProcessingProgress.initial;
  
  // Logging
  final List<LogEntry> _logEntries = [];
  final StreamController<LogEntry> _logController = StreamController<LogEntry>.broadcast();
  
  // Status
  String _statusMessage = '';
  bool _isProcessing = false;

  // Getters
  EncryptionConfig get config => _config;
  FileInfo? get selectedFile => _selectedFile;
  ProcessingProgress get progress => _progress;
  List<LogEntry> get logEntries => List.unmodifiable(_logEntries);
  String get statusMessage => _statusMessage;
  bool get isProcessing => _isProcessing;
  Stream<LogEntry> get logStream => _logController.stream;

  // Configuration methods
  void updateConfig(EncryptionConfig newConfig) {
    _config = newConfig;
    _addLog(LogEntry.info(
      'Configuration updated: ${newConfig.algorithm.displayName} ${newConfig.keySize}-bit ${newConfig.mode.displayName}',
      source: 'CONFIG',
    ));
    notifyListeners();
  }

  void setThreadCount(int threadCount) {
    _config = _config.copyWith(threadCount: threadCount);
    _addLog(LogEntry.info(
      'Thread count set to $threadCount (Max: ${Platform.numberOfProcessors})',
      source: 'THREADING',
    ));
    notifyListeners();
  }

  // File management methods
  void selectFile(FileInfo file) {
    _selectedFile = file;
    _addLog(LogEntry.info(
      'File selected: ${file.name} (${file.formattedSize})',
      source: 'FILE_IO',
    ));
    _updateStatus('File selected: ${file.name}');
    notifyListeners();
  }

  void clearFile() {
    if (_selectedFile != null) {
      _addLog(LogEntry.info(
        'File cleared: ${_selectedFile!.name}',
        source: 'FILE_IO',
      ));
      _selectedFile = null;
      _updateStatus('File cleared');
      notifyListeners();
    }
  }

  // Processing methods
  Future<void> encryptFile() async {
    if (_selectedFile == null) {
      _addLog(LogEntry.error('No file selected for encryption', source: 'ENCRYPT'));
      return;
    }

    if (_config.password.isEmpty) {
      _addLog(LogEntry.error('Password is required for encryption', source: 'ENCRYPT'));
      return;
    }

    await _processFile(isEncryption: true);
  }

  Future<void> decryptFile() async {
    if (_selectedFile == null) {
      _addLog(LogEntry.error('No file selected for decryption', source: 'DECRYPT'));
      return;
    }

    if (_config.password.isEmpty) {
      _addLog(LogEntry.error('Password is required for decryption', source: 'DECRYPT'));
      return;
    }

    await _processFile(isEncryption: false);
  }

  Future<void> _processFile({required bool isEncryption}) async {
    if (_isProcessing) return;

    // Check if crypto service is available
    if (!CryptoBridgeService.isInitialized) {
      _addLog(LogEntry.error('Crypto bridge not initialized', source: 'ERROR'));
      return;
    }

    _isProcessing = true;
    final operation = isEncryption ? 'Encryption' : 'Decryption';
    final file = _selectedFile!;
    
    try {
      // Initialize progress
      _progress = ProcessingProgress(
        currentChunk: 0,
        totalChunks: _calculateChunks(file.size),
        bytesProcessed: 0,
        totalBytes: file.size,
        elapsed: Duration.zero,
        status: ProcessingStatus.processing,
        currentOperation: '$operation starting...',
      );

      _addLog(LogEntry.info(
        '$operation started for ${file.name}',
        source: operation.toUpperCase(),
      ));

      _addLog(LogEntry.info(
        'Using ${_config.algorithm.displayName} ${_config.keySize}-bit ${_config.mode.displayName}',
        source: 'CRYPTO',
      ));

      _addLog(LogEntry.info(
        'Backend: C++ Crypto++ library v${CryptoBridgeService.getVersion()}',
        source: 'BACKEND',
      ));

      final startTime = DateTime.now();
      
      // Read file data
      _addLog(LogEntry.info('Reading file data...', source: 'FILE_IO'));
      final fileObj = File(file.path);
      if (!await fileObj.exists()) {
        throw Exception('File not found: ${file.path}');
      }
      
      final inputData = await fileObj.readAsBytes();
      _addLog(LogEntry.info('Read ${inputData.length} bytes from file', source: 'FILE_IO'));

      // Perform actual crypto operation
      _progress = _progress.copyWith(
        currentOperation: 'Performing $operation...',
        currentChunk: 1,
      );
      notifyListeners();

      final result = isEncryption 
          ? await CryptoBridgeService.encrypt(config: _config, data: inputData)
          : await CryptoBridgeService.decrypt(config: _config, data: inputData);

      if (result.success) {
        // Save output file
        final outputPath = _generateOutputPath(file.path, isEncryption);
        final outputFile = File(outputPath);
        
        _addLog(LogEntry.info('Writing output to: $outputPath', source: 'FILE_IO'));
        await outputFile.writeAsBytes(result.data!);
        
        final elapsed = DateTime.now().difference(startTime);
        
        // Success
        _progress = _progress.copyWith(
          status: ProcessingStatus.success,
          currentOperation: '$operation completed successfully',
          currentChunk: _progress.totalChunks,
          bytesProcessed: file.size,
          elapsed: elapsed,
        );
        
        _addLog(LogEntry.success(
          '$operation completed in ${elapsed.inMilliseconds}ms',
          source: operation.toUpperCase(),
        ));

        _addLog(LogEntry.success(
          'Output saved: $outputPath (${result.data!.length} bytes)',
          source: 'FILE_IO',
        ));

        _updateStatus('$operation completed successfully');
      } else {
        throw Exception(result.error!);
      }

    } catch (e) {
      // Error handling
      _progress = _progress.copyWith(
        status: ProcessingStatus.error,
        currentOperation: '$operation failed',
      );
      
      _addLog(LogEntry.error(
        '$operation failed: $e',
        source: operation.toUpperCase(),
      ));

      _updateStatus('$operation failed - check logs');

    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  void cancelOperation() {
    if (_isProcessing) {
      _isProcessing = false;
      _progress = _progress.copyWith(
        status: ProcessingStatus.cancelled,
        currentOperation: 'Operation cancelled by user',
      );
      
      _addLog(LogEntry.warning(
        'Operation cancelled by user',
        source: 'SYSTEM',
      ));
      
      _updateStatus('Operation cancelled');
      notifyListeners();
    }
  }

  int _calculateChunks(int fileSize) {
    const chunkSize = 64 * 1024; // 64KB chunks
    return (fileSize / chunkSize).ceil().clamp(1, 1000); // Minimum 1, maximum 1000 chunks for demo
  }

  // Logging methods
  void _addLog(LogEntry entry) {
    _logEntries.add(entry);
    _logController.add(entry);
    
    // Keep only the last 1000 entries to prevent memory issues
    if (_logEntries.length > 1000) {
      _logEntries.removeRange(0, _logEntries.length - 1000);
    }
    
    notifyListeners();
  }

  void addCustomLog(LogLevel level, String message, {String? source}) {
    final entry = LogEntry(
      timestamp: DateTime.now(),
      level: level,
      message: message,
      source: source,
    );
    _addLog(entry);
  }

  void clearLogs() {
    _logEntries.clear();
    _addLog(LogEntry.info(
      'Log console cleared',
      source: 'SYSTEM',
    ));
    notifyListeners();
  }

  void _updateStatus(String message) {
    _statusMessage = message;
    notifyListeners();
  }

  // Generate output file path based on operation
  String _generateOutputPath(String inputPath, bool isEncryption) {
    final file = File(inputPath);
    final directory = file.parent.path;
    final name = file.uri.pathSegments.last;
    
    if (isEncryption) {
      // Add .enc extension for encrypted files
      final baseName = name.contains('.') 
          ? name.substring(0, name.lastIndexOf('.'))
          : name;
      final extension = name.contains('.') 
          ? name.substring(name.lastIndexOf('.'))
          : '';
      return '$directory/${baseName}_encrypted${extension}.enc';
    } else {
      // Remove .enc extension and _encrypted suffix for decrypted files
      if (name.endsWith('.enc')) {
        final withoutEnc = name.substring(0, name.length - 4);
        if (withoutEnc.contains('_encrypted')) {
          return '$directory/${withoutEnc.replaceAll('_encrypted', '_decrypted')}';
        }
        return '$directory/${withoutEnc}_decrypted';
      }
      return '$directory/${name}_decrypted';
    }
  }

  // System initialization
  void initializeSystem() {
    _addLog(LogEntry.info(
      'CryptingTool UI initialized',
      source: 'SYSTEM',
    ));
    
    _addLog(LogEntry.info(
      'System: ${Platform.operatingSystem} (${Platform.numberOfProcessors} cores)',
      source: 'SYSTEM',
    ));
    
    _addLog(LogEntry.info(
      'Default configuration: ${_config.algorithm.displayName} ${_config.keySize}-bit ${_config.mode.displayName}',
      source: 'CONFIG',
    ));

    _updateStatus('System ready');
    notifyListeners();
  }

  @override
  void dispose() {
    _logController.close();
    super.dispose();
  }
}