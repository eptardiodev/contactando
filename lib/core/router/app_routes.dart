/// Constantes de rutas para evitar strings sueltos por la app.
class AppRoutes {
  AppRoutes._();

  // ── Auth ──────────────────────────────────────────────────────────────────

  static const String login = '/login';
  static const String loginName = 'login';

  static const String register = '/register';
  static const String registerName = 'register';

  static const String forgotPassword = '/forgot-password';
  static const String forgotPasswordName = 'forgotPassword';

  static const String changePassword = '/change-password';
  static const String changePasswordName = 'changePassword';

  // ── Shell tabs ────────────────────────────────────────────────────────────

  static const String dashboard = '/dashboard';
  static const String dashboardName = 'dashboard';

  static const String contacts = '/contacts';
  static const String contactsName = 'contacts';

  /// Ruta hija de contacts: /contacts/:id
  static const String contactDetailName = 'contactDetail';

  /// Ruta hija de contacts: /contacts/add
  static const String contactAddName = 'contactAdd';

  static const String transactions = '/transactions';
  static const String transactionsName = 'transactions';

  static const String settings = '/settings';
  static const String settingsName = 'settings';

  // ── Fuera del shell ───────────────────────────────────────────────────────

  static const String profile = '/profile';
  static const String profileName = 'profile';
}