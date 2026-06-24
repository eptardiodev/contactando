enum Flavor { dev, prod }

class AppConstants {
  AppConstants._();

  // ─── Identidad ──────────────────────────────────────────────────────────
  static const String appName = 'Contactando';
  static const String appNameDev = 'Contactando DEV';

  // ─── Flavor ─────────────────────────────────────────────────────────────

  /// Se setea explícitamente desde bootstrap(), llamado por cada entry point
  /// (main_dev.dart / main_prod.dart). Ya NO depende de --dart-define para
  /// decidir el flavor — solo el archivo que se ejecutó manda.
  static late final Flavor flavor;

  static bool get isDev => flavor == Flavor.dev;
  static bool get isProd => flavor == Flavor.prod;

  static void initFlavor(Flavor f) => flavor = f;

  // ─── Supabase (sin cambios, sigue viniendo de dart-define-from-file) ────

  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://wrjlrhngdjifdntwqecb.supabase.co',
  );

  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue:
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndyamxyaG5nZGppZmRudHdxZWNiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTgzMjY2NDUsImV4cCI6MjA3MzkwMjY0NX0.uRPHQbz9MPiKDiOGc1AcsoBAUUgC3rgoVZ6NjtbVY3Q',
  );

  // ─── Validación ───────────────────────────────────────────────────────────

  static void validate() {
    final errors = <String>[];

    if (supabaseUrl.isEmpty) {
      errors.add('SUPABASE_URL no definido.');
    }
    if (!supabaseUrl.startsWith('https://')) {
      errors.add('SUPABASE_URL debe empezar con https://');
    }
    if (supabaseAnonKey.isEmpty) {
      errors.add('SUPABASE_ANON_KEY no definido.');
    }
    // Sanity check: en prod nunca debería quedar el default de dev.
    if (isProd && supabaseUrl.contains('wrjlrhngdjifdntwqecb')) {
      errors.add(
        'Flavor=prod pero SUPABASE_URL sigue siendo el default de dev. '
            '¿Olvidaste --dart-define-from-file=.env.prod.json?',
      );
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
            '║  flutter run --target lib/main_prod.dart \\               ║\n'
            '║    --dart-define-from-file=.env.prod.json                ║\n'
            '╚══════════════════════════════════════════════════════════╝\n',
      );
    }
  }
}