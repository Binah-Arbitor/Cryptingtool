import 'package:flutter/material.dart';
import 'dart:io';
import '../models/encryption_config.dart';
import '../theme/app_theme.dart';

class AdvancedSettingsPanel extends StatefulWidget {
  final EncryptionConfig config;
  final Function(EncryptionConfig) onConfigChanged;
  final bool isLocked;

  const AdvancedSettingsPanel({
    super.key,
    required this.config,
    required this.onConfigChanged,
    this.isLocked = false,
  });

  @override
  State<AdvancedSettingsPanel> createState() => _AdvancedSettingsPanelState();
}

class _AdvancedSettingsPanelState extends State<AdvancedSettingsPanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 0.5,
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

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _updateThreadCount(double value) {
    if (!widget.isLocked) {
      final newConfig = widget.config.copyWith(threadCount: value.round());
      widget.onConfigChanged(newConfig);
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxThreads = Platform.numberOfProcessors;
    
    return Card(
      child: Column(
        children: [
          // Header (always visible)
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _toggleExpansion,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
                bottom: Radius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.tune,
                      color: AppTheme.tealAccent,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'ADVANCED SETTINGS',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const Spacer(),
                    if (widget.isLocked)
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.errorRed.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: AppTheme.errorRed.withOpacity(0.5),
                          ),
                        ),
                        child: Text(
                          'LOCKED',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.errorRed,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    AnimatedBuilder(
                      animation: _rotationAnimation,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _rotationAnimation.value * 3.14159,
                          child: Icon(
                            Icons.expand_more,
                            color: AppTheme.cyanAccent,
                            size: 24,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Expandable content
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: _isExpanded ? null : 0,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: _isExpanded ? 1.0 : 0.0,
              child: _isExpanded ? _buildExpandedContent(maxThreads) : Container(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedContent(int maxThreads) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(
            color: AppTheme.mediumGray,
            thickness: 0.5,
          ),
          const SizedBox(height: 16),

          // Thread Count Control
          _buildSectionHeader('MULTITHREADING CONTROL'),
          const SizedBox(height: 12),
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.darkGray.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.tealAccent.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // System Info
                Row(
                  children: [
                    Icon(
                      Icons.memory,
                      color: AppTheme.cyanAccent,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'System Processors: $maxThreads cores',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightGray,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Thread Count Display
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Thread Count:',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.mediumGray,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.tealAccent.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppTheme.tealAccent.withOpacity(0.5),
                        ),
                      ),
                      child: Text(
                        '${widget.config.threadCount}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.tealAccent,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Thread Count Slider
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AppTheme.tealAccent,
                    inactiveTrackColor: AppTheme.darkGray,
                    thumbColor: AppTheme.tealAccent,
                    overlayColor: AppTheme.tealAccent.withOpacity(0.2),
                    valueIndicatorColor: AppTheme.tealAccent,
                    valueIndicatorTextStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.deepOffBlack,
                      fontWeight: FontWeight.w600,
                    ),
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 8,
                      disabledThumbRadius: 6,
                    ),
                    trackHeight: 4,
                  ),
                  child: Slider(
                    value: widget.config.threadCount.toDouble(),
                    min: 1,
                    max: maxThreads.toDouble(),
                    divisions: maxThreads - 1,
                    label: widget.config.threadCount.toString(),
                    onChanged: widget.isLocked ? null : _updateThreadCount,
                  ),
                ),

                // Thread recommendations
                const SizedBox(height: 12),
                _buildRecommendationChips(maxThreads),

                const SizedBox(height: 16),

                // Performance Info
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.deepOffBlack.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: AppTheme.mediumGray.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: AppTheme.cyanAccent,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'PERFORMANCE IMPACT',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppTheme.cyanAccent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getPerformanceDescription(),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.mediumGray,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Memory Usage Section
          _buildSectionHeader('MEMORY OPTIMIZATION'),
          const SizedBox(height: 12),
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.darkGray.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.tealAccent.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.storage,
                      color: AppTheme.cyanAccent,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Buffer Management',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightGray,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                _buildInfoRow(
                  'Buffer Size per Thread:',
                  '64 KB',
                  AppTheme.tealAccent,
                ),
                _buildInfoRow(
                  'Total Memory Usage:',
                  '${(widget.config.threadCount * 64).toStringAsFixed(0)} KB',
                  AppTheme.cyanAccent,
                ),
                _buildInfoRow(
                  'Optimization Level:',
                  _getOptimizationLevel(),
                  _getOptimizationColor(),
                ),

                const SizedBox(height: 12),

                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.deepOffBlack.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        color: AppTheme.warningAmber,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Higher thread counts improve performance for large files but increase memory usage.',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.mediumGray,
                            fontSize: 11,
                          ),
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
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
        color: AppTheme.cyanAccent,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildRecommendationChips(int maxThreads) {
    final recommendations = [
      {'label': 'Conservative', 'value': (maxThreads * 0.5).round(), 'color': AppTheme.cyanAccent},
      {'label': 'Balanced', 'value': (maxThreads * 0.75).round(), 'color': AppTheme.tealAccent},
      {'label': 'Aggressive', 'value': maxThreads, 'color': AppTheme.warningAmber},
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: recommendations.map<Widget>((rec) {
        final isSelected = widget.config.threadCount == rec['value'] as int;
        return GestureDetector(
          onTap: widget.isLocked ? null : () => _updateThreadCount((rec['value'] as int).toDouble()),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isSelected 
                  ? (rec['color'] as Color).withOpacity(0.3)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected 
                    ? (rec['color'] as Color)
                    : (rec['color'] as Color).withOpacity(0.5),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Text(
              '${rec['label']} (${rec['value']})',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isSelected 
                    ? (rec['color'] as Color)
                    : AppTheme.mediumGray,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildInfoRow(String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.mediumGray,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: valueColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _getPerformanceDescription() {
    final threadCount = widget.config.threadCount;
    final maxThreads = Platform.numberOfProcessors;
    
    if (threadCount == 1) {
      return 'Single-threaded processing. Lowest memory usage but slower for large files.';
    } else if (threadCount <= maxThreads * 0.5) {
      return 'Conservative multithreading. Good balance between performance and resource usage.';
    } else if (threadCount <= maxThreads * 0.75) {
      return 'Optimized multithreading. Excellent performance with moderate resource usage.';
    } else {
      return 'Maximum multithreading. Best performance but highest CPU and memory usage.';
    }
  }

  String _getOptimizationLevel() {
    final threadCount = widget.config.threadCount;
    final maxThreads = Platform.numberOfProcessors;
    final ratio = threadCount / maxThreads;
    
    if (ratio <= 0.25) return 'ECO';
    if (ratio <= 0.5) return 'BALANCED';
    if (ratio <= 0.75) return 'PERFORMANCE';
    return 'MAXIMUM';
  }

  Color _getOptimizationColor() {
    final threadCount = widget.config.threadCount;
    final maxThreads = Platform.numberOfProcessors;
    final ratio = threadCount / maxThreads;
    
    if (ratio <= 0.25) return AppTheme.limeGreen;
    if (ratio <= 0.5) return AppTheme.cyanAccent;
    if (ratio <= 0.75) return AppTheme.tealAccent;
    return AppTheme.warningAmber;
  }
}