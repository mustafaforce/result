import 'package:flutter/foundation.dart';

enum LogLevel { debug, info, warning, error }

class Logger {
  const Logger(this.tag);

  final String tag;

  static LogLevel _level = LogLevel.debug;

  static void setLevel(LogLevel level) {
    _level = level;
  }

  void debug(String message) => _log(LogLevel.debug, message);
  void info(String message) => _log(LogLevel.info, message);
  void warning(String message) => _log(LogLevel.warning, message);
  void error(String message, [Object? exception]) {
    _log(LogLevel.error, '$message${exception != null ? ' | $exception' : ''}');
  }

  void _log(LogLevel level, String message) {
    if (level.index < _level.index) return;

    final prefix = switch (level) {
      LogLevel.debug => '🐛 DEBUG',
      LogLevel.info => 'ℹ️ INFO',
      LogLevel.warning => '⚠️ WARN',
      LogLevel.error => '❌ ERROR',
    };

    final ts = DateTime.now().toIso8601String().substring(11, 23);
    debugPrint('$ts [$prefix][$tag] $message');
  }
}
