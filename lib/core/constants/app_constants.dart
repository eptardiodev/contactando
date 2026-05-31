/// Valores sensibles (URLs, keys) vienen de --dart-define, NO hardcodeados aquí.
class AppConstants {
  AppConstants._();

  static const String appName = 'Contactando';
  static const String appNameDev = 'Contactando DEV';

  /// Inyectado via --dart-define=FLAVOR=dev|prod
  static const String flavor =
      String.fromEnvironment('FLAVOR', defaultValue: 'dev');

  static bool get isDev => flavor == 'dev';
  static bool get isProd => flavor == 'prod';

  /// Inyectados via --dart-define=SUPABASE_URL=...
  static const String supabaseUrl =
      String.fromEnvironment('SUPABASE_URL', defaultValue: '');
  static const String supabaseAnonKey =
      String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: '');
}
