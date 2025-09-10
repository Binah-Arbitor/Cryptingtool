import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/app_state.dart';
import '../theme.dart';

class AdvancedSettingsPanel extends ConsumerWidget {
  const AdvancedSettingsPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final threadCount = ref.watch(threadCountProvider);
    final maxThreadCount = ref.watch(maxThreadCountProvider);

    return Card(
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Row(
            children: [
              Icon(
                Icons.settings,
                color: AppTheme.primaryAccent,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Advanced Settings',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          backgroundColor: const Color(0xFF1A1A1A),
          collapsedBackgroundColor: const Color(0xFF1A1A1A),
          iconColor: AppTheme.primaryAccent,
          collapsedIconColor: AppTheme.primaryAccent,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Multi-threading Control
                  Text(
                    'Multi-threading Configuration',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Thread Count: $threadCount',
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                                Text(
                                  'Max: $maxThreadCount',
                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: AppTheme.lightGrey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            SliderTheme(
                              data: Theme.of(context).sliderTheme.copyWith(
                                trackHeight: 4,
                                thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 8,
                                ),
                                overlayShape: const RoundSliderOverlayShape(
                                  overlayRadius: 16,
                                ),
                              ),
                              child: Slider(
                                value: threadCount.toDouble(),
                                min: 1,
                                max: maxThreadCount.toDouble(),
                                divisions: maxThreadCount - 1,
                                onChanged: (double value) {
                                  ref.read(threadCountProvider.notifier).state = 
                                      value.round();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // System Information
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: AppTheme.pcbBorderDecoration,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'System Information',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: AppTheme.primaryAccent,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildInfoRow(
                          context,
                          'Logical Processors',
                          maxThreadCount.toString(),
                        ),
                        _buildInfoRow(
                          context,
                          'Recommended Threads',
                          '${(maxThreadCount * 0.8).round()}',
                        ),
                        _buildInfoRow(
                          context,
                          'Current Configuration',
                          '$threadCount thread${threadCount > 1 ? 's' : ''}',
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Performance Tips
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryAccent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.secondaryAccent.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.lightbulb_outline,
                              color: AppTheme.secondaryAccent,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Performance Tips',
                              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: AppTheme.secondaryAccent,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '• Use 80% of available cores for optimal performance\n'
                          '• More threads may cause diminishing returns\n'
                          '• Consider file size and available memory',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.offWhite,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: AppTheme.offWhite,
            ),
          ),
        ],
      ),
    );
  }
}