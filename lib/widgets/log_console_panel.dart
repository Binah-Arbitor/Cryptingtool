import 'package:flutter/material.dart';
import '../models/log_entry.dart';
import '../theme/app_theme.dart';

class LogConsolePanel extends StatefulWidget {
  final List<LogEntry> logEntries;
  final VoidCallback? onClearLogs;
  final bool autoScroll;

  const LogConsolePanel({
    super.key,
    required this.logEntries,
    this.onClearLogs,
    this.autoScroll = true,
  });

  @override
  State<LogConsolePanel> createState() => _LogConsolePanelState();
}

class _LogConsolePanelState extends State<LogConsolePanel>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _animationController;
  bool _isExpanded = false;
  bool _isAutoScrollEnabled = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _isAutoScrollEnabled = widget.autoScroll;
  }

  @override
  void didUpdateWidget(LogConsolePanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Auto-scroll to bottom when new entries are added
    if (widget.logEntries.length > oldWidget.logEntries.length && 
        _isAutoScrollEnabled && 
        _scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
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

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Color _getLogColor(LogLevel level) {
    switch (level) {
      case LogLevel.info:
        return AppTheme.infoColor;
      case LogLevel.warning:
        return AppTheme.warningColor;
      case LogLevel.error:
        return AppTheme.errorColor;
      case LogLevel.success:
        return AppTheme.successColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final entryCount = widget.logEntries.length;
    final hasError = widget.logEntries.any((entry) => entry.level == LogLevel.error);
    final hasWarning = widget.logEntries.any((entry) => entry.level == LogLevel.warning);

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
                    Stack(
                      children: [
                        const Icon(
                          Icons.terminal,
                          color: AppTheme.tealAccent,
                          size: 24,
                        ),
                        // Status indicator
                        if (hasError)
                          Positioned(
                            right: -2,
                            top: -2,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: AppTheme.errorRed,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppTheme.deepOffBlack,
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                        if (!hasError && hasWarning)
                          Positioned(
                            right: -2,
                            top: -2,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: AppTheme.warningColor,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppTheme.deepOffBlack,
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'SYSTEM LOG CONSOLE',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const Spacer(),
                    
                    // Entry count badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        // Info: Replaced deprecated 'withOpacity'
                        color: AppTheme.tealAccent.withAlpha((255 * 0.2).round()),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          // Info: Replaced deprecated 'withOpacity'
                          color: AppTheme.tealAccent.withAlpha((255 * 0.5).round()),
                        ),
                      ),
                      child: Text(
                        '$entryCount',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.tealAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    
                    AnimatedRotation(
                      turns: _isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: const Icon(
                        Icons.expand_more,
                        color: AppTheme.cyanAccent,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Expandable console content
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: _isExpanded ? 300 : 0,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: _isExpanded ? 1.0 : 0.0,
              child: _isExpanded ? _buildConsoleContent() : Container(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConsoleContent() {
    return Column(
      children: [
        const Divider(
          color: AppTheme.mediumGray,
          thickness: 0.5,
          height: 1,
        ),
        
        // Console toolbar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          // Info: Replaced deprecated 'withOpacity'
          color: AppTheme.darkGray.withAlpha((255 * 0.3).round()),
          child: Row(
            children: [
              // Auto-scroll toggle
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isAutoScrollEnabled = !_isAutoScrollEnabled;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    // Info: Replaced deprecated 'withOpacity'
                    color: _isAutoScrollEnabled 
                        ? AppTheme.tealAccent.withAlpha((255 * 0.2).round())
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      // Info: Replaced deprecated 'withOpacity'
                      color: _isAutoScrollEnabled 
                          ? AppTheme.tealAccent
                          : AppTheme.mediumGray.withAlpha((255 * 0.5).round()),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _isAutoScrollEnabled 
                            ? Icons.vertical_align_bottom 
                            : Icons.pause,
                        size: 14,
                        color: _isAutoScrollEnabled 
                            ? AppTheme.tealAccent 
                            : AppTheme.mediumGray,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'AUTO-SCROLL',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _isAutoScrollEnabled 
                              ? AppTheme.tealAccent 
                              : AppTheme.mediumGray,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              
              // Scroll to bottom button
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _scrollToBottom,
                  borderRadius: BorderRadius.circular(4),
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      size: 18,
                      color: AppTheme.cyanAccent,
                    ),
                  ),
                ),
              ),
              
              const Spacer(),
              
              // Log level indicators
              _buildLogLevelIndicator(LogLevel.success, widget.logEntries.where((e) => e.level == LogLevel.success).length),
              const SizedBox(width: 6),
              _buildLogLevelIndicator(LogLevel.info, widget.logEntries.where((e) => e.level == LogLevel.info).length),
              const SizedBox(width: 6),
              _buildLogLevelIndicator(LogLevel.warning, widget.logEntries.where((e) => e.level == LogLevel.warning).length),
              const SizedBox(width: 6),
              _buildLogLevelIndicator(LogLevel.error, widget.logEntries.where((e) => e.level == LogLevel.error).length),
              
              const SizedBox(width: 12),
              
              // Clear logs button
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.onClearLogs,
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.clear_all,
                          size: 14,
                          color: AppTheme.errorRed,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'CLEAR',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.errorRed,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Console content
        Expanded(
          child: Container(
            // Info: Replaced deprecated 'withOpacity'
            color: AppTheme.deepOffBlack.withAlpha((255 * 0.8).round()),
            child: widget.logEntries.isEmpty
                ? _buildEmptyConsole()
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(8),
                    itemCount: widget.logEntries.length,
                    itemBuilder: (context, index) {
                      final entry = widget.logEntries[index];
                      return _buildLogEntry(entry, index);
                    },
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogLevelIndicator(LogLevel level, int count) {
    if (count == 0) return Container();
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        // Info: Replaced deprecated 'withOpacity'
        color: _getLogColor(level).withAlpha((255 * 0.2).round()),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: _getLogColor(level),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            count.toString(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: _getLogColor(level),
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyConsole() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.code,
            size: 48,
            // Info: Replaced deprecated 'withOpacity'
            color: AppTheme.mediumGray.withAlpha((255 * 0.5).round()),
          ),
          const SizedBox(height: 16),
          Text(
            'SYSTEM CONSOLE READY',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              // Info: Replaced deprecated 'withOpacity'
              color: AppTheme.mediumGray.withAlpha((255 * 0.7).round()),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Log entries will appear here during operations',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              // Info: Replaced deprecated 'withOpacity'
              color: AppTheme.mediumGray.withAlpha((255 * 0.5).round()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogEntry(LogEntry entry, int index) {
    final logColor = _getLogColor(entry.level);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: index.isEven 
              ? Colors.transparent 
              // Info: Replaced deprecated 'withOpacity'
              : AppTheme.darkGray.withAlpha((255 * 0.1).round()),
          borderRadius: BorderRadius.circular(2),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timestamp
            SizedBox(
              width: 80,
              child: Text(
                entry.formattedTimestamp,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  // Info: Replaced deprecated 'withOpacity'
                  color: AppTheme.mediumGray.withAlpha((255 * 0.8).round()),
                  fontFamily: 'Courier',
                  fontSize: 10,
                ),
              ),
            ),
            const SizedBox(width: 8),
            
            // Level indicator
            Container(
              width: 4,
              height: 12,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                color: logColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            
            // Level badge
            Container(
              width: 60,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                // Info: Replaced deprecated 'withOpacity'
                color: logColor.withAlpha((255 * 0.2).round()),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(
                entry.level.displayName,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: logColor,
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 8),
            
            // Source (if provided)
            if (entry.source != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  // Info: Replaced deprecated 'withOpacity'
                  color: AppTheme.cyanAccent.withAlpha((255 * 0.2).round()),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  entry.source!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.cyanAccent,
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            
            // Message
            Expanded(
              child: Text(
                entry.message,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightGray,
                  fontFamily: 'Courier',
                  fontSize: 11,
                  height: 1.2,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}