/// Operation status for tracking encryption/decryption progress
enum OperationStatus {
  ready,
  processing,
  success,
  error,
  cancelled;

  @override
  String toString() {
    switch (this) {
      case OperationStatus.ready:
        return 'Ready';
      case OperationStatus.processing:
        return 'Processing';
      case OperationStatus.success:
        return 'Success';
      case OperationStatus.error:
        return 'Error';
      case OperationStatus.cancelled:
        return 'Cancelled';
    }
  }
}

/// File information for selected files
class FileInfo {
  final String path;
  final String name;
  final int sizeBytes;

  const FileInfo({
    required this.path,
    required this.name,
    required this.sizeBytes,
  });

  String get formattedSize {
    if (sizeBytes < 1024) {
      return '$sizeBytes B';
    } else if (sizeBytes < 1024 * 1024) {
      return '${(sizeBytes / 1024).toStringAsFixed(1)} KB';
    } else if (sizeBytes < 1024 * 1024 * 1024) {
      return '${(sizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(sizeBytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }

  @override
  String toString() {
    return '$name (${formattedSize})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FileInfo &&
        other.path == path &&
        other.name == name &&
        other.sizeBytes == sizeBytes;
  }

  @override
  int get hashCode {
    return path.hashCode ^ name.hashCode ^ sizeBytes.hashCode;
  }
}