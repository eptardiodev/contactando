import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/constants/app_constants.dart';
import 'core/di/injection.dart';
import 'core/utils/app_bloc_observer.dart';
import 'core/utils/app_logger.dart';
import 'app.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Logger (debe inicializarse primero, AppBlocObserver lo usa)
  AppLogger.init(isDev: AppConstants.isDev);

  // 2. Validar que las variables de entorno están presentes
  //    Si no se usó --dart-define-from-file, falla en tiempo de arranque
  //    y no en algún crash críptico más adelante.
  AppConstants.validate();

  // 3. BLoC observer
  Bloc.observer = const AppBlocObserver();

  // 4. Supabase
  await Supabase.initialize(
    url: AppConstants.supabaseUrl,
    anonKey: AppConstants.supabaseAnonKey,
    debug: AppConstants.isDev,
  );

  AppLogger.i(
    '[Bootstrap] Flavor: ${AppConstants.flavor} | '
    'Supabase: ${AppConstants.supabaseUrl}',
  );

  // 5. Inyección de dependencias
  await configureDependencies();

  runApp(const App());
}
