import 'package:flutter/material.dart';
import '../models/app_state.dart';
import '../theme/app_theme.dart';

class StatusBar extends StatefulWidget {
  final ProcessingProgress progress;
  final String statusMessage;

  const StatusBar({
    super.key,
    required this.progress,
    this.statusMessage = '',
  });

  @override
  State<StatusBar> createState() => _StatusBarState();
}

class _StatusBarState extends State<StatusBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _startAnimation();
  }

  @override
  void didUpdateWidget(StatusBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.progress.status != oldWidget.progress.status) {
      _startAnimation();
    }
  }

  void _startAnimation() {
    if (widget.progress.status == ProcessingStatus.processing) {
      _animationController.repeat(reverse: true);
    } else {
      _animationController.stop();
      _animationController.reset();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getStatusColor() {
    switch (widget.progress.status) {
      case ProcessingStatus.ready:
        return AppTheme.tealAccent;
      case ProcessingStatus.processing:
        return AppTheme.cyanAccent;
      case ProcessingStatus.success:
        return AppTheme.limeGreen;
      case ProcessingStatus.error:
        return AppTheme.errorRed;
      case ProcessingStatus.paused:
        return AppTheme.warningAmber;
      case ProcessingStatus.cancelled:
        return AppTheme.mediumGray;
    }
  }

  IconData _getStatusIcon() {
    switch (widget.progress.status) {
      case ProcessingStatus.ready:
        return Icons.check_circle_outline;
      case ProcessingStatus.processing:
        return Icons.autorenew;
      case ProcessingStatus.success:
        return Icons.check_circle;
      case ProcessingStatus.error:
        return Icons.error_outline;
      case ProcessingStatus.paused:
        return Icons.pause_circle_outline;
      case ProcessingStatus.cancelled:
        return Icons.cancel_outlined;
    }
  }

  String _getDisplayMessage() {
    if (widget.statusMessage.isNotEmpty) {
      return widget.statusMessage;
    }
    
    switch (widget.progress.status) {
      case ProcessingStatus.ready:
        return 'System ready for operations';
      case ProcessingStatus.processing:
        if (widget.progress.currentOperation != null) {
          return widget.progress.currentOperation!;
        }
        return 'Processing... ${widget.progress.formattedProgress}';
      case ProcessingStatus.success:
        return 'Operation completed successfully';
      case ProcessingStatus.error:
        return 'Operation failed - check logs for details';
      case ProcessingStatus.paused:
        return 'Operation paused by user';
      case ProcessingStatus.cancelled:
        return 'Operation cancelled by user';
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();
    final isProcessing = widget.progress.status == ProcessingStatus.processing;
    
    return Container(
      height: 80,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // Info: Replaced deprecated 'withOpacity'
        color: AppTheme.darkGray.withAlpha((255 * 0.8).round()),
        border: const Border(
          top: BorderSide(
            color: AppTheme.mediumGray,
            width: 0.5,
          ),
        ),
      ),
      child: Column(
        children: [
          // Progress bar
          Container(
            height: 4,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppTheme.deepOffBlack,
              borderRadius: BorderRadius.circular(2),
            ),
            child: FractionallySizedBox(
              widthFactor: isProcessing ? widget.progress.byteProgress : 1.0,
              alignment: Alignment.centerLeft,
              child: AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Container(
                    decoration: BoxDecoration(
                      // Info: Replaced deprecated 'withOpacity'
                      color: statusColor.withAlpha((255 * _pulseAnimation.value).round()),
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: isProcessing ? [
                        BoxShadow(
                          // Info: Replaced deprecated 'withOpacity'
                          color: statusColor.withAlpha((255 * 0.5).round()),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ] : null,
                    ),
                  );
                },
              ),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Status information row
          Row(
            children: [
              // Status icon with animation
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: isProcessing ? _animationController.value * 2 * 3.14159 : 0,
                    child: Icon(
                      _getStatusIcon(),
                      color: statusColor,
                      size: 20,
                    ),
                  );
                },
              ),
              const SizedBox(width: 12),
              
              // Status text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.progress.status.displayName.toUpperCase(),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _getDisplayMessage(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightGray,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              
              // Processing statistics (when active)
              if (isProcessing && widget.progress.totalBytes > 0) ...[
                const SizedBox(width: 16),
                _buildStatisticColumn(
                  'PROGRESS',
                  widget.progress.formattedProgress,
                  AppTheme.cyanAccent,
                ),
                const SizedBox(width: 16),
                _buildStatisticColumn(
                  'ETA',
                  widget.progress.estimatedTimeRemaining,
                  AppTheme.tealAccent,
                ),
                const SizedBox(width: 16),
                _buildStatisticColumn(
                  'SPEED',
                  _getProcessingSpeed(),
                  AppTheme.limeGreen,
                ),
              ],
              
              // System time
              const SizedBox(width: 16),
              _buildStatisticColumn(
                'TIME',
                _getCurrentTime(),
                AppTheme.mediumGray,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticColumn(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            // Info: Replaced deprecated 'withOpacity'
            color: color.withAlpha((255 * 0.7).round()),
            fontSize: 9,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  String _getProcessingSpeed() {
    if (widget.progress.elapsed.inSeconds == 0 || widget.progress.bytesProcessed == 0) {
      return '-- MB/s';
    }
    
    final bytesPerSecond = widget.progress.bytesProcessed / widget.progress.elapsed.inSeconds;
    final mbPerSecond = bytesPerSecond / (1024 * 1024);
    
    if (mbPerSecond >= 1) {
      return '${mbPerSecond.toStringAsFixed(1)} MB/s';
    } else {
      final kbPerSecond = bytesPerSecond / 1024;
      return '${kbPerSecond.toStringAsFixed(1)} KB/s';
    }
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:'
           '${now.minute.toString().padLeft(2, '0')}:'
           '${now.second.toString().padLeft(2, '0')}';
  }
}