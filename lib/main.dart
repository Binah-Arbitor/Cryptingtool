import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'theme/app_theme.dart';
import 'providers/app_state_provider.dart';
import 'screens/crypting_tool_screen.dart';
import 'crypto_bridge/crypto_bridge_service.dart';

void main() async {
  // Initialize the crypto bridge service
  WidgetsFlutterBinding.ensureInitialized();
  await CryptoBridgeService.initialize();
  
  runApp(const CryptingToolApp());
}

class CryptingToolApp extends StatelessWidget {
  const CryptingToolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppStateProvider(),
      child: MaterialApp(
        title: 'CryptingTool - High-Performance Encryption Suite',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const CryptingToolScreen(),
      ),
    );
  }
}