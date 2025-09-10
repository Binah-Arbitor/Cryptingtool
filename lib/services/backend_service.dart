import 'dart:async';
import 'dart:isolate';
import 'dart:io';
import '../models/encryption_models.dart';

// Backend communication service interface
class BackendService {
  static final BackendService _instance = BackendService._internal();
  factory BackendService() => _instance;
  BackendService._internal();

  // Stream controllers for real-time communication
  final StreamController<LogEntry> _logController = StreamController<LogEntry>.broadcast();
  final StreamController<ProgressInfo> _progressController = StreamController<ProgressInfo>.broadcast();

  // Streams for UI to listen to
  Stream<LogEntry> get logStream => _logController.stream;
  Stream<ProgressInfo> get progressStream => _progressController.stream;

  // Current state
  ProgressInfo _currentProgress = const ProgressInfo(
    progress: 0.0,
    statusMessage: 'Ready',
    state: AppState.ready,
  );

  ProgressInfo get currentProgress => _currentProgress;

  // Initialize backend communication
  Future<void> initialize() async {
    _addLog(LogLevel.info, 'Backend service initialized');
    _updateProgress(0.0, 'Ready', AppState.ready);
  }

  // Start encryption process
  Future<void> startEncryption({
    required FileInfo fileInfo,
    required EncryptionConfig config,
    required String outputPath,
  }) async {
    try {
      _updateProgress(0.0, 'Initializing encryption...', AppState.encrypting);
      _addLog(LogLevel.info, 'Starting encryption of ${fileInfo.name}');
      _addLog(LogLevel.info, 'Algorithm: ${config.algorithm.displayName}');
      _addLog(LogLevel.info, 'Key length: ${config.keyLength.toString()}');
      _addLog(LogLevel.info, 'Operation mode: ${config.operationMode.displayName}');
      _addLog(LogLevel.info, 'Thread count: ${config.threadCount}');

      // Simulate backend encryption process
      await _simulateEncryptionProcess(fileInfo, config);
      
      _updateProgress(1.0, 'Encryption completed successfully', AppState.completed);
      _addLog(LogLevel.success, 'File encrypted successfully');
      
    } catch (e) {
      _updateProgress(0.0, 'Encryption failed: ${e.toString()}', AppState.error);
      _addLog(LogLevel.error, 'Encryption failed: ${e.toString()}');
      rethrow;
    }
  }

  // Start decryption process
  Future<void> startDecryption({
    required FileInfo fileInfo,
    required EncryptionConfig config,
    required String outputPath,
  }) async {
    try {
      _updateProgress(0.0, 'Initializing decryption...', AppState.decrypting);
      _addLog(LogLevel.info, 'Starting decryption of ${fileInfo.name}');
      _addLog(LogLevel.info, 'Algorithm: ${config.algorithm.displayName}');
      _addLog(LogLevel.info, 'Key length: ${config.keyLength.toString()}');
      _addLog(LogLevel.info, 'Operation mode: ${config.operationMode.displayName}');
      _addLog(LogLevel.info, 'Thread count: ${config.threadCount}');

      // Simulate backend decryption process
      await _simulateDecryptionProcess(fileInfo, config);
      
      _updateProgress(1.0, 'Decryption completed successfully', AppState.completed);
      _addLog(LogLevel.success, 'File decrypted successfully');
      
    } catch (e) {
      _updateProgress(0.0, 'Decryption failed: ${e.toString()}', AppState.error);
      _addLog(LogLevel.error, 'Decryption failed: ${e.toString()}');
      rethrow;
    }
  }

  // Stop current operation
  Future<void> stopOperation() async {
    if (_currentProgress.state == AppState.encrypting || 
        _currentProgress.state == AppState.decrypting) {
      _updateProgress(0.0, 'Operation cancelled', AppState.ready);
      _addLog(LogLevel.warning, 'Operation cancelled by user');
    }
  }

