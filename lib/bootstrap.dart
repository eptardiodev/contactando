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

  // Logger (debe inicializarse primero, AppBlocObserver lo usa)
  AppLogger.init(isDev: AppConstants.isDev);

  // BLoC observer — usa AppBlocObserver de core/utils/, no una clase inline
  Bloc.observer = const AppBlocObserver();

  // Supabase
  await Supabase.initialize(
    url: AppConstants.supabaseUrl,
    anonKey: AppConstants.supabaseAnonKey,
    debug: AppConstants.isDev,
  );

  // Inyección de dependencias
  await configureDependencies();

  runApp(const App());
}
