import 'package:flutter/material.dart';
import 'dart:io';
import 'theme/app_theme.dart';
import 'models/encryption_models.dart';
import 'services/backend_service.dart';
import 'widgets/file_io_panel.dart';
import 'widgets/encryption_config_panel.dart';
import 'widgets/advanced_settings_panel.dart';
import 'widgets/log_console_panel.dart';
import 'widgets/status_panel.dart';

void main() {
  runApp(const CryptingToolApp());
}

class CryptingToolApp extends StatelessWidget {
  const CryptingToolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CryptingTool - High-Performance Encryption Utility',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final BackendService _backendService = BackendService();
  
  // Application state
  FileInfo? _selectedFile;
  EncryptionConfig _config = EncryptionConfig(
    algorithm: EncryptionAlgorithm.aes,
    keyLength: KeyLength.bits256,
    operationMode: OperationMode.cbc,
    password: '',
    threadCount: Platform.numberOfProcessors > 1 ? Platform.numberOfProcessors ~/ 2 : 1,
  );
  
  final List<LogEntry> _logs = [];
  ProgressInfo _progressInfo = const ProgressInfo(
    progress: 0.0,
    statusMessage: 'Ready',
    state: AppState.ready,
  );
  
  bool _isLogConsoleExpanded = false;

  @override
  void initState() {
    super.initState();
    _initializeBackendService();
  }

  @override
  void dispose() {
    _backendService.dispose();
    super.dispose();
  }

  Future<void> _initializeBackendService() async {
    await _backendService.initialize();
    
    // Listen to log stream
    _backendService.logStream.listen((logEntry) {
      setState(() {
        _logs.add(logEntry);
      });
    });
    
    // Listen to progress stream
    _backendService.progressStream.listen((progressInfo) {
      setState(() {
        _progressInfo = progressInfo;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // File I/O Panel
                  FileIOPanel(
                    selectedFile: _selectedFile,
                    currentState: _progressInfo.state,
                    onFileSelected: _onFileSelected,
                    onEncrypt: _canStartOperation() ? _startEncryption : null,
                    onDecrypt: _canStartOperation() ? _startDecryption : null,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Encryption Configuration Panel
                  EncryptionConfigPanel(
                    config: _config,
                    onConfigChanged: _onConfigChanged,
                    isEnabled: _progressInfo.state == AppState.ready,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Advanced Settings Panel
                  AdvancedSettingsPanel(
                    config: _config,
                    onConfigChanged: _onConfigChanged,
                    isEnabled: _progressInfo.state == AppState.ready,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Log Console Panel
                  LogConsolePanel(
                    logs: _logs,
                    onClearLogs: _clearLogs,
                    isExpanded: _isLogConsoleExpanded,
                    onExpansionChanged: (expanded) {
                      setState(() {
                        _isLogConsoleExpanded = expanded;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          
          // Status Panel (always at bottom)
          StatusPanel(progressInfo: _progressInfo),
        ],
      ),
      floatingActionButton: _buildFloatingActionButtons(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.tealCyan.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.tealCyan.withOpacity(0.5),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.security,
              color: AppTheme.tealCyan,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CRYPTINGTOOL',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppTheme.lightGray,
                  fontSize: 18,
                  letterSpacing: 1.5,
                ),
              ),
              Text(
                'High-Performance File Encryption Utility',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.tealCyan,
                  fontSize: 10,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        // System info
        Container(
          margin: const EdgeInsets.only(right: 16),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppTheme.cardGray,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: AppTheme.infoBlue.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.memory,
                size: 16,
                color: AppTheme.infoBlue,
              ),
              const SizedBox(width: 6),
              Text(
                '${Platform.numberOfProcessors} Cores',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.infoBlue,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
      elevation: 0,
    );
  }

  Widget? _buildFloatingActionButtons() {
    if (_progressInfo.state != AppState.encrypting && 
        _progressInfo.state != AppState.decrypting) {
      return null;
    }

    return FloatingActionButton(
      onPressed: _stopOperation,
      backgroundColor: AppTheme.errorRed,
      foregroundColor: AppTheme.white,
      tooltip: 'Stop Operation',
      child: const Icon(Icons.stop),
    );
  }

  void _onFileSelected(FileInfo fileInfo) {
    setState(() {
      _selectedFile = fileInfo;
    });
  }

  void _onConfigChanged(EncryptionConfig newConfig) {
    setState(() {
      _config = newConfig;
    });
  }

  bool _canStartOperation() {
    return _selectedFile != null &&
           _config.password.isNotEmpty &&
           _progressInfo.state == AppState.ready;
  }

  Future<void> _startEncryption() async {
    if (!_canStartOperation()) return;
    
    try {
      final outputPath = '${_selectedFile!.path}.encrypted';
      await _backendService.startEncryption(
        fileInfo: _selectedFile!,
        config: _config,
        outputPath: outputPath,
      );
    } catch (e) {
      _showErrorDialog('Encryption Failed', e.toString());
    }
  }

  Future<void> _startDecryption() async {
    if (!_canStartOperation()) return;
    
    try {
      String outputPath = _selectedFile!.path;
      if (outputPath.endsWith('.encrypted')) {
        outputPath = outputPath.substring(0, outputPath.length - 10); // Remove .encrypted extension
      } else {
        outputPath = '$outputPath.decrypted';
      }
      
      await _backendService.startDecryption(
        fileInfo: _selectedFile!,
        config: _config,
        outputPath: outputPath,
      );
    } catch (e) {
      _showErrorDialog('Decryption Failed', e.toString());
    }
  }

  Future<void> _stopOperation() async {
    await _backendService.stopOperation();
  }

  void _clearLogs() {
    setState(() {
      _logs.clear();
    });
    _backendService.clearLogs();
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardGray,
        title: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: AppTheme.errorRed,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: AppTheme.errorRed,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: TextStyle(
            color: AppTheme.lightGray,
            fontFamily: 'monospace',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'OK',
              style: TextStyle(
                color: AppTheme.tealCyan,
                fontFamily: 'monospace',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: AppTheme.errorRed.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
    );
  }
}