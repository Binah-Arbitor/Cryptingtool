enum LogLevel {
  info('INFO', 'Information'),
  warning('WARNING', 'Warning'),
  error('ERROR', 'Error'),
  success('SUCCESS', 'Success');

  const LogLevel(this.displayName, this.description);

  final String displayName;
  final String description;
}

class LogEntry {
  final DateTime timestamp;
  final LogLevel level;
  final String message;
  final String? source;

  const LogEntry({
    required this.timestamp,
    required this.level,
    required this.message,
    this.source,
  });

  factory LogEntry.info(String message, {String? source}) {
    return LogEntry(
      timestamp: DateTime.now(),
      level: LogLevel.info,
      message: message,
      source: source,
    );
  }

  factory LogEntry.warning(String message, {String? source}) {
    return LogEntry(
      timestamp: DateTime.now(),
      level: LogLevel.warning,
      message: message,
      source: source,
    );
  }

  factory LogEntry.error(String message, {String? source}) {
    return LogEntry(
      timestamp: DateTime.now(),
      level: LogLevel.error,
      message: message,
      source: source,
    );
  }

  factory LogEntry.success(String message, {String? source}) {
    return LogEntry(
      timestamp: DateTime.now(),
      level: LogLevel.success,
      message: message,
      source: source,
    );
  }

  String get formattedTimestamp {
    return '${timestamp.hour.toString().padLeft(2, '0')}:'
        '${timestamp.minute.toString().padLeft(2, '0')}:'
        '${timestamp.second.toString().padLeft(2, '0')}.'
        '${timestamp.millisecond.toString().padLeft(3, '0')}';
  }

  String get formattedMessage {
    final prefix = source != null ? '[$source] ' : '';
    return '[$formattedTimestamp] [${level.displayName}] $prefix$message';
  }

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'level': level.name,
      'message': message,
      'source': source,
    };
  }

  factory LogEntry.fromJson(Map<String, dynamic> json) {
    return LogEntry(
      timestamp: DateTime.parse(json['timestamp']),
      level: LogLevel.values.firstWhere((e) => e.name == json['level']),
      message: json['message'],
      source: json['source'],
    );
  }

  @override
  String toString() {
    return formattedMessage;
  }
}