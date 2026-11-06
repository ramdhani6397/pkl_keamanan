import 'package:flutter/foundation.dart';

/// Level log yang tersedia.
enum LogLevel { debug, info, warning, error }

/// Logger terstruktur yang aman.
///
/// Hanya mencetak saat mode debug dan menyensor data sensitif.
class Logger {
  Logger._();

  static final RegExp _sensitivePattern = RegExp(
    r'(token|password|passwd|pin|api[_-]?key|secret|authorization)\s*[:=]\s*\S+',
    caseSensitive: false,
  );

  static String _redact(String message) {
    return message.replaceAllMapped(
      _sensitivePattern,
      (match) => '${match.group(1)}=[REDACTED]',
    );
  }

  static void _log(LogLevel level, String message, [Object? error]) {
    if (!kDebugMode) return;
    final label = level.name.toUpperCase();
    debugPrint('[$label] ${_redact(message)}');
    if (error != null) {
      debugPrint('[$label] Detail: ${_redact(error.toString())}');
    }
  }

  /// Informasi untuk debugging.
  static void debug(String message) {
    _log(LogLevel.debug, message);
  }

  /// Informasi umum tentang jalannya aplikasi.
  static void info(String message) {
    _log(LogLevel.info, message);
  }

  /// Kondisi tidak normal tetapi aplikasi masih berjalan.
  static void warning(String message) {
    _log(LogLevel.warning, message);
  }

  /// Kesalahan; [error] opsional untuk detail exception.
  static void error(String message, [Object? error]) {
    _log(LogLevel.error, message, error);
  }
}
