import 'package:logger/logger.dart';

/// Logger centralizado de la app.
/// En dev: imprime con colores y stack traces.
/// En prod: solo errores (sin datos sensibles).
class AppLogger {
  AppLogger._();

  static late Logger _logger;
  static bool _isDev = false;

  static void init({required bool isDev}) {
    _isDev = isDev;
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: isDev ? 2 : 0,
        errorMethodCount: 8,
        lineLength: 120,
        colors: isDev,
        printEmojis: isDev,
        dateTimeFormat: DateTimeFormat.none,
      ),
      level: isDev ? Level.debug : Level.error,
    );
  }

  static void d(String message) {
    if (_isDev) _logger.d(message);
  }

  static void i(String message) {
    _logger.i(message);
  }

  static void w(String message) {
    _logger.w(message);
  }

  static void e(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }
}
