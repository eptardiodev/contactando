import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/change_password_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/contacts/presentation/pages/contacts_page.dart';
import '../../features/transactions/presentation/pages/transactions_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../shell/app_shell.dart';
import 'app_routes.dart';

@singleton
class AppRouter {
  AppRouter();

  late final GoRouter router = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: AppRoutes.dashboard,
    redirect: _authGuard,
    refreshListenable: _AuthStateNotifier(),
    routes: [
      // ── Auth routes (sin shell) ──────────────────────────────────────
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

      // ── Shell con tabs ───────────────────────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppShell(navigationShell: shell),
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
                routes: [
                  GoRoute(
                    path: ':id',
                    name: AppRoutes.contactDetailName,
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      // Importar y retornar ContactDetailPage(id: id) cuando exista
                      return Scaffold(
                        appBar: AppBar(title: Text('Contacto $id')),
                        body: const Center(child: Text('Detalle próximamente')),
                      );
                    },
                  ),
                ],
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

      // ── Profile fuera del shell (desde AppBar) ───────────────────────
      GoRoute(
        path: AppRoutes.profile,
        name: AppRoutes.profileName,
        builder: (_, __) => const ProfilePage(),
      ),
    ],
  );


  // String? _authGuard(BuildContext context, GoRouterState state) {
  //   return null;
  // }
 // TODO: esto es temporal hasta que se arregle el login

  /// Auth guard: redirige a login si no hay sesión, o al home si ya la hay.
  String? _authGuard(BuildContext context, GoRouterState state) {
    final session = Supabase.instance.client.auth.currentSession;
    final isAuthenticated = session != null;

    final isOnAuthRoute = state.matchedLocation == AppRoutes.login ||
        state.matchedLocation == AppRoutes.register ||
        state.matchedLocation == AppRoutes.forgotPassword ||
        state.matchedLocation == AppRoutes.changePassword;

    if (!isAuthenticated && !isOnAuthRoute) return AppRoutes.login;
    if (isAuthenticated && isOnAuthRoute) return AppRoutes.dashboard;
    return null;
  }
}

/// Notifica a GoRouter cuando cambia el estado de auth de Supabase.
class _AuthStateNotifier extends ChangeNotifier {
  _AuthStateNotifier() {
    _subscription = Supabase.instance.client.auth.onAuthStateChange
        .listen((_) => notifyListeners());
  }

  late final dynamic _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
