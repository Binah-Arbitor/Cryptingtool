import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_glow/flutter_glow.dart';

import '../services/app_state.dart';
import '../theme.dart';

class ActionButtonsPanel extends ConsumerWidget {
  const ActionButtonsPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canPerformOperation = ref.watch(canPerformOperationProvider);
    final operations = ref.read(operationsProvider);
    final operationStatus = ref.watch(operationStatusProvider);
    final isProcessing = operationStatus.contains('Encrypting') || 
                        operationStatus.contains('Decrypting');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Operations',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    context: context,
                    label: 'ENCRYPT',
                    icon: Icons.lock,
                    enabled: canPerformOperation && !isProcessing,
                    onPressed: () => operations.encryptFile(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildActionButton(
                    context: context,
                    label: 'DECRYPT',
                    icon: Icons.lock_open,
                    enabled: canPerformOperation && !isProcessing,
                    onPressed: () => operations.decryptFile(),
                  ),
                ),
              ],
            ),
            
            if (!canPerformOperation)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.warningColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: AppTheme.warningColor.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppTheme.warningColor,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Select a file and enter password to enable operations',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.warningColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required bool enabled,
    required VoidCallback onPressed,
  }) {
    final button = ElevatedButton.icon(
      onPressed: enabled ? onPressed : null,
      icon: Icon(icon, size: 20),
      label: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: enabled ? AppTheme.primaryAccent : AppTheme.darkGrey,
        foregroundColor: enabled ? AppTheme.deepOffBlack : AppTheme.lightGrey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );

    if (enabled) {
      return GlowButton(
        color: AppTheme.primaryAccent,
        blurRadius: 8,
        spreadRadius: 2,
        child: button,
      );
    } else {
      return button;
    }
  }
}