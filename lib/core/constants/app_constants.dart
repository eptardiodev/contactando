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

  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');

  static const String supabaseAnonKey =
  String.fromEnvironment('SUPABASE_ANON_KEY');

  // ─── Validación ───────────────────────────────────────────────────────────

  static void validate() {
    final errors = <String>[];

    if (supabaseUrl.isEmpty) {
      errors.add('SUPABASE_URL no definido. ¿Olvidaste --dart-define-from-file?');
    } else if (!supabaseUrl.startsWith('https://')) {
      errors.add('SUPABASE_URL debe empezar con https://');
    }

    if (supabaseAnonKey.isEmpty) {
      errors.add('SUPABASE_ANON_KEY no definido. ¿Olvidaste --dart-define-from-file?');
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