import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import '../widgets/file_io_panel.dart';
import '../widgets/encryption_config_panel.dart';
import '../widgets/advanced_settings_panel.dart';
import '../widgets/log_console_panel.dart';
import '../widgets/status_bar.dart';
import '../theme/app_theme.dart';

class CryptingToolScreen extends StatefulWidget {
  const CryptingToolScreen({super.key});

  @override
  State<CryptingToolScreen> createState() => _CryptingToolScreenState();
}

class _CryptingToolScreenState extends State<CryptingToolScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _backgroundAnimationController;

  @override
  void initState() {
    super.initState();
    _backgroundAnimationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    // Initialize the system
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppStateProvider>().initializeSystem();
    });
  }

  @override
  void dispose() {
    _backgroundAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // App icon with circuit pattern
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppTheme.tealAccent.withOpacity(0.2),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: AppTheme.tealAccent,
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.security,
                color: AppTheme.tealAccent,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'CRYPTINGTOOL',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  'High-Performance Encryption Suite',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.cyanAccent,
                    fontSize: 10,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // System status indicator
          Consumer<AppStateProvider>(
            builder: (context, provider, child) {
              return Container(
                margin: const EdgeInsets.only(right: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: provider.isProcessing 
                            ? AppTheme.cyanAccent 
                            : AppTheme.limeGreen,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: provider.isProcessing 
                                ? AppTheme.cyanAccent 
                                : AppTheme.limeGreen,
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      provider.isProcessing ? 'PROCESSING' : 'READY',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: provider.isProcessing 
                            ? AppTheme.cyanAccent 
                            : AppTheme.limeGreen,
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Animated background circuit pattern
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _backgroundAnimationController,
              builder: (context, child) {
                return CustomPaint(
                  painter: BackgroundCircuitPainter(
                    animationValue: _backgroundAnimationController.value,
                  ),
                );
              },
            ),
          ),
          
          // Main content
          SafeArea(
            child: Column(
              children: [
                // Main content panels
                Expanded(
                  child: Consumer<AppStateProvider>(
                    builder: (context, provider, child) {
                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            // File I/O Panel
                            FileIOPanel(
                              selectedFile: provider.selectedFile,
                              isProcessing: provider.isProcessing,
                              onFileSelected: provider.selectFile,
                              onEncrypt: provider.encryptFile,
                              onDecrypt: provider.decryptFile,
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Configuration panels row
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Encryption Configuration Panel
                                Expanded(
                                  flex: 2,
                                  child: EncryptionConfigPanel(
                                    config: provider.config,
                                    onConfigChanged: provider.updateConfig,
                                    isLocked: provider.isProcessing,
                                  ),
                                ),
                                
                                const SizedBox(width: 16),
                                
                                // Advanced Settings Panel
                                Expanded(
                                  flex: 1,
                                  child: AdvancedSettingsPanel(
                                    config: provider.config,
                                    onConfigChanged: provider.updateConfig,
                                    isLocked: provider.isProcessing,
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Log Console Panel
                            LogConsolePanel(
                              logEntries: provider.logEntries,
                              onClearLogs: provider.clearLogs,
                            ),
                            
                            const SizedBox(height: 80), // Space for status bar
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      
      // Bottom status bar
      bottomNavigationBar: Consumer<AppStateProvider>(
        builder: (context, provider, child) {
          return StatusBar(
            progress: provider.progress,
            statusMessage: provider.statusMessage,
          );
        },
      ),
      
      // Floating action button for emergency stop
      floatingActionButton: Consumer<AppStateProvider>(
        builder: (context, provider, child) {
          if (!provider.isProcessing) return Container();
          
          return FloatingActionButton(
            onPressed: provider.cancelOperation,
            backgroundColor: AppTheme.errorRed,
            foregroundColor: AppTheme.lightGray,
            child: const Icon(Icons.stop),
            tooltip: 'Cancel Operation',
          );
        },
      ),
    );
  }
}

class BackgroundCircuitPainter extends CustomPainter {
  final double animationValue;

  BackgroundCircuitPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.tealAccent.withOpacity(0.02)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    final animatedPaint = Paint()
      ..color = AppTheme.tealAccent.withOpacity(0.05)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final spacing = 100.0;
    final offset = animationValue * spacing;

    // Draw grid pattern
    for (double x = -offset; x < size.width + spacing; x += spacing) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    for (double y = -offset; y < size.height + spacing; y += spacing) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }

    // Draw animated circuit paths
    final pathCount = 8;
    for (int i = 0; i < pathCount; i++) {
      final startX = (size.width / pathCount) * i;
      final animatedY = (animationValue * size.height * 2) % size.height;
      
      final path = Path();
      path.moveTo(startX, animatedY);
      path.lineTo(startX + 50, animatedY);
      path.lineTo(startX + 50, animatedY + 30);
      path.lineTo(startX + 100, animatedY + 30);
      
      canvas.drawPath(path, animatedPaint);
      
      // Draw connection nodes
      canvas.drawCircle(
        Offset(startX + 50, animatedY + 15),
        2,
        animatedPaint..style = PaintingStyle.fill,
      );
      animatedPaint.style = PaintingStyle.stroke;
    }
  }

  @override
  bool shouldRepaint(BackgroundCircuitPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}