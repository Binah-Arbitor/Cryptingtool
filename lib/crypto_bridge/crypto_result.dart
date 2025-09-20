import 'dart:typed_data';

/// Represents the result of a cryptographic operation
class CryptoResult {
  /// True if the operation was successful
  final bool success;

  /// The resulting data (e.g., ciphertext or plaintext)
  ///
  /// Null if the operation failed.
  final Uint8List? data;

  /// Error message if the operation failed
  ///
  /// Null if the operation was successful.
  final String? error;

  /// Private constructor for internal use
  CryptoResult._({
    required this.success,
    this.data,
    this.error,
  });

  /// Factory constructor for a successful result
  factory CryptoResult.success(Uint8List data) {
    return CryptoResult._(success: true, data: data);
  }

  /// Factory constructor for an error result
  factory CryptoResult.error(String message) {
    return CryptoResult._(success: false, error: message);
  }
}
