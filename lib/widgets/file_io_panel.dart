import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../theme/app_theme.dart';
import '../models/encryption_models.dart';

class FileIOPanel extends StatefulWidget {
  final FileInfo? selectedFile;
  final AppState currentState;
  final VoidCallback? onEncrypt;
  final VoidCallback? onDecrypt;
  final Function(FileInfo) onFileSelected;

  const FileIOPanel({
    super.key,
    required this.selectedFile,
    required this.currentState,
    required this.onEncrypt,
    required this.onDecrypt,
    required this.onFileSelected,
  });

  @override
  State<FileIOPanel> createState() => _FileIOPanelState();
}

class _FileIOPanelState extends State<FileIOPanel> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppTheme.pcbDecoration,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Title with circuit pattern
            Row(
              children: [
                Icon(
                  Icons.folder_open_outlined,
                  color: AppTheme.tealCyan,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  'FILE SELECTION',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppTheme.tealCyan,
                    letterSpacing: 1.2,
                  ),
                ),
                const Spacer(),
                Container(
                  width: 40,
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.tealCyan.withOpacity(0.8),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // File selection area
            _buildFileSelectionArea(),
            
            const SizedBox(height: 24),
            
            // Selected file info
            if (widget.selectedFile != null) _buildFileInfo(),
            
            const SizedBox(height: 24),
            
            // Action buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildFileSelectionArea() {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: _selectFile,
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            border: Border.all(
              color: _isHovering ? AppTheme.tealCyan : AppTheme.tealCyan.withOpacity(0.5),
              width: 2,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(12),
            color: AppTheme.mediumGray.withOpacity(0.3),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: _isHovering ? AppTheme.glowDecoration : null,
                  child: Icon(
                    widget.selectedFile == null 
                        ? Icons.cloud_upload_outlined 
                        : Icons.description_outlined,
                    size: 48,
                    color: _isHovering ? AppTheme.tealCyan : AppTheme.lightGray,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.selectedFile == null 
                      ? 'CLICK TO SELECT FILE'
                      : 'CLICK TO CHANGE FILE',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: _isHovering ? AppTheme.tealCyan : AppTheme.lightGray,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Supported: All file types',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightGray.withOpacity(0.7),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFileInfo() {
    final file = widget.selectedFile!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardGray,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.limeGreen.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.check_circle_outline,
                color: AppTheme.limeGreen,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'SELECTED FILE',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppTheme.limeGreen,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.description,
                color: AppTheme.lightGray,
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  file.name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.data_usage,
                color: AppTheme.lightGray,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                file.formattedSize,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.tealCyan.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'READY',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.tealCyan,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    final isReady = widget.selectedFile != null && 
                   widget.currentState == AppState.ready;
    final isProcessing = widget.currentState == AppState.encrypting || 
                        widget.currentState == AppState.decrypting;

    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            label: 'ENCRYPT',
            icon: Icons.lock_outlined,
            color: AppTheme.tealCyan,
            isEnabled: isReady,
            isActive: widget.currentState == AppState.encrypting,
            onPressed: isReady ? widget.onEncrypt : null,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildActionButton(
            label: 'DECRYPT',
            icon: Icons.lock_open_outlined,
            color: AppTheme.limeGreen,
            isEnabled: isReady,
            isActive: widget.currentState == AppState.decrypting,
            onPressed: isReady ? widget.onDecrypt : null,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required bool isEnabled,
    required bool isActive,
    VoidCallback? onPressed,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: isActive 
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.4),
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
              ],
            )
          : null,
      child: SizedBox(
        height: 56,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: isEnabled ? color : AppTheme.mediumGray,
            foregroundColor: isEnabled ? AppTheme.deepOffBlack : AppTheme.lightGray.withOpacity(0.5),
            elevation: isActive ? 8 : 4,
            shadowColor: isActive ? color.withOpacity(0.3) : Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: isEnabled ? color : AppTheme.mediumGray,
                width: isActive ? 2 : 1,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isActive)
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.deepOffBlack),
                  ),
                )
              else
                Icon(icon, size: 20),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final file = result.files.single;
        final fileInfo = FileInfo(
          name: file.name,
          path: file.path!,
          sizeBytes: file.size,
        );
        widget.onFileSelected(fileInfo);
      }
    } catch (e) {
      // Handle file selection error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to select file: ${e.toString()}'),
          backgroundColor: AppTheme.errorRed,
        ),
      );
    }
  }
}