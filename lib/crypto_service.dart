import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';
import 'crypto_bindings.dart';

class CryptoService {
  static DynamicLibrary? _dylib;
  static CryptoBindings? _bindings;

  CryptoService() {
    _dylib ??= _loadLibrary();
    _bindings ??= CryptoBindings(_dylib!);
  }

  DynamicLibrary _loadLibrary() {
    if (Platform.isAndroid || Platform.isLinux) {
      return DynamicLibrary.open('libcrypto_native.so');
    } else if (Platform.isWindows) {
      return DynamicLibrary.open('crypto_native.dll');
    } else if (Platform.isMacOS) {
      return DynamicLibrary.open('libcrypto_native.dylib');
    } else {
      throw UnsupportedError('Platform not supported');
    }
  }

  String encrypt(String text) {
    try {
      final textPtr = text.toNativeUtf8();
      final resultPtr = _bindings!.simple_encrypt(textPtr.cast<Char>());
      final result = resultPtr.cast<Utf8>().toDartString();
      malloc.free(textPtr);
      return result;
    } catch (e) {
      // Fallback to simple Dart implementation for demo
      return _simpleEncrypt(text);
    }
  }

  String _simpleEncrypt(String text) {
    // Simple Caesar cipher as fallback
    const shift = 3;
    return text.split('').map((char) {
      if (char.codeUnitAt(0) >= 65 && char.codeUnitAt(0) <= 90) {
        return String.fromCharCode(((char.codeUnitAt(0) - 65 + shift) % 26) + 65);
      } else if (char.codeUnitAt(0) >= 97 && char.codeUnitAt(0) <= 122) {
        return String.fromCharCode(((char.codeUnitAt(0) - 97 + shift) % 26) + 97);
      }
      return char;
    }).join('');
  }
}