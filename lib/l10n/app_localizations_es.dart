// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Contactando';

  @override
  String get loginTitle => 'Bienvenido';

  @override
  String get loginSubtitle => 'Ingresa a tu cuenta';

  @override
  String get emailLabel => 'Correo electrónico';

  @override
  String get passwordLabel => 'Contraseña';

  @override
  String get loginButton => 'Iniciar sesión';

  @override
  String get forgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get noAccount => '¿No tienes cuenta?';

  @override
  String get register => 'Regístrate';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get contacts => 'Contactos';

  @override
  String get transactions => 'Transacciones';

  @override
  String get settings => 'Ajustes';

  @override
  String get profile => 'Mi perfil';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get errorGeneric => 'Ocurrió un error inesperado';

  @override
  String get errorNoInternet => 'Sin conexión a internet';

  @override
  String get errorInvalidCredentials => 'Credenciales inválidas';
}
