import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../providers/app_state_provider.dart';
import '../widgets/file_io_panel.dart';
import '../widgets/encryption_config_panel.dart';
import '../widgets/advanced_settings_panel.dart';
import '../widgets/log_console_panel.dart';
import '../widgets/status_bar.dart';
import '../widgets/cpu_chip_icon.dart';
import '../theme/app_theme.dart';

class CryptingToolScreen extends StatefulWidget {
  const CryptingToolScreen({super.key});

  @override
  State<CryptingToolScreen> createState() => _CryptingToolScreenState();
}

class _CryptingToolScreenState extends State<CryptingToolScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize the system after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppStateProvider>().initializeSystem();
    });
  }

  // --- UI Event Handlers ---
  
  void _encrypt() {
    context.read<AppStateProvider>().encryptFile();
  }

  void _decrypt() {
    context.read<AppStateProvider>().decryptFile();
  }
  
  // Corrected: This now accepts the FileInfo object from the panel
  void _selectFile(FileInfo file) {
    context.read<AppStateProvider>().selectFile(file);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          // Background animation is now isolated
          const BackgroundAnimation(),
          
          // Main content area
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // --- File I/O Panel ---
                  Consumer<AppStateProvider>(
                    builder: (context, provider, _) {
                      return FileIOPanel(
                        selectedFile: provider.selectedFile,
                        isProcessing: provider.isProcessing,
                        // Corrected: The callback now correctly passes the FileInfo object
                        onFileSelected: (file) => _selectFile(file),
                        onEncrypt: _encrypt,
                        onDecrypt: _decrypt,
                      );
                    }
                  ),
                  const SizedBox(height: 16),
                  
                  // --- Configuration Panels Row ---
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Encryption Configuration
                      Expanded(
                        flex: 2,
                        child: Consumer<AppStateProvider>(
                           builder: (context, provider, _) {
                            return EncryptionConfigPanel(
                              config: provider.config,
                              onConfigChanged: provider.updateConfig,
                              isLocked: provider.isProcessing,
                            );
                          }
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Advanced Settings
                      Expanded(
                        flex: 1,
                        child: Consumer<AppStateProvider>(
                           builder: (context, provider, _) {
                            return AdvancedSettingsPanel(
                              config: provider.config,
                              onConfigChanged: provider.updateConfig,
                              isLocked: provider.isProcessing,
                            );
                          }
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // --- Log Console Panel ---
                  Consumer<AppStateProvider>(
                    builder: (context, provider, _) {
                      return LogConsolePanel(
                        logEntries: provider.logEntries,
                        onClearLogs: provider.clearLogs,
                      );
                    }
                  ),
                  const SizedBox(height: 80), // Space for status bar
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomStatusBar(),
      floatingActionButton: _buildStopFAB(),
    );
  }

  /// Builds the main application app bar
  AppBar _buildAppBar() {
    return AppBar(
      title: Row(
        children: [
          // App icon with CPU chip design
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              // Info: Replaced deprecated 'withOpacity'
              color: AppTheme.tealAccent.withAlpha(51), // 0.2 opacity
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppTheme.tealAccent, width: 1),
            ),
            child: const CpuChipIcon(size: 20, showGlow: true),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('CRYPTINGTOOL', style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 1.2)),
              Text('High-Performance Encryption Suite', style: TextStyle(color: AppTheme.cyanAccent, fontSize: 10, letterSpacing: 0.5)),
            ],
          ),
        ],
      ),
      actions: [
        // System status indicator, rebuilt via Consumer
        Consumer<AppStateProvider>(
          builder: (context, provider, _) {
            final bool isProcessing = provider.isProcessing;
            final Color statusColor = isProcessing ? AppTheme.cyanAccent : AppTheme.limeGreen;
            
            return Container(
              margin: const EdgeInsets.only(right: 16),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: statusColor, blurRadius: 4, spreadRadius: 1)],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isProcessing ? 'PROCESSING' : 'READY',
                    style: TextStyle(color: statusColor, fontWeight: FontWeight.w600, fontSize: 10),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  /// Builds the bottom status bar, rebuilt via Consumer
  Widget _buildBottomStatusBar() {
    return Consumer<AppStateProvider>(
      builder: (context, provider, _) {
        return StatusBar(
          progress: provider.progress,
          statusMessage: provider.statusMessage,
        );
      },
    );
  }

  /// Builds the floating action button to stop operations, rebuilt via Consumer
  Widget _buildStopFAB() {
    return Consumer<AppStateProvider>(
      builder: (context, provider, _) {
        if (!provider.isProcessing) return const SizedBox.shrink();
        
        return FloatingActionButton(
          onPressed: provider.cancelOperation,
          backgroundColor: AppTheme.errorRed,
          foregroundColor: AppTheme.lightGray,
          tooltip: 'Cancel Operation',
          child: const Icon(Icons.stop),
        );
      },
    );
  }
}

// --- Isolated Background Animation Widget ---

class BackgroundAnimation extends StatefulWidget {
  const BackgroundAnimation({super.key});

  @override
  State<BackgroundAnimation> createState() => _BackgroundAnimationState();
}

class _BackgroundAnimationState extends State<BackgroundAnimation> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: BackgroundCircuitPainter(animationValue: _controller.value),
          );
        },
      ),
    );
  }
}


// --- Custom Painter for the Background ---

class BackgroundCircuitPainter extends CustomPainter {
  final double animationValue;

  BackgroundCircuitPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      // Info: Replaced deprecated 'withOpacity'
      ..color = AppTheme.tealAccent.withAlpha(5) // 0.02 opacity
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    final animatedPaint = Paint()
      // Info: Replaced deprecated 'withOpacity'
      ..color = AppTheme.tealAccent.withAlpha(13) // 0.05 opacity
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const spacing = 100.0;
    final offset = animationValue * spacing;

    // Draw grid pattern
    for (double x = -offset; x < size.width + spacing; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = -offset; y < size.height + spacing; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Draw animated circuit paths for a more dynamic feel
    final pathCount = (size.width / 150).ceil();
    for (int i = 0; i < pathCount; i++) {
      final startX = (size.width / pathCount) * i;
      final animatedY = (animationValue * size.height * 1.5 + i * 73) % size.height;
      
      final path = Path();
      path.moveTo(startX, animatedY - 50);
      path.cubicTo(
        startX + 40, animatedY - 30,
        startX - 30, animatedY + 20,
        startX + 10, animatedY + 50
      );
      canvas.drawPath(path, animatedPaint);
    }
  }

  @override
  bool shouldRepaint(BackgroundCircuitPainter oldDelegate) => oldDelegate.animationValue != animationValue;
}
