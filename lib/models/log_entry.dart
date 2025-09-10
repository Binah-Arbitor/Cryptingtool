/// Log entry levels for categorization and coloring
enum LogLevel {
  info,
  warning,
  error,
  success,
  debug;

  @override
  String toString() {
    switch (this) {
      case LogLevel.info:
        return 'INFO';
      case LogLevel.warning:
        return 'WARN';
      case LogLevel.error:
        return 'ERROR';
      case LogLevel.success:
        return 'SUCCESS';
      case LogLevel.debug:
        return 'DEBUG';
    }
  }
}

/// Log entry data model for console output
class LogEntry {
  final String message;
  final LogLevel level;
  final DateTime timestamp;

  const LogEntry({
    required this.message,
    required this.level,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? const DateTime.fromMillisecondsSinceEpoch(0);

  factory LogEntry.info(String message) {
    return LogEntry(
      message: message,
      level: LogLevel.info,
      timestamp: DateTime.now(),
    );
  }

  factory LogEntry.warning(String message) {
    return LogEntry(
      message: message,
      level: LogLevel.warning,
      timestamp: DateTime.now(),
    );
  }

  factory LogEntry.error(String message) {
    return LogEntry(
      message: message,
      level: LogLevel.error,
      timestamp: DateTime.now(),
    );
  }

  factory LogEntry.success(String message) {
    return LogEntry(
      message: message,
      level: LogLevel.success,
      timestamp: DateTime.now(),
    );
  }

  factory LogEntry.debug(String message) {
    return LogEntry(
      message: message,
      level: LogLevel.debug,
      timestamp: DateTime.now(),
    );
  }

  String get formattedTimestamp {
    return '${timestamp.hour.toString().padLeft(2, '0')}:'
           '${timestamp.minute.toString().padLeft(2, '0')}:'
           '${timestamp.second.toString().padLeft(2, '0')}';
  }

  @override
  String toString() {
    return '[$formattedTimestamp] ${level.toString()}: $message';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LogEntry &&
        other.message == message &&
        other.level == level &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return message.hashCode ^ level.hashCode ^ timestamp.hashCode;
  }
}