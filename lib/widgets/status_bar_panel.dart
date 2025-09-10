import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/app_state.dart';
import '../theme.dart';

class StatusBarPanel extends ConsumerWidget {
  const StatusBarPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final operationStatus = ref.watch(operationStatusProvider);
    final operationProgress = ref.watch(operationProgressProvider);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        border: Border(
          top: BorderSide(
            color: AppTheme.primaryAccent.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Progress Bar
          Container(
            width: double.infinity,
            height: 8,
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: AppTheme.primaryAccent.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Stack(
                children: [
                  LinearProgressIndicator(
                    value: operationProgress,
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getProgressColor(operationStatus),
                    ),
                  ),
                  // Animated glow effect when processing
                  if (operationProgress > 0 && operationProgress < 1)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: _getProgressColor(operationStatus).withOpacity(0.3),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Status Text with Icon
          Row(
            children: [
              _getStatusIcon(operationStatus),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  operationStatus,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: _getStatusColor(operationStatus),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (operationProgress > 0 && operationProgress < 1)
                Text(
                  '${(operationProgress * 100).toStringAsFixed(1)}%',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.primaryAccent,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'FiraCode',
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getProgressColor(String status) {
    if (status.toLowerCase().contains('error')) {
      return AppTheme.errorColor;
    } else if (status.toLowerCase().contains('success')) {
      return AppTheme.successColor;
    } else if (status.toLowerCase().contains('encrypting') || 
               status.toLowerCase().contains('decrypting')) {
      return AppTheme.primaryAccent;
    } else {
      return AppTheme.lightGrey;
    }
  }

  Color _getStatusColor(String status) {
    if (status.toLowerCase().contains('error')) {
      return AppTheme.errorColor;
    } else if (status.toLowerCase().contains('success')) {
      return AppTheme.successColor;
    } else if (status.toLowerCase().contains('encrypting') || 
               status.toLowerCase().contains('decrypting')) {
      return AppTheme.primaryAccent;
    } else if (status.toLowerCase().contains('ready')) {
      return AppTheme.offWhite;
    } else {
      return AppTheme.lightGrey;
    }
  }

  Widget _getStatusIcon(String status) {
    IconData icon;
    Color color = _getStatusColor(status);

    if (status.toLowerCase().contains('error')) {
      icon = Icons.error_outline;
    } else if (status.toLowerCase().contains('success')) {
      icon = Icons.check_circle_outline;
    } else if (status.toLowerCase().contains('encrypting')) {
      icon = Icons.lock_outline;
    } else if (status.toLowerCase().contains('decrypting')) {
      icon = Icons.lock_open_outlined;
    } else if (status.toLowerCase().contains('ready')) {
      icon = Icons.radio_button_unchecked;
    } else {
      icon = Icons.info_outline;
    }

    Widget iconWidget = Icon(
      icon,
      color: color,
      size: 20,
    );

    // Add rotation animation for processing states
    if (status.toLowerCase().contains('encrypting') || 
        status.toLowerCase().contains('decrypting')) {
      return TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(seconds: 2),
        builder: (context, value, child) {
          return Transform.rotate(
            angle: value * 6.28, // 2π for full rotation
            child: iconWidget,
          );
        },
      );
    }

    return iconWidget;
  }
}