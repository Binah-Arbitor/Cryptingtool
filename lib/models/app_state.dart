import 'dart:io';

enum ProcessingStatus {
  ready('Ready', 'System ready for operations'),
  processing('Processing', 'Operation in progress'),
  success('Success', 'Operation completed successfully'),
  error('Error', 'Operation failed'),
  paused('Paused', 'Operation paused'),
  cancelled('Cancelled', 'Operation cancelled');

  const ProcessingStatus(this.displayName, this.description);

  final String displayName;
  final String description;
}

class FileInfo {
  final String path;
  final String name;
  final int size;
  final String extension;
  final DateTime lastModified;

  const FileInfo({
    required this.path,
    required this.name,
    required this.size,
    required this.extension,
    required this.lastModified,
  });

  factory FileInfo.fromFile(File file) {
    final stat = file.statSync();
    final name = file.path.split('/').last;
    final extension = name.contains('.') ? name.split('.').last.toLowerCase() : '';
    
    return FileInfo(
      path: file.path,
      name: name,
      size: stat.size,
      extension: extension,
      lastModified: stat.modified,
    );
  }

  String get formattedSize {
    if (size < 1024) {
      return '$size B';
    } else if (size < 1024 * 1024) {
      return '${(size / 1024).toStringAsFixed(1)} KB';
    } else if (size < 1024 * 1024 * 1024) {
      return '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(size / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }

  String get formattedLastModified {
    final now = DateTime.now();
    final difference = now.difference(lastModified);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'name': name,
      'size': size,
      'extension': extension,
      'lastModified': lastModified.toIso8601String(),
    };
  }

  factory FileInfo.fromJson(Map<String, dynamic> json) {
    return FileInfo(
      path: json['path'],
      name: json['name'],
      size: json['size'],
      extension: json['extension'],
      lastModified: DateTime.parse(json['lastModified']),
    );
  }

  @override
  String toString() {
    return 'FileInfo(name: $name, size: $formattedSize, path: $path)';
  }
}

class ProcessingProgress {
  final int currentChunk;
  final int totalChunks;
  final int bytesProcessed;
  final int totalBytes;
  final Duration elapsed;
  final ProcessingStatus status;
  final String? currentOperation;

  const ProcessingProgress({
    required this.currentChunk,
    required this.totalChunks,
    required this.bytesProcessed,
    required this.totalBytes,
    required this.elapsed,
    required this.status,
    this.currentOperation,
  });

  double get chunkProgress {
    if (totalChunks == 0) return 0.0;
    return currentChunk / totalChunks;
  }

  double get byteProgress {
    if (totalBytes == 0) return 0.0;
    return bytesProcessed / totalBytes;
  }

  String get formattedProgress {
    final percentage = (byteProgress * 100).toStringAsFixed(1);
    return '$percentage% ($currentChunk/$totalChunks chunks)';
  }

  String get estimatedTimeRemaining {
    if (bytesProcessed == 0 || elapsed.inSeconds == 0) return 'Calculating...';
    
    final bytesPerSecond = bytesProcessed / elapsed.inSeconds;
    final remainingBytes = totalBytes - bytesProcessed;
    final remainingSeconds = (remainingBytes / bytesPerSecond).round();
    
    if (remainingSeconds < 60) {
      return '${remainingSeconds}s remaining';
    } else if (remainingSeconds < 3600) {
      final minutes = (remainingSeconds / 60).round();
      return '${minutes}m remaining';
    } else {
      final hours = (remainingSeconds / 3600).round();
      return '${hours}h remaining';
    }
  }

  ProcessingProgress copyWith({
    int? currentChunk,
    int? totalChunks,
    int? bytesProcessed,
    int? totalBytes,
    Duration? elapsed,
    ProcessingStatus? status,
    String? currentOperation,
  }) {
    return ProcessingProgress(
      currentChunk: currentChunk ?? this.currentChunk,
      totalChunks: totalChunks ?? this.totalChunks,
      bytesProcessed: bytesProcessed ?? this.bytesProcessed,
      totalBytes: totalBytes ?? this.totalBytes,
      elapsed: elapsed ?? this.elapsed,
      status: status ?? this.status,
      currentOperation: currentOperation ?? this.currentOperation,
    );
  }

  static ProcessingProgress get initial => const ProcessingProgress(
    currentChunk: 0,
    totalChunks: 0,
    bytesProcessed: 0,
    totalBytes: 0,
    elapsed: Duration.zero,
    status: ProcessingStatus.ready,
  );

  Map<String, dynamic> toJson() {
    return {
      'currentChunk': currentChunk,
      'totalChunks': totalChunks,
      'bytesProcessed': bytesProcessed,
      'totalBytes': totalBytes,
      'elapsed': elapsed.inMilliseconds,
      'status': status.name,
      'currentOperation': currentOperation,
    };
  }

  factory ProcessingProgress.fromJson(Map<String, dynamic> json) {
    return ProcessingProgress(
      currentChunk: json['currentChunk'],
      totalChunks: json['totalChunks'],
      bytesProcessed: json['bytesProcessed'],
      totalBytes: json['totalBytes'],
      elapsed: Duration(milliseconds: json['elapsed']),
      status: ProcessingStatus.values.firstWhere((e) => e.name == json['status']),
      currentOperation: json['currentOperation'],
    );
  }

  @override
  String toString() {
    return 'ProcessingProgress(status: ${status.displayName}, progress: $formattedProgress, operation: $currentOperation)';
  }
}