import 'package:flutter/material.dart';
import 'dart:ffi' as ffi;
import 'dart:io';
import 'package:path/path.dart' as path;

// C++ function signatures
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
  CryptingLib.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypting Tool',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Crypting Tool'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  String _result = '';
  String _version = 'Unknown';

  @override
  void initState() {
    super.initState();
    _version = CryptingLib.getVersion() ?? 'Library not loaded';
  }

  void _encrypt() {
    setState(() {
      _result = CryptingLib.encrypt(_controller.text) ?? 'Encryption failed';
    });
  }

  void _decrypt() {
    setState(() {
      _result = CryptingLib.decrypt(_controller.text) ?? 'Decryption failed';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text(
              'C++ Library Version: $_version',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter text to encrypt/decrypt',
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _encrypt,
                  child: const Text('Encrypt'),
                ),
                ElevatedButton(
                  onPressed: _decrypt,
                  child: const Text('Decrypt'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Result: $_result',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}