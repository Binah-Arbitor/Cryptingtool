import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/log_entry.dart';
import '../services/app_state.dart';
import '../theme.dart';

class LiveConsolePanel extends ConsumerStatefulWidget {
  const LiveConsolePanel({super.key});

  @override
  ConsumerState<LiveConsolePanel> createState() => _LiveConsolePanelState();
}

class _LiveConsolePanelState extends ConsumerState<LiveConsolePanel> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final logEntries = ref.watch(logEntriesProvider);

    // Auto-scroll to bottom when new logs are added
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    return Card(
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Row(
            children: [
              Icon(
                Icons.terminal,
                color: AppTheme.primaryAccent,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Live Console',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(width: 8),
              if (logEntries.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryAccent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    logEntries.length.toString(),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppTheme.primaryAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (logEntries.isNotEmpty)
                IconButton(
                  onPressed: () {
                    ref.read(logEntriesProvider.notifier).clearLogs();
                  },
                  icon: Icon(
                    Icons.clear_all,
                    color: AppTheme.lightGrey,
                    size: 20,
                  ),
                  tooltip: 'Clear Log',
                ),
              const Icon(Icons.expand_more, color: AppTheme.primaryAccent),
            ],
          ),
          backgroundColor: const Color(0xFF1A1A1A),
          collapsedBackgroundColor: const Color(0xFF1A1A1A),
          iconColor: AppTheme.primaryAccent,
          collapsedIconColor: AppTheme.primaryAccent,
          children: [
            Container(
              height: 300,
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Console header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.deepOffBlack,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(4),
                      ),
                      border: Border.all(
                        color: AppTheme.primaryAccent.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            color: AppTheme.errorColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            color: AppTheme.warningColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            color: AppTheme.successColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'console',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppTheme.lightGrey,
                            fontFamily: 'FiraCode',
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Console content
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.deepOffBlack,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(4),
                          bottomRight: Radius.circular(4),
                        ),
                        border: Border.all(
                          color: AppTheme.primaryAccent.withOpacity(0.3),
                        ),
                      ),
                      child: logEntries.isEmpty
                          ? Center(
                              child: Text(
                                'No log entries yet...\nLogs will appear here during operations.',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppTheme.lightGrey.withOpacity(0.7),
                                  fontFamily: 'FiraCode',
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : ListView.builder(
                              controller: _scrollController,
                              itemCount: logEntries.length,
                              itemBuilder: (context, index) {
                                return _buildLogEntry(context, logEntries[index]);
                              },
                            ),
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

  Widget _buildLogEntry(BuildContext context, LogEntry entry) {
    Color textColor;
    IconData icon;

    switch (entry.level) {
      case LogLevel.info:
        textColor = AppTheme.infoColor;
        icon = Icons.info_outline;
        break;
      case LogLevel.warning:
        textColor = AppTheme.warningColor;
        icon = Icons.warning_outlined;
        break;
      case LogLevel.error:
        textColor = AppTheme.errorColor;
        icon = Icons.error_outline;
        break;
      case LogLevel.success:
        textColor = AppTheme.successColor;
        icon = Icons.check_circle_outline;
        break;
      case LogLevel.debug:
        textColor = AppTheme.lightGrey;
        icon = Icons.bug_report_outlined;
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${entry.formattedTimestamp} ',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.lightGrey.withOpacity(0.7),
              fontFamily: 'FiraCode',
              fontSize: 11,
            ),
          ),
          Icon(
            icon,
            size: 12,
            color: textColor.withOpacity(0.8),
          ),
          const SizedBox(width: 4),
          Text(
            '[${entry.level.toString()}] ',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: textColor,
              fontFamily: 'FiraCode',
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              entry.message,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: textColor,
                fontFamily: 'FiraCode',
                fontSize: 11,
              ),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}