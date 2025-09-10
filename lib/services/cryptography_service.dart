import 'dart:async';
import 'dart:isolate';
import 'dart:io';

import '../models/encryption_config.dart';
import '../models/file_info.dart';
import '../models/log_entry.dart';

/// Service for managing background encryption/decryption operations
/// This service manages an Isolate for FFI communication with C++ backend
class CryptographyService {
  static final CryptographyService _instance = CryptographyService._internal();
  factory CryptographyService() => _instance;
  CryptographyService._internal();

  Isolate? _isolate;
  SendPort? _sendPort;
  ReceivePort? _receivePort;
  late StreamController<Map<String, dynamic>> _responseController;
  
  Stream<Map<String, dynamic>> get responseStream => _responseController.stream;

  /// Initialize the service and create the background Isolate
  Future<void> initialize() async {
    if (_isolate != null) return;
    
    _responseController = StreamController<Map<String, dynamic>>.broadcast();
    _receivePort = ReceivePort();
    
    // Listen for responses from the Isolate
    _receivePort!.listen((dynamic data) {
      if (data is Map<String, dynamic>) {
        _responseController.add(data);
      }
    });

    // Create the Isolate
    _isolate = await Isolate.spawn(
      _isolateEntryPoint,
      _receivePort!.sendPort,
    );

    // Wait for the SendPort from the Isolate
    final Completer<SendPort> sendPortCompleter = Completer<SendPort>();
    _receivePort!.listen((dynamic data) {
      if (data is SendPort) {
        _sendPort = data;
        sendPortCompleter.complete(data);
      }
    });

    await sendPortCompleter.future;
  }

  /// Entry point for the background Isolate
  static void _isolateEntryPoint(SendPort mainSendPort) async {
    final receivePort = ReceivePort();
    mainSendPort.send(receivePort.sendPort);

    await for (final message in receivePort) {
      if (message is Map<String, dynamic>) {
        await _handleIsolateMessage(message, mainSendPort);
      }
    }
  }

  /// Handle messages in the Isolate
  static Future<void> _handleIsolateMessage(
    Map<String, dynamic> message,
    SendPort sendPort,
  ) async {
    try {
      final String action = message['action'] as String;
      
      switch (action) {
        case 'encrypt':
          await _performEncryption(message, sendPort);
          break;
        case 'decrypt':
          await _performDecryption(message, sendPort);
          break;
        default:
          sendPort.send({
            'type': 'error',
            'message': 'Unknown action: $action',
          });
      }
    } catch (e) {
      sendPort.send({
        'type': 'error',
        'message': 'Isolate error: $e',
      });
    }
  }

  /// Perform encryption operation (simulated - would use FFI in real implementation)
  static Future<void> _performEncryption(
    Map<String, dynamic> message,
    SendPort sendPort,
  ) async {
    final String filePath = message['filePath'] as String;
    final EncryptionConfig config = message['config'] as EncryptionConfig;
    
    // Send initial log
    sendPort.send({
      'type': 'log',
      'level': 'info',
      'message': 'Starting encryption with ${config.algorithm} algorithm',
    });

    // Simulate progress updates
    for (int i = 0; i <= 100; i += 10) {
      await Future.delayed(const Duration(milliseconds: 200));
      
      sendPort.send({
        'type': 'progress',
        'progress': i / 100,
        'status': 'Encrypting chunk ${(i / 10).floor() + 1} of 11...',
      });

      sendPort.send({
        'type': 'log',
        'level': 'info',
        'message': 'Processed ${i}% of file',
      });
    }

    // Send completion
    sendPort.send({
      'type': 'complete',
      'success': true,
      'outputPath': '$filePath.encrypted',
    });

    sendPort.send({
      'type': 'log',
      'level': 'success',
      'message': 'Encryption completed successfully',
    });
  }

  /// Perform decryption operation (simulated - would use FFI in real implementation)
  static Future<void> _performDecryption(
    Map<String, dynamic> message,
    SendPort sendPort,
  ) async {
    final String filePath = message['filePath'] as String;
    final EncryptionConfig config = message['config'] as EncryptionConfig;
    
    // Send initial log
    sendPort.send({
      'type': 'log',
      'level': 'info',
      'message': 'Starting decryption with ${config.algorithm} algorithm',
    });

    // Simulate progress updates
    for (int i = 0; i <= 100; i += 15) {
      await Future.delayed(const Duration(milliseconds: 250));
      
      sendPort.send({
        'type': 'progress',
        'progress': i / 100,
        'status': 'Decrypting chunk ${(i / 15).floor() + 1} of 7...',
      });

      sendPort.send({
        'type': 'log',
        'level': 'info',
        'message': 'Processed ${i}% of file',
      });
    }

    // Send completion
    final String outputPath = filePath.replaceAll('.encrypted', '');
    sendPort.send({
      'type': 'complete',
      'success': true,
      'outputPath': outputPath,
    });

    sendPort.send({
      'type': 'log',
      'level': 'success',
      'message': 'Decryption completed successfully',
    });
  }

  /// Start encryption operation
  Future<void> encryptFile(FileInfo file, EncryptionConfig config) async {
    if (_sendPort == null) {
      throw StateError('Service not initialized');
    }

    _sendPort!.send({
      'action': 'encrypt',
      'filePath': file.path,
      'config': config,
    });
  }

  /// Start decryption operation
  Future<void> decryptFile(FileInfo file, EncryptionConfig config) async {
    if (_sendPort == null) {
      throw StateError('Service not initialized');
    }

    _sendPort!.send({
      'action': 'decrypt',
      'filePath': file.path,
      'config': config,
    });
  }

  /// Get system information
  int get logicalProcessorCount {
    return Platform.numberOfProcessors;
  }

  /// Dispose of the service
  void dispose() {
    _isolate?.kill();
    _receivePort?.close();
    _responseController.close();
    _isolate = null;
    _sendPort = null;
    _receivePort = null;
  }
}