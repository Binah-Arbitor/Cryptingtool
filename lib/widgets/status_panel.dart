import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/encryption_models.dart';

class StatusPanel extends StatelessWidget {
  final ProgressInfo progressInfo;

  const StatusPanel({
    super.key,
    required this.progressInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardGray,
        border: Border(
          top: BorderSide(
            color: AppTheme.tealCyan.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildProgressBar(),
          const SizedBox(height: 12),
          _buildStatusInfo(),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    final isProcessing = progressInfo.state == AppState.encrypting || 
                        progressInfo.state == AppState.decrypting;
    
    return Column(
      children: [
        Row(
          children: [
            _buildStateIndicator(),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                progressInfo.statusMessage.toUpperCase(),
                style: TextStyle(
                  color: _getStateColor(),
                  fontFamily: 'monospace',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isProcessing) ...[
              const SizedBox(width: 12),
              Text(
                '${(progressInfo.progress * 100).toStringAsFixed(1)}%',
                style: TextStyle(
                  color: AppTheme.tealCyan,
                  fontFamily: 'monospace',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        
        // Progress bar
        Container(
          height: 6,
          decoration: BoxDecoration(
            color: AppTheme.mediumGray,
            borderRadius: BorderRadius.circular(3),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: Stack(
              children: [
                // Background
                Container(
                  width: double.infinity,
                  height: 6,
                  color: AppTheme.mediumGray,
                ),
                
                // Progress
                FractionallySizedBox(
                  widthFactor: progressInfo.progress.clamp(0.0, 1.0),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 6,
                    decoration: BoxDecoration(
                      color: _getProgressColor(),
                      borderRadius: BorderRadius.circular(3),
                      boxShadow: isProcessing ? [
                        BoxShadow(
                          color: _getProgressColor().withOpacity(0.5),
                          blurRadius: 6,
                          spreadRadius: 1,
                        ),
                      ] : null,
                    ),
                  ),
                ),
                
                // Shimmer effect for active processing
                if (isProcessing && progressInfo.progress > 0)
                  _buildShimmerEffect(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerEffect() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 1000),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          gradient: LinearGradient(
            colors: [
              Colors.transparent,
              _getProgressColor().withOpacity(0.4),
              Colors.transparent,
            ],
            stops: const [0.0, 0.5, 1.0],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusInfo() {
    return Row(
      children: [
        // System status indicators
        _buildSystemStatusIndicators(),
        const Spacer(),
        
        // Operation info
        _buildOperationInfo(),
      ],
    );
  }

  Widget _buildSystemStatusIndicators() {
    return Row(
      children: [
        _buildStatusIndicator(
          icon: Icons.memory,
          label: 'CPU',
          value: _getCpuUsage(),
          color: AppTheme.infoBlue,
        ),
        const SizedBox(width: 16),
        _buildStatusIndicator(
          icon: Icons.storage,
          label: 'I/O',
          value: _getIoStatus(),
          color: AppTheme.warningOrange,
        ),
        const SizedBox(width: 16),
        _buildStatusIndicator(
          icon: Icons.speed,
          label: 'NET',
          value: 'IDLE',
          color: AppTheme.mediumGray,
        ),
      ],
    );
  }

  Widget _buildStatusIndicator({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 12,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontFamily: 'monospace',
            fontSize: 9,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Text(
            value,
            style: TextStyle(
              color: color,
              fontFamily: 'monospace',
              fontSize: 8,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOperationInfo() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getStateColor().withOpacity(0.2),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: _getStateColor().withOpacity(0.5),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getStateIcon(),
                size: 12,
                color: _getStateColor(),
              ),
              const SizedBox(width: 6),
              Text(
                _getStateDisplayName().toUpperCase(),
                style: TextStyle(
                  color: _getStateColor(),
                  fontFamily: 'monospace',
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        
        if (progressInfo.state == AppState.encrypting || 
            progressInfo.state == AppState.decrypting) ...[
          const SizedBox(width: 12),
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(_getStateColor()),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStateIndicator() {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: _getStateColor(),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: _getStateColor().withOpacity(0.5),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: _getStateColor().withOpacity(0.8),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  Color _getStateColor() {
    switch (progressInfo.state) {
      case AppState.ready:
        return AppTheme.limeGreen;
      case AppState.encrypting:
      case AppState.decrypting:
        return AppTheme.tealCyan;
      case AppState.completed:
        return AppTheme.limeGreen;
      case AppState.error:
        return AppTheme.errorRed;
    }
  }

  Color _getProgressColor() {
    switch (progressInfo.state) {
      case AppState.ready:
        return AppTheme.mediumGray;
      case AppState.encrypting:
      case AppState.decrypting:
        return AppTheme.tealCyan;
      case AppState.completed:
        return AppTheme.limeGreen;
      case AppState.error:
        return AppTheme.errorRed;
    }
  }

  IconData _getStateIcon() {
    switch (progressInfo.state) {
      case AppState.ready:
        return Icons.check_circle_outline;
      case AppState.encrypting:
        return Icons.lock_outline;
      case AppState.decrypting:
        return Icons.lock_open_outline;
      case AppState.completed:
        return Icons.check_circle;
      case AppState.error:
        return Icons.error_outline;
    }
  }

  String _getStateDisplayName() {
    switch (progressInfo.state) {
      case AppState.ready:
        return 'Ready';
      case AppState.encrypting:
        return 'Encrypting';
      case AppState.decrypting:
        return 'Decrypting';
      case AppState.completed:
        return 'Completed';
      case AppState.error:
        return 'Error';
    }
  }

  String _getCpuUsage() {
    switch (progressInfo.state) {
      case AppState.ready:
      case AppState.completed:
        return 'IDLE';
      case AppState.encrypting:
      case AppState.decrypting:
        // Simulate CPU usage based on progress
        final usage = (20 + (progressInfo.progress * 60)).toInt();
        return '${usage}%';
      case AppState.error:
        return 'ERR';
    }
  }

  String _getIoStatus() {
    switch (progressInfo.state) {
      case AppState.ready:
      case AppState.completed:
        return 'IDLE';
      case AppState.encrypting:
      case AppState.decrypting:
        // Simulate I/O activity
        return progressInfo.progress > 0 ? 'ACTIVE' : 'PREP';
      case AppState.error:
        return 'ERR';
    }
  }
}