import 'package:flutter_test/flutter_test.dart';
import 'package:cryptingtool/crypto_service.dart';

void main() {
  group('CryptoService Tests', () {
    test('encrypt should return encrypted text', () {
      final cryptoService = CryptoService();
      const testText = 'Hello World';
      
      final result = cryptoService.encrypt(testText);
      
      expect(result, isNotEmpty);
      expect(result, isNot(equals(testText)));
    });

    test('encrypt should handle empty string', () {
      final cryptoService = CryptoService();
      const testText = '';
      
      final result = cryptoService.encrypt(testText);
      
      expect(result, equals(''));
    });

    test('encrypt should be consistent', () {
      final cryptoService = CryptoService();
      const testText = 'Test123';
      
      final result1 = cryptoService.encrypt(testText);
      final result2 = cryptoService.encrypt(testText);
      
      expect(result1, equals(result2));
    });
  });
}