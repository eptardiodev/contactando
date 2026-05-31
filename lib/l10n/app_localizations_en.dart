// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Contactando';

  @override
  String get loginTitle => 'Welcome';

  @override
  String get loginSubtitle => 'Sign in to your account';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get loginButton => 'Sign in';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get noAccount => 'Don\'t have an account?';

  @override
  String get register => 'Sign up';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get contacts => 'Contacts';

  @override
  String get transactions => 'Transactions';

  @override
  String get settings => 'Settings';

  @override
  String get profile => 'My profile';

  @override
  String get logout => 'Sign out';

  @override
  String get errorGeneric => 'An unexpected error occurred';

  @override
  String get errorNoInternet => 'No internet connection';

  @override
  String get errorInvalidCredentials => 'Invalid credentials';
}
