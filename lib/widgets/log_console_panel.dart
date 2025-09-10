import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/encryption_models.dart';

class LogConsolePanel extends StatefulWidget {
  final List<LogEntry> logs;
  final VoidCallback onClearLogs;
  final bool isExpanded;
  final Function(bool) onExpansionChanged;

  const LogConsolePanel({
    super.key,
    required this.logs,
    required this.onClearLogs,
    this.isExpanded = false,
    required this.onExpansionChanged,
  });

  @override
  State<LogConsolePanel> createState() => _LogConsolePanelState();
}

class _LogConsolePanelState extends State<LogConsolePanel> {
  final ScrollController _scrollController = ScrollController();
  bool _autoScroll = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(LogConsolePanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Auto-scroll to bottom when new logs are added
    if (_autoScroll && widget.logs.length > oldWidget.logs.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      final isAtBottom = _scrollController.position.pixels >= 
                        _scrollController.position.maxScrollExtent - 10;
      if (_autoScroll != isAtBottom) {
        setState(() => _autoScroll = isAtBottom);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppTheme.pcbDecoration,
      child: ExpansionTile(
        initiallyExpanded: widget.isExpanded,
        onExpansionChanged: widget.onExpansionChanged,
        title: Row(
          children: [
            Icon(
              Icons.terminal,
              color: AppTheme.tealCyan,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              'LIVE LOG CONSOLE',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppTheme.tealCyan,
                fontSize: 14,
                letterSpacing: 1.0,
              ),
            ),
            const Spacer(),
            _buildLogStats(),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildAutoScrollIndicator(),
            const SizedBox(width: 8),
            _buildClearButton(),
            const SizedBox(width: 8),
            AnimatedRotation(
              turns: widget.isExpanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                Icons.keyboard_arrow_down,
                color: AppTheme.tealCyan,
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.cardGray,
        collapsedBackgroundColor: AppTheme.cardGray,
        children: [
          _buildConsoleContent(),
        ],
      ),
    );
  }

  Widget _buildLogStats() {
    final logCounts = _getLogCounts();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (logCounts['error']! > 0)
          _buildLogCounter('E', logCounts['error']!, AppTheme.errorRed),
        if (logCounts['warning']! > 0) ...[
          if (logCounts['error']! > 0) const SizedBox(width: 4),
          _buildLogCounter('W', logCounts['warning']!, AppTheme.warningOrange),
        ],
        if (logCounts['info']! > 0) ...[
          if (logCounts['error']! > 0 || logCounts['warning']! > 0) const SizedBox(width: 4),
          _buildLogCounter('I', logCounts['info']!, AppTheme.infoBlue),
        ],
        if (logCounts['success']! > 0) ...[
          if (logCounts['error']! > 0 || logCounts['warning']! > 0 || logCounts['info']! > 0) const SizedBox(width: 4),
          _buildLogCounter('S', logCounts['success']!, AppTheme.limeGreen),
        ],
      ],
    );
  }

  Widget _buildLogCounter(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.5), width: 1),
      ),
      child: Text(
        '$label:$count',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildAutoScrollIndicator() {
    return Tooltip(
      message: _autoScroll ? 'Auto-scroll ON' : 'Auto-scroll OFF',
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: _autoScroll ? AppTheme.limeGreen.withOpacity(0.2) : AppTheme.mediumGray.withOpacity(0.2),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: _autoScroll ? AppTheme.limeGreen : AppTheme.mediumGray,
            width: 1,
          ),
        ),
        child: Icon(
          Icons.vertical_align_bottom,
          size: 12,
          color: _autoScroll ? AppTheme.limeGreen : AppTheme.mediumGray,
        ),
      ),
    );
  }

  Widget _buildClearButton() {
    return Tooltip(
      message: 'Clear logs',
      child: GestureDetector(
        onTap: widget.logs.isNotEmpty ? widget.onClearLogs : null,
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: widget.logs.isNotEmpty 
                ? AppTheme.warningOrange.withOpacity(0.2) 
                : AppTheme.mediumGray.withOpacity(0.2),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: widget.logs.isNotEmpty ? AppTheme.warningOrange : AppTheme.mediumGray,
              width: 1,
            ),
          ),
          child: Icon(
            Icons.clear_all,
            size: 12,
            color: widget.logs.isNotEmpty ? AppTheme.warningOrange : AppTheme.mediumGray,
          ),
        ),
      ),
    );
  }

  Widget _buildConsoleContent() {
    return Container(
      height: 300,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.deepOffBlack,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.tealCyan.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildConsoleHeader(),
          Expanded(
            child: _buildLogContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildConsoleHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.cardGray,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
        border: Border(
          bottom: BorderSide(
            color: AppTheme.tealCyan.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Terminal indicators (fake window controls)
          Row(
            children: [
              _buildWindowControl(AppTheme.errorRed),
              const SizedBox(width: 6),
              _buildWindowControl(AppTheme.warningOrange),
              const SizedBox(width: 6),
              _buildWindowControl(AppTheme.limeGreen),
            ],
          ),
          const SizedBox(width: 16),
          Icon(
            Icons.terminal,
            size: 14,
            color: AppTheme.tealCyan,
          ),
          const SizedBox(width: 8),
          Text(
            'cryptingtool-console',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.tealCyan,
              fontFamily: 'monospace',
              fontSize: 11,
            ),
          ),
          const Spacer(),
          Text(
            '${widget.logs.length} lines',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.lightGray.withOpacity(0.7),
              fontFamily: 'monospace',
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWindowControl(Color color) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildLogContent() {
    if (widget.logs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.article_outlined,
              size: 48,
              color: AppTheme.lightGray.withOpacity(0.3),
            ),
            const SizedBox(height: 12),
            Text(
              'No logs available',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightGray.withOpacity(0.5),
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start an encryption/decryption operation to see logs',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.lightGray.withOpacity(0.3),
                fontFamily: 'monospace',
                fontSize: 10,
              ),
            ),
          ],
        ),
      );
    }

    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(12),
        itemCount: widget.logs.length,
        itemBuilder: (context, index) => _buildLogEntry(widget.logs[index], index + 1),
      ),
    );
  }

  Widget _buildLogEntry(LogEntry entry, int lineNumber) {
    final textStyle = _getLogTextStyle(entry.level);
    final levelIcon = _getLogLevelIcon(entry.level);
    final levelColor = _getLogLevelColor(entry.level);

    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Line number
          SizedBox(
            width: 40,
            child: Text(
              lineNumber.toString().padLeft(3, ' '),
              style: AppTheme.consoleTextStyle.copyWith(
                color: AppTheme.lightGray.withOpacity(0.4),
                fontSize: 10,
              ),
            ),
          ),
          const SizedBox(width: 8),
          
          // Timestamp
          SizedBox(
            width: 80,
            child: Text(
              entry.formattedTime,
              style: AppTheme.consoleTextStyle.copyWith(
                color: AppTheme.lightGray.withOpacity(0.6),
                fontSize: 10,
              ),
            ),
          ),
          const SizedBox(width: 8),
          
          // Log level indicator
          Container(
            width: 16,
            alignment: Alignment.center,
            child: Icon(
              levelIcon,
              size: 12,
              color: levelColor,
            ),
          ),
          const SizedBox(width: 8),
          
          // Log level badge
          Container(
            width: 50,
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            decoration: BoxDecoration(
              color: levelColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Text(
              entry.level.displayName,
              style: AppTheme.consoleTextStyle.copyWith(
                color: levelColor,
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 12),
          
          // Message
          Expanded(
            child: SelectableText(
              entry.message,
              style: textStyle,
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _getLogTextStyle(LogLevel level) {
    switch (level) {
      case LogLevel.info:
        return AppTheme.consoleInfoStyle;
      case LogLevel.warning:
        return AppTheme.consoleWarningStyle;
      case LogLevel.error:
        return AppTheme.consoleErrorStyle;
      case LogLevel.success:
        return AppTheme.consoleSuccessStyle;
    }
  }

  IconData _getLogLevelIcon(LogLevel level) {
    switch (level) {
      case LogLevel.info:
        return Icons.info_outline;
      case LogLevel.warning:
        return Icons.warning_outlined;
      case LogLevel.error:
        return Icons.error_outline;
      case LogLevel.success:
        return Icons.check_circle_outline;
    }
  }

  Color _getLogLevelColor(LogLevel level) {
    switch (level) {
      case LogLevel.info:
        return AppTheme.infoBlue;
      case LogLevel.warning:
        return AppTheme.warningOrange;
      case LogLevel.error:
        return AppTheme.errorRed;
      case LogLevel.success:
        return AppTheme.limeGreen;
    }
  }

  Map<String, int> _getLogCounts() {
    final counts = {'info': 0, 'warning': 0, 'error': 0, 'success': 0};
    for (final log in widget.logs) {
      switch (log.level) {
        case LogLevel.info:
          counts['info'] = counts['info']! + 1;
          break;
        case LogLevel.warning:
          counts['warning'] = counts['warning']! + 1;
          break;
        case LogLevel.error:
          counts['error'] = counts['error']! + 1;
          break;
        case LogLevel.success:
          counts['success'] = counts['success']! + 1;
          break;
      }
    }
    return counts;
  }
}