import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../models/app_state.dart';
import '../theme/app_theme.dart';

class FileIOPanel extends StatefulWidget {
  final FileInfo? selectedFile;
  final VoidCallback? onEncrypt;
  final VoidCallback? onDecrypt;
  final Function(FileInfo) onFileSelected;
  final bool isProcessing;

  const FileIOPanel({
    super.key,
    this.selectedFile,
    this.onEncrypt,
    this.onDecrypt,
    required this.onFileSelected,
    this.isProcessing = false,
  });

  @override
  State<FileIOPanel> createState() => _FileIOPanelState();
}

class _FileIOPanelState extends State<FileIOPanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _glowAnimation;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _glowAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _selectFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final file = FileInfo(
          path: result.files.single.path!,
          name: result.files.single.name,
          size: result.files.single.size,
          extension: result.files.single.extension ?? '',
          lastModified: DateTime.now(),
        );
        widget.onFileSelected(file);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error selecting file: $e'),
            backgroundColor: AppTheme.errorRed,
          ),
        );
      }
    }
  }

  Widget _buildCircuitPattern() {
    return CustomPaint(
      size: const Size.square(200),
      painter: CircuitPatternPainter(
        // Info: Replaced deprecated 'withOpacity'
        color: AppTheme.tealAccent.withAlpha((255 * 0.3).round()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.folder_open,
                  color: AppTheme.tealAccent,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'FILE I/O CONTROL',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // File Selection Area
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                // Info: Replaced deprecated 'withOpacity'
                color: _isDragging 
                    ? AppTheme.tealAccent.withAlpha((255 * 0.1).round())
                    : AppTheme.deepOffBlack,
                border: Border.all(
                  // Info: Replaced deprecated 'withOpacity'
                  color: _isDragging 
                      ? AppTheme.tealAccent
                      : AppTheme.mediumGray.withAlpha((255 * 0.5).round()),
                  width: 2,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  // Background circuit pattern
                  Positioned.fill(
                    child: _buildCircuitPattern(),
                  ),
                  
                  // Main content
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: widget.isProcessing ? null : _selectFile,
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: widget.selectedFile == null
                            ? _buildFileSelectionPrompt()
                            : _buildFileInfo(widget.selectedFile!),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: AnimatedBuilder(
                    animation: _glowAnimation,
                    builder: (context, child) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: widget.selectedFile != null && !widget.isProcessing
                              ? [
                                  BoxShadow(
                                    // Info: Replaced deprecated 'withOpacity'
                                    color: AppTheme.tealAccent.withAlpha((255 * _glowAnimation.value * 0.5).round()),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  ),
                                ]
                              : null,
                        ),
                        child: ElevatedButton.icon(
                          onPressed: widget.selectedFile != null && !widget.isProcessing
                              ? widget.onEncrypt
                              : null,
                          icon: widget.isProcessing
                              ? SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppTheme.deepOffBlack,
                                    ),
                                  ),
                                )
                              : const Icon(Icons.lock),
                          label: const Text('ENCRYPT'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: widget.selectedFile != null && !widget.isProcessing
                                ? AppTheme.tealAccent
                                : AppTheme.darkGray,
                            foregroundColor: widget.selectedFile != null && !widget.isProcessing
                                ? AppTheme.deepOffBlack
                                : AppTheme.mediumGray,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AnimatedBuilder(
                    animation: _glowAnimation,
                    builder: (context, child) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: widget.selectedFile != null && !widget.isProcessing
                              ? [
                                  BoxShadow(
                                    // Info: Replaced deprecated 'withOpacity'
                                    color: AppTheme.cyanAccent.withAlpha((255 * _glowAnimation.value * 0.5).round()),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  ),
                                ]
                              : null,
                        ),
                        child: ElevatedButton.icon(
                          onPressed: widget.selectedFile != null && !widget.isProcessing
                              ? widget.onDecrypt
                              : null,
                          icon: widget.isProcessing
                              ? SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppTheme.deepOffBlack,
                                    ),
                                  ),
                                )
                              : const Icon(Icons.lock_open),
                          label: const Text('DECRYPT'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: widget.selectedFile != null && !widget.isProcessing
                                ? AppTheme.cyanAccent
                                : AppTheme.darkGray,
                            foregroundColor: widget.selectedFile != null && !widget.isProcessing
                                ? AppTheme.deepOffBlack
                                : AppTheme.mediumGray,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileSelectionPrompt() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.file_upload_outlined,
          size: 48,
          color: AppTheme.tealAccent.withAlpha((255 * 0.7).round()),
        ),
        const SizedBox(height: 16),
        Text(
          'SELECT FILE TO PROCESS',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppTheme.tealAccent.withAlpha((255 * 0.8).round()),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Click here or drag & drop a file\nto begin encryption/decryption',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.mediumGray,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFileInfo(FileInfo file) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // File icon and name
          Row(
            children: [
              Icon(
                _getFileIcon(file.extension),
                size: 32,
                color: AppTheme.tealAccent,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      file.name,
                      style: Theme.of(context).textTheme.headlineSmall,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Text(
                      file.extension.toUpperCase(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.cyanAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const Spacer(),
          
          // File details
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.darkGray.withAlpha((255 * 0.5).round()),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.tealAccent.withAlpha((255 * 0.3).round()),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('Size:', file.formattedSize),
                const SizedBox(height: 4),
                _buildInfoRow('Modified:', file.formattedLastModified),
                const SizedBox(height: 4),
                _buildInfoRow('Path:', file.path, isPath: true),
              ],
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Change file button
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: widget.isProcessing ? null : _selectFile,
              icon: const Icon(Icons.change_circle_outlined, size: 16),
              label: const Text('CHANGE FILE'),
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.cyanAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isPath = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 60,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.mediumGray,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.lightGray,
            ),
            overflow: isPath ? TextOverflow.ellipsis : TextOverflow.visible,
            maxLines: isPath ? 1 : null,
          ),
        ),
      ],
    );
  }

  IconData _getFileIcon(String extension) {
    switch (extension.toLowerCase()) {
      case 'txt':
      case 'md':
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
      case 'bmp':
        return Icons.image;
      case 'mp4':
      case 'avi':
      case 'mov':
      case 'wmv':
        return Icons.video_file;
      case 'mp3':
      case 'wav':
      case 'flac':
      case 'ogg':
        return Icons.audio_file;
      case 'zip':
      case 'rar':
      case '7z':
      case 'tar':
        return Icons.archive;
      case 'exe':
      case 'msi':
      case 'app':
        return Icons.apps;
      default:
        return Icons.insert_drive_file;
    }
  }
}

class CircuitPatternPainter extends CustomPainter {
  final Color color;

  CircuitPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Draw circuit-like pattern
    // Horizontal lines
    for (int i = 1; i < 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(20, y), Offset(size.width - 20, y), paint);
    }

    // Vertical lines
    for (int i = 1; i < 4; i++) {
      final x = size.width * i / 4;
      canvas.drawLine(Offset(x, 20), Offset(x, size.height - 20), paint);
    }

    // Corner connections
    final cornerSize = 8.0;
    final corners = [
      Offset(cornerSize, cornerSize),
      Offset(size.width - cornerSize, cornerSize),
      Offset(cornerSize, size.height - cornerSize),
      Offset(size.width - cornerSize, size.height - cornerSize),
    ];

    for (final corner in corners) {
      canvas.drawCircle(corner, 3, paint..style = PaintingStyle.fill);
    }

    paint.style = PaintingStyle.stroke;

    // Center circuit node
    canvas.drawCircle(Offset(centerX, centerY), 6, paint);
    canvas.drawCircle(Offset(centerX, centerY), 10, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}