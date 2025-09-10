import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

import 'theme.dart';
import 'views/main_screen.dart';
import 'services/cryptography_service.dart';
import 'services/app_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations for mobile
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Set system UI overlay style for PCB theme
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppTheme.deepOffBlack,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(
    const ProviderScope(
      child: CryptingToolApp(),
    ),
  );
}

class CryptingToolApp extends ConsumerStatefulWidget {
  const CryptingToolApp({super.key});

  @override
  ConsumerState<CryptingToolApp> createState() => _CryptingToolAppState();
}

class _CryptingToolAppState extends ConsumerState<CryptingToolApp> 
    with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    // Initialize cryptography service
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final service = ref.read(cryptographyServiceProvider);
        await service.initialize();
      } catch (e) {
        debugPrint('Failed to initialize cryptography service: $e');
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    
    // Dispose cryptography service
    try {
      final service = ref.read(cryptographyServiceProvider);
      service.dispose();
    } catch (e) {
      debugPrint('Error disposing cryptography service: $e');
    }
    
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    // Handle app lifecycle changes
    switch (state) {
      case AppLifecycleState.paused:
        // App is in background
        break;
      case AppLifecycleState.resumed:
        // App is in foreground
        break;
      case AppLifecycleState.detached:
        // App is being terminated
        try {
          final service = ref.read(cryptographyServiceProvider);
          service.dispose();
        } catch (e) {
          debugPrint('Error disposing service on app termination: $e');
        }
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CryptingTool',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const MainScreen(),
      builder: (context, child) {
        // Ensure text scaling doesn't break the layout
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.2),
          ),
          child: child!,
        );
      },
    );
  }
}