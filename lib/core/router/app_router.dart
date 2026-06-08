import 'package:flutter/material.dart';
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

@singleton
class AppRouter {
  AppRouter();

  late final GoRouter router = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: AppRoutes.dashboard,
    redirect: _authGuard,
    refreshListenable: _AuthStateNotifier(),
    routes: [
      // ── Auth routes (sin shell) ──────────────────────────────────────────
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
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppShell(navigationShell: shell),
        branches: [
          // ── Dashboard ──────────────────────────────────────────────────
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.dashboard,
                name: AppRoutes.dashboardName,
                builder: (_, __) => const DashboardPage(),
              ),
            ],
          ),

          // ── Contacts ───────────────────────────────────────────────────
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.contacts,
                name: AppRoutes.contactsName,
                builder: (_, __) => const ContactsPage(),
                routes: [
                  // /contacts/add  — debe ir ANTES que :id para no colisionar
                  GoRoute(
                    path: 'add',
                    name: AppRoutes.contactAddName,
                    builder: (_, __) => const AddContactPage(),
                  ),
                  // /contacts/:id
                  GoRoute(
                    path: ':id',
                    name: AppRoutes.contactDetailName,
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      // El contacto completo llega via `extra` cuando se navega
                      // desde la lista. Si extra es null la página lo carga por id.
                      final contact = state.extra as ContactEntity?;
                      return ContactDetailPage(
                        contactId: id,
                        contact: contact,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),

          // ── Transactions ───────────────────────────────────────────────
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.transactions,
                name: AppRoutes.transactionsName,
                builder: (_, __) => const TransactionsPage(),
              ),
            ],
          ),

          // ── Settings ───────────────────────────────────────────────────
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

      // ── Profile fuera del shell (navegación desde AppBar / Drawer) ────────
      GoRoute(
        path: AppRoutes.profile,
        name: AppRoutes.profileName,
        builder: (_, __) => const ProfilePage(),
      ),
    ],
  );

  // ── Auth Guard ─────────────────────────────────────────────────────────────

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

// ── Auth State Notifier ───────────────────────────────────────────────────────

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