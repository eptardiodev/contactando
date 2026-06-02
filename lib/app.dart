import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/settings/presentation/bloc/settings_cubit.dart';
import 'l10n/app_localizations.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      // El SettingsCubit ya vive en GetIt como singleton — no lo creamos aquí,
      // solo lo exponemos al árbol de widgets con BlocProvider.value
      value: getIt<SettingsCubit>()..loadSettings(),
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settings) {
          final router = getIt<AppRouter>().router;

          return MaterialApp.router(
            title: 'Contactando',
            debugShowCheckedModeBanner: false,

            // Tema controlado por SettingsCubit
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: settings.themeMode,

            // Router
            routerConfig: router,

            // Localización
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('es'),
              Locale('en'),
            ],

            // Locale controlada por SettingsCubit (null = usar la del sistema)
            locale: settings.locale,
          );
        },
      ),
    );
  }
}
