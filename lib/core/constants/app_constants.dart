/// Todas las constantes de configuración de la app.
///
/// Los valores sensibles (URLs, keys) vienen EXCLUSIVAMENTE de
/// --dart-define-from-file=.env.<flavor>.json
/// NUNCA están hardcodeados aquí ni en ningún otro archivo Dart.
class AppConstants {
  AppConstants._();

  // ─── Identidad ────────────────────────────────────────────────────────────

  static const String appName = 'Contactando';
  static const String appNameDev = 'Contactando DEV';

  // ─── Flavor ───────────────────────────────────────────────────────────────

  /// Inyectado via --dart-define=FLAVOR=dev|prod (opcional).
  /// Si no se pasa nada, por defecto corre en modo dev (temporal, sin flavors).
  static const String flavor =
      String.fromEnvironment('FLAVOR', defaultValue: 'dev');

  static bool get isDev => flavor == 'dev';
  static bool get isProd => flavor == 'prod';

  // ─── Supabase ─────────────────────────────────────────────────────────────

  /// Inyectado via --dart-define=SUPABASE_URL=... (opcional).
  /// Default = proyecto de dev (temporal, sin flavors).
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://wrjlrhngdjifdntwqecb.supabase.co',
  );

  /// Inyectado via --dart-define=SUPABASE_ANON_KEY=... (opcional).
  /// Default = anon key de dev (temporal, sin flavors).
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndyamxyaG5nZGppZmRudHdxZWNiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTgzMjY2NDUsImV4cCI6MjA3MzkwMjY0NX0.uRPHQbz9MPiKDiOGc1AcsoBAUUgC3rgoVZ6NjtbVY3Q',
  );

  // ─── Validación ───────────────────────────────────────────────────────────

  /// Llama esto en bootstrap() antes de usar cualquier constante.
  /// Falla rápido si el desarrollador olvidó pasar --dart-define-from-file.
  static void validate() {
    final errors = <String>[];

    if (flavor.isEmpty) {
      errors.add('FLAVOR no definido. ¿Olvidaste --dart-define-from-file?');
    }
    if (flavor != 'dev' && flavor != 'prod') {
      errors.add('FLAVOR="$flavor" no es válido. Usa "dev" o "prod".');
    }
    if (supabaseUrl.isEmpty) {
      errors.add('SUPABASE_URL no definido.');
    }
    if (!supabaseUrl.startsWith('https://')) {
      errors.add('SUPABASE_URL debe empezar con https://');
    }
    if (supabaseAnonKey.isEmpty) {
      errors.add('SUPABASE_ANON_KEY no definido.');
    }

    if (errors.isNotEmpty) {
      throw StateError(
        '\n\n'
        '╔══════════════════════════════════════════════════════════╗\n'
        '║           ERROR DE CONFIGURACIÓN — AppConstants          ║\n'
        '╠══════════════════════════════════════════════════════════╣\n'
        '${errors.map((e) => '║  • $e').join('\n')}\n'
        '╠══════════════════════════════════════════════════════════╣\n'
        '║  Solución:                                               ║\n'
        '║  flutter run --target lib/main_dev.dart \\               ║\n'
        '║    --dart-define-from-file=.env.dev.json                ║\n'
        '╚══════════════════════════════════════════════════════════╝\n',
      );
    }
  }
}