  // Clear logs
  void clearLogs() {
    _addLog(LogLevel.info, 'Logs cleared');
  }

  // Get system information
  int getLogicalProcessorCount() {
    return Platform.numberOfProcessors;
  }

  // Private methods for simulation
  Future<void> _simulateEncryptionProcess(FileInfo fileInfo, EncryptionConfig config) async {
    final totalChunks = (fileInfo.sizeBytes / (1024 * 1024)).ceil().clamp(1, 100); // Simulate chunks
    
    _addLog(LogLevel.info, 'Creating ${config.threadCount} worker threads');
    await Future.delayed(const Duration(milliseconds: 200));
    
    _addLog(LogLevel.info, 'Initializing Crypto++ ${config.algorithm.displayName} cipher');
    await Future.delayed(const Duration(milliseconds: 150));
    
    _addLog(LogLevel.info, 'Preparing ${config.keyLength.toString()} key derivation');
    await Future.delayed(const Duration(milliseconds: 100));
    
    _addLog(LogLevel.info, 'Processing $totalChunks data chunks');
    
    for (int i = 1; i <= totalChunks; i++) {
      final progress = i / totalChunks;
      _updateProgress(progress, 'Encrypting chunk $i of $totalChunks...', AppState.encrypting);
      
      if (i % 10 == 0) {
        _addLog(LogLevel.info, 'Processed $i/$totalChunks chunks (${(progress * 100).toStringAsFixed(1)}%)');
      }
      
      await Future.delayed(const Duration(milliseconds: 50)); // Simulate processing time
    }
    
    _addLog(LogLevel.info, 'Finalizing encryption and writing output file');
    await Future.delayed(const Duration(milliseconds: 200));
  }

  Future<void> _simulateDecryptionProcess(FileInfo fileInfo, EncryptionConfig config) async {
    final totalChunks = (fileInfo.sizeBytes / (1024 * 1024)).ceil().clamp(1, 100); // Simulate chunks
    
    _addLog(LogLevel.info, 'Creating ${config.threadCount} worker threads');
    await Future.delayed(const Duration(milliseconds: 200));
    
    _addLog(LogLevel.info, 'Validating encrypted file header');
    await Future.delayed(const Duration(milliseconds: 100));
    
    _addLog(LogLevel.info, 'Initializing Crypto++ ${config.algorithm.displayName} cipher');
    await Future.delayed(const Duration(milliseconds: 150));
    
    _addLog(LogLevel.info, 'Deriving ${config.keyLength.toString()} key from password');
    await Future.delayed(const Duration(milliseconds: 100));
    
    _addLog(LogLevel.info, 'Processing $totalChunks encrypted chunks');
    
    for (int i = 1; i <= totalChunks; i++) {
      final progress = i / totalChunks;
      _updateProgress(progress, 'Decrypting chunk $i of $totalChunks...', AppState.decrypting);
      
      if (i % 10 == 0) {
        _addLog(LogLevel.info, 'Processed $i/$totalChunks chunks (${(progress * 100).toStringAsFixed(1)}%)');
      }
      
      await Future.delayed(const Duration(milliseconds: 50)); // Simulate processing time
    }
    
    _addLog(LogLevel.info, 'Verifying decryption integrity');
    await Future.delayed(const Duration(milliseconds: 150));
    
    _addLog(LogLevel.info, 'Writing decrypted output file');
    await Future.delayed(const Duration(milliseconds: 200));
  }

  void _addLog(LogLevel level, String message) {
    final logEntry = LogEntry(
      timestamp: DateTime.now(),
      level: level,
      message: message,
    );
    _logController.add(logEntry);
  }

  void _updateProgress(double progress, String message, AppState state) {
    _currentProgress = ProgressInfo(
      progress: progress,
      statusMessage: message,
      state: state,
    );
    _progressController.add(_currentProgress);
  }

  // Dispose resources
  void dispose() {
    _logController.close();
    _progressController.close();
  }
}