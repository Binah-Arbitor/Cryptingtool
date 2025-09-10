import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/file_selection_panel.dart';
import '../widgets/action_buttons_panel.dart';
import '../widgets/encryption_config_panel.dart';
import '../widgets/advanced_settings_panel.dart';
import '../widgets/live_console_panel.dart';
import '../widgets/status_bar_panel.dart';
import '../theme.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.primaryAccent.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.security,
                color: AppTheme.primaryAccent,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'CryptingTool',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'High-Performance Encryption Utility',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppTheme.lightGrey,
                  ),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: AppTheme.deepOffBlack,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryAccent.withOpacity(0.0),
                  AppTheme.primaryAccent.withOpacity(0.5),
                  AppTheme.primaryAccent.withOpacity(0.0),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Main content area
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Panel 1: File I/O & Primary Actions
                  const FileSelectionPanel(),
                  const SizedBox(height: 16),
                  const ActionButtonsPanel(),
                  
                  const SizedBox(height: 24),
                  
                  // Panel 2: Encryption Configuration
                  const EncryptionConfigPanel(),
                  
                  const SizedBox(height: 16),
                  
                  // Panel 3: Advanced Settings (ExpansionTile)
                  const AdvancedSettingsPanel(),
                  
                  const SizedBox(height: 16),
                  
                  // Panel 4: Live Log Console (ExpansionTile)
                  const LiveConsolePanel(),
                  
                  // Add some bottom padding to ensure content is not hidden behind status bar
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
          
          // Panel 5: Global Status Bar (Always visible at bottom)
          const StatusBarPanel(),
        ],
      ),
      backgroundColor: AppTheme.deepOffBlack,
    );
  }
}