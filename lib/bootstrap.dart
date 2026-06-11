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

  // 1. Logger
  AppLogger.init(isDev: AppConstants.isDev);

  // 2. Validar variables de entorno
  AppConstants.validate();

  // 3. BLoC observer
  Bloc.observer = const AppBlocObserver();

  // 4. Supabase
  await Supabase.initialize(
    url: AppConstants.supabaseUrl,
    anonKey: AppConstants.supabaseAnonKey,
    debug: AppConstants.isDev,
  );

  // 5. FIX CRÍTICO: Esperar a que Supabase restaure la sesión del storage local
  //    ANTES de configurar GetIt y arrancar la app.
  //
  //    En arranque frío, Supabase.initialize() devuelve el Future cuando el
  //    cliente está listo, pero currentUser puede seguir siendo null porque la
  //    sesión se restaura de forma asíncrona desde el storage seguro del
  //    dispositivo. Al await este stream tomamos el primer evento (que siempre
  //    es initialSession) y en ese punto currentUser ya tiene el valor correcto:
  //    - Si había sesión guardada → currentUser != null
  //    - Si no había sesión       → currentUser == null
  //
  //    Esto garantiza que cuando el authGuard corra por primera vez y cuando
  //    los BloCs hagan su primera query, el userId ya está disponible.
  await Supabase.instance.client.auth.onAuthStateChange.first;

  AppLogger.i(
    '[Bootstrap] Flavor: ${AppConstants.flavor} | '
    'Supabase: ${AppConstants.supabaseUrl} | '
    'User: ${Supabase.instance.client.auth.currentUser?.id ?? "anonymous"}',
  );

  // 6. Inyección de dependencias (después de que Supabase tiene sesión)
  await configureDependencies();

  runApp(const App());
}
