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

  static const String transactions = '/transactions';
  static const String transactionsName = 'transactions';

  static const String settings = '/settings';
  static const String settingsName = 'settings';

  // ── Vistas secundaria (top-level, fuera del shell) ────────────────────────
  // Viven apiladas sobre el shell, sin bottom nav. Se alcanzan con push/pushNamed
  // desde cualquier punto de la app y se cierran con pop.

  /// /contact-add — formulario de alta de contacto.
  static const String contactAdd = '/contact-add';
  static const String contactAddName = 'contactAdd';

  /// /contact-detail/:id — detalle/edición de un contacto.
  static const String contactDetail = '/contact-detail';
  static const String contactDetailName = 'contactDetail';

  /// /contacts-secondary — misma UI que [contacts], pero accesible secundaria
  /// con un Bloc propio (no el del shell), opcionalmente filtrada.
  static const String contactsSecondary = '/contacts-secondary';
  static const String contactsSecondaryName = 'contactsSecondary';

  /// /transactions-secondary — misma UI que [transactions], pero accesible
  /// secundaria con un Bloc propio (no el del shell), opcionalmente filtrada.
  static const String transactionsSecondary = '/transactions-secondary';
  static const String transactionsSecondaryName = 'transactionsSecondary';

  // ── Fuera del shell ───────────────────────────────────────────────────────

  static const String profile = '/profile';
  static const String profileName = 'profile';
}