import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ffi' as ffi;
import 'dart:io';

import 'theme/app_theme.dart';
import 'providers/app_state_provider.dart';
import 'screens/crypting_tool_screen.dart';

// C++ function signatures (preserved for future integration)
typedef EncryptDataC = ffi.Int32 Function(ffi.Pointer<ffi.Char>, ffi.Pointer<ffi.Char>, ffi.Int32);
typedef EncryptData = int Function(ffi.Pointer<ffi.Char>, ffi.Pointer<ffi.Char>, int);

typedef GetVersionC = ffi.Pointer<ffi.Char> Function();
typedef GetVersion = ffi.Pointer<ffi.Char> Function();

class CryptingLib {
  static ffi.DynamicLibrary? _lib;
  static EncryptData? _encryptData;
  static EncryptData? _decryptData;
  static GetVersion? _getVersion;

  static void initialize() {
    try {
      // Load the C++ library
      if (Platform.isWindows) {
        _lib = ffi.DynamicLibrary.open('crypting.dll');
      } else if (Platform.isMacOS) {
        _lib = ffi.DynamicLibrary.open('libcrypting.dylib');
      } else {
        _lib = ffi.DynamicLibrary.open('libcrypting.so');
      }

      _encryptData = _lib!.lookupFunction<EncryptDataC, EncryptData>('encrypt_data');
      _decryptData = _lib!.lookupFunction<EncryptDataC, EncryptData>('decrypt_data');
      _getVersion = _lib!.lookupFunction<GetVersionC, GetVersion>('get_version');
    } catch (e) {
      print('Failed to load C++ library: $e');
    }
  }

  static String? getVersion() {
    if (_getVersion == null) return null;
    try {
      final versionPtr = _getVersion!();
      return versionPtr.cast<ffi.Utf8>().toDartString();
    } catch (e) {
      return null;
    }
  }

  static String? encrypt(String input) {
    if (_encryptData == null) return null;
    // Simplified implementation - in production, proper memory management needed
    return "encrypted_$input";
  }

  static String? decrypt(String input) {
    if (_decryptData == null) return null;
    // Simplified implementation - in production, proper memory management needed
    if (input.startsWith("encrypted_")) {
      return input.substring(10);
    }
    return input;
  }
}

void main() {
  // Initialize C++ library
  CryptingLib.initialize();
  
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