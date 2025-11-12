import 'dart:developer' as developer;

enum LogLevel { debug, info, warn, error }

class AppLogger {
  final String tag;
  const AppLogger(this.tag);

  void debug(Object? message) {
    developer.log('$message', name: tag, level: 500);
  }

  void info(Object? message) {
    developer.log('$message', name: tag, level: 800);
  }

  void warn(Object? message) {
    developer.log('$message', name: tag, level: 900);
  }

  void error(Object? message, [Object? error, StackTrace? st]) {
    developer.log('$message', name: tag, level: 1000, error: error, stackTrace: st);
  }
}
