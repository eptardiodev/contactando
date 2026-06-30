import 'package:contactando/features/contacts/presentation/bloc/contacts_bloc.dart';
import 'package:contactando/features/transactions/presentation/bloc/transactions_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/auth/presentation/pages/change_password_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/contacts/domain/entities/contact_entity.dart';
import '../../features/contacts/presentation/pages/add_contact_page.dart';
import '../../features/contacts/presentation/pages/contact_detail_page.dart';
import '../../features/contacts/presentation/pages/contacts_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/transactions/presentation/pages/transactions_page.dart';
import '../di/injection.dart';
import '../shell/app_shell.dart';
import 'app_routes.dart';
import 'navigation_params.dart';

@lazySingleton
class AppRouter {
  AppRouter();

  late final GoRouter router = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: AppRoutes.dashboard,
    redirect: _authGuard,
    // FIX: El refreshListenable ya NO usa _AuthStateNotifier que escuchaba
    // todos los eventos incluyendo initialSession. Ahora usamos un Listenable
    // que solo notifica en signIn y signOut reales, nunca en initialSession.
    // Esto evita el rebuild del StatefulShellRoute en cold start.
    refreshListenable: _SignInSignOutNotifier(),
    routes: [
      // ── Auth routes ──────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.login,
        name: AppRoutes.loginName,
        builder: (_, __) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: AppRoutes.registerName,
        builder: (_, __) => const RegisterPage(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        name: AppRoutes.forgotPasswordName,
        builder: (_, __) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: AppRoutes.changePassword,
        name: AppRoutes.changePasswordName,
        builder: (_, __) => const ChangePasswordPage(),
      ),

      // ── Shell con tabs ───────────────────────────────────────────────────
      // Solo las 4 pantallas "ancla". Ninguna tiene rutas hijas anidadas aquí
      // adentro: cualquier vista "profunda" vive afuera del shell (ver abajo)
      // para que no herede el bottom nav.
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) {
          return MultiBlocProvider(
            providers: [
              // Instancias "maestras": viven mientras el usuario navega
              // entre tabs. Nunca se tocan desde las rutas secundaria.
              BlocProvider(create: (_) => getIt<ContactsBloc>()),
              BlocProvider(create: (_) => getIt<TransactionsBloc>()),
            ],
            child: AppShell(navigationShell: shell),
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.dashboard,
                name: AppRoutes.dashboardName,
                builder: (_, __) => const DashboardPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.contacts,
                name: AppRoutes.contactsName,
                builder: (_, __) => const ContactsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.transactions,
                name: AppRoutes.transactionsName,
                builder: (_, __) => const TransactionsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.settings,
                name: AppRoutes.settingsName,
                builder: (_, __) => const SettingsPage(),
              ),
            ],
          ),
        ],
      ),

      // ── Vistas secundaria ───────────────────────────────────────────────
      // Top-level: hermanas del shell, no hijas. Se alcanzan con push/pushNamed,
      // se cierran con pop, nunca muestran bottom nav.

      GoRoute(
        path: AppRoutes.contactAdd,
        name: AppRoutes.contactAddName,
        builder: (_, __) => const AddContactPage(),
      ),

      GoRoute(
        path: '${AppRoutes.contactDetail}/:id',
        name: AppRoutes.contactDetailName,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          final contact = state.extra as ContactEntity?;
          return ContactDetailPage(contactId: id, contact: contact);
        },
      ),

      // GoRoute(
      //   path: AppRoutes.contactsSecondary,
      //   name: AppRoutes.contactsSecondaryName,
      //   builder: (context, state) {
      //     final params = state.extra as ContactsSecondaryParams?;
      //     return BlocProvider(
      //       // Instancia nueva, aislada del ContactsBloc del shell.
      //       create: (_) => getIt<ContactsBloc>()
      //         ..add(
      //           LoadContacts(
      //             relatedToContactId: params?.relatedToContactId,
      //             searchQuery: params?.searchQuery,
      //           ),
      //         ),
      //       child: const ContactsPage(),
      //     );
      //   },
      // ),

      // GoRoute(
      //   path: AppRoutes.transactionsSecondary,
      //   name: AppRoutes.transactionsSecondaryName,
      //   builder: (context, state) {
      //     final params = state.extra as TransactionsSecondaryParams?;
      //     return BlocProvider(
      //       // Instancia nueva, aislada del TransactionsBloc del shell.
      //       create: (_) => getIt<TransactionsBloc>()
      //         ..add(
      //           LoadTransactions(
      //             contactId: params?.contactId,
      //             dateRange: params?.dateRange,
      //           ),
      //         ),
      //       child: const TransactionsPage(),
      //     );
      //   },
      // ),

      // ── Fuera del shell ──────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.profile,
        name: AppRoutes.profileName,
        builder: (_, __) => const ProfilePage(),
      ),
    ],
  );

  // ── Auth Guard ─────────────────────────────────────────────────────────────
  // FIX: Gracias al await en bootstrap(), cuando este guard corre por primera
  // vez currentSession ya tiene el valor correcto. No hay race condition.
  String? _authGuard(BuildContext context, GoRouterState state) {
    final session = Supabase.instance.client.auth.currentSession;
    final isSupabaseAuthenticated = session != null;

    final prefs = getIt<SharedPreferences>();
    final ts = prefs.getInt('last_login_timestamp');
    final isWithin24h = ts != null &&
        DateTime.now().difference(
          DateTime.fromMillisecondsSinceEpoch(ts),
        ) <
            const Duration(hours: 24);

    final isAuthenticated = isSupabaseAuthenticated || isWithin24h;

    final isOnAuthRoute = state.matchedLocation == AppRoutes.login ||
        state.matchedLocation == AppRoutes.register ||
        state.matchedLocation == AppRoutes.forgotPassword ||
        state.matchedLocation == AppRoutes.changePassword;

    if (!isAuthenticated && !isOnAuthRoute) return AppRoutes.login;
    if (isAuthenticated && isOnAuthRoute) return AppRoutes.dashboard;
    return null;
  }
}

// ── Sign In / Sign Out Notifier ───────────────────────────────────────────────
//
// Solo notifica a GoRouter cuando el usuario hace login o logout explícito.
// Filtra initialSession (restauración de sesión al arrancar) y tokenRefreshed
// (refresh silencioso del JWT) que no requieren que el router re-evalúe nada.
class _SignInSignOutNotifier extends ChangeNotifier {
  _SignInSignOutNotifier() {
    _subscription = Supabase.instance.client.auth.onAuthStateChange
        .listen((data) {
      final event = data.event;
      // Solo estos dos eventos requieren que el router redirija:
      // signedIn  → usuario acaba de autenticarse → ir a dashboard
      // signedOut → usuario cerró sesión          → ir a login
      if (event == AuthChangeEvent.signedIn ||
          event == AuthChangeEvent.signedOut) {
        notifyListeners();
      }
      // initialSession, tokenRefreshed, userUpdated, passwordRecovery, etc.
      // no necesitan redirigir al usuario a ningún lado.
    });
  }

  late final dynamic _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}