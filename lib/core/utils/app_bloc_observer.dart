import 'package:bloc/bloc.dart';

import 'app_logger.dart';


/// Observer global de todos los BLoCs y Cubits de la app.
/// En dev: imprime cada transición en consola.
/// En prod: solo loggea errores (configurable para enviar a Sentry).
class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onCreate(BlocBase<dynamic> bloc) {
    super.onCreate(bloc);
    AppLogger.d('BLoC created: ${bloc.runtimeType}');
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    AppLogger.d('${bloc.runtimeType}: ${change.currentState} → ${change.nextState}');
  }

  @override
  void onTransition(Bloc<dynamic, dynamic> bloc, Transition<dynamic, dynamic> transition) {
    super.onTransition(bloc, transition);
    AppLogger.d('${bloc.runtimeType}: event ${transition.event}');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    AppLogger.e('${bloc.runtimeType} error', error: error, stackTrace: stackTrace);
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase<dynamic> bloc) {
    super.onClose(bloc);
    AppLogger.d('BLoC closed: ${bloc.runtimeType}');
  }
}
