import 'package:flutter/material.dart';
import 'dart:io';
import '../theme/app_theme.dart';
import '../models/encryption_models.dart';

class AdvancedSettingsPanel extends StatefulWidget {
  final EncryptionConfig config;
  final Function(EncryptionConfig) onConfigChanged;
  final bool isEnabled;

  const AdvancedSettingsPanel({
    super.key,
    required this.config,
    required this.onConfigChanged,
    this.isEnabled = true,
  });

  @override
  State<AdvancedSettingsPanel> createState() => _AdvancedSettingsPanelState();
}

class _AdvancedSettingsPanelState extends State<AdvancedSettingsPanel> {
  bool _isExpanded = false;
  final int _maxThreads = Platform.numberOfProcessors;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppTheme.pcbDecoration,
      child: ExpansionTile(
        initiallyExpanded: _isExpanded,
        onExpansionChanged: (expanded) => setState(() => _isExpanded = expanded),
        title: Row(
          children: [
            Icon(
              Icons.tune_outlined,
              color: AppTheme.tealCyan,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              'ADVANCED SETTINGS',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppTheme.tealCyan,
                fontSize: 14,
                letterSpacing: 1.0,
              ),
            ),
            const Spacer(),
            _buildSystemInfo(),
          ],
        ),
        trailing: AnimatedRotation(
          turns: _isExpanded ? 0.5 : 0,
          duration: const Duration(milliseconds: 200),
          child: Icon(
            Icons.keyboard_arrow_down,
            color: AppTheme.tealCyan,
          ),
        ),
        backgroundColor: AppTheme.cardGray,
        collapsedBackgroundColor: AppTheme.cardGray,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                _buildThreadingSection(),
                const SizedBox(height: 24),
                _buildPerformanceSection(),
                const SizedBox(height: 24),
                _buildBufferSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.infoBlue.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.memory,
            size: 14,
            color: AppTheme.infoBlue,
          ),
          const SizedBox(width: 4),
          Text(
            '${_maxThreads}C',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.infoBlue,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThreadingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('MULTITHREADING CONTROL', Icons.settings_applications),
        const SizedBox(height: 16),
        
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.mediumGray.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.tealCyan.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.memory,
                    size: 16,
                    color: AppTheme.tealCyan,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'WORKER THREADS',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppTheme.tealCyan,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.tealCyan.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${widget.config.threadCount}',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppTheme.tealCyan,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 6,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
                  tickMarkShape: const RoundSliderTickMarkShape(tickMarkRadius: 2),
                  activeTickMarkColor: AppTheme.tealCyan,
                  inactiveTickMarkColor: AppTheme.mediumGray,
                ),
                child: Slider(
                  value: widget.config.threadCount.toDouble(),
                  min: 1,
                  max: _maxThreads.toDouble(),
                  divisions: _maxThreads - 1,
                  onChanged: widget.isEnabled ? _onThreadCountChanged : null,
                ),
              ),
              
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Single Thread',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightGray.withOpacity(0.7),
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    'Max ($_maxThreads cores)',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightGray.withOpacity(0.7),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              _buildThreadingInfo(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildThreadingInfo() {
    final efficiency = _calculateThreadEfficiency(widget.config.threadCount);
    final efficiencyColor = efficiency > 0.8 
        ? AppTheme.limeGreen 
        : efficiency > 0.6 
            ? AppTheme.warningOrange 
            : AppTheme.errorRed;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.cardGray.withOpacity(0.5),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: efficiencyColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.speed,
                size: 14,
                color: efficiencyColor,
              ),
              const SizedBox(width: 6),
              Text(
                'EXPECTED EFFICIENCY',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: efficiencyColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                '${(efficiency * 100).toStringAsFixed(0)}%',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: efficiencyColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: efficiency,
            backgroundColor: AppTheme.mediumGray,
            valueColor: AlwaysStoppedAnimation<Color>(efficiencyColor),
          ),
          const SizedBox(height: 8),
          Text(
            _getThreadingAdvice(widget.config.threadCount),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.lightGray.withOpacity(0.8),
              fontSize: 9,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('PERFORMANCE TUNING', Icons.speed),
        const SizedBox(height: 16),
        
        Row(
          children: [
            Expanded(
              child: _buildPerformanceCard(
                'CPU Priority',
                'High',
                Icons.priority_high,
                AppTheme.warningOrange,
                'Process will use high CPU priority for faster encryption',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildPerformanceCard(
                'Memory Usage',
                'Optimized',
                Icons.memory,
                AppTheme.limeGreen,
                'Memory usage optimized for large file processing',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBufferSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('BUFFER CONFIGURATION', Icons.storage),
        const SizedBox(height: 16),
        
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.mediumGray.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.tealCyan.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.storage,
                    size: 16,
                    color: AppTheme.tealCyan,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'READ BUFFER',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppTheme.tealCyan,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.tealCyan.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '64 KB',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppTheme.tealCyan,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Optimal buffer size for balancing memory usage and I/O performance',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightGray.withOpacity(0.7),
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppTheme.tealCyan,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: AppTheme.tealCyan,
            fontSize: 13,
            letterSpacing: 0.8,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.tealCyan.withOpacity(0.5),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPerformanceCard(
    String title,
    String value,
    IconData icon,
    Color color,
    String description,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.cardGray.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 14,
                color: color,
              ),
              const SizedBox(width: 6),
              Text(
                title.toUpperCase(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppTheme.lightGray,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.lightGray.withOpacity(0.7),
              fontSize: 9,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  double _calculateThreadEfficiency(int threadCount) {
    // Simple efficiency calculation based on typical multithreading performance
    if (threadCount == 1) return 1.0;
    if (threadCount <= _maxThreads ~/ 2) return 0.95 - (threadCount - 1) * 0.05;
    if (threadCount <= _maxThreads) return 0.85 - (threadCount - _maxThreads ~/ 2) * 0.1;
    return 0.5; // Over-threading penalty
  }

  String _getThreadingAdvice(int threadCount) {
    if (threadCount == 1) {
      return 'Single-threaded processing. Consider using more threads for better performance.';
    } else if (threadCount <= _maxThreads ~/ 2) {
      return 'Good balance between performance and resource usage.';
    } else if (threadCount <= _maxThreads) {
      return 'High performance mode. May compete with other system processes.';
    } else {
      return 'Over-threading detected. This may reduce performance due to context switching.';
    }
  }

  void _onThreadCountChanged(double value) {
    final newConfig = widget.config.copyWith(threadCount: value.toInt());
    widget.onConfigChanged(newConfig);
  }
}