import 'package:contactando/core/di/injection.dart';
import 'package:contactando/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

import '../router/app_routes.dart';
import 'app_drawer.dart';

class AppShell extends StatelessWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  static const _tabs = [
    (icon: Icons.dashboard_outlined, label: 'Dashboard'),
    (icon: Icons.people_outline, label: 'Contactos'),
    (icon: Icons.receipt_long_outlined, label: 'Transacciones'),
    (icon: Icons.settings_outlined, label: 'Ajustes'),
  ];

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final initials = _getInitials(user?.email ?? 'U');

    return BlocProvider(
      create: (_) => getIt<AuthBloc>(),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticated) {
            context.goNamed(AppRoutes.loginName);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(_tabTitle(navigationShell.currentIndex)),
            actions: [
              // Botón de perfil en el AppBar
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () => context.pushNamed(AppRoutes.profileName),
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    child: Text(
                      initials,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          drawer: const AppDrawer(),
          body: navigationShell,
          bottomNavigationBar: NavigationBar(
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: _onTabTapped,
            destinations: _tabs
                .map(
                  (t) => NavigationDestination(
                    icon: Icon(t.icon),
                    label: t.label,
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  void _onTabTapped(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  String _tabTitle(int index) {
    return switch (index) {
      0 => 'Dashboard',
      1 => 'Contactos',
      2 => 'Transacciones',
      3 => 'Ajustes',
      _ => 'Contactando',
    };
  }

  String _getInitials(String email) {
    if (email.isEmpty) return '?';
    final parts = email.split('@').first.split('.');
    if (parts.length >= 2 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    final local = email.split('@').first;
    if (local.length >= 2) return local.substring(0, 2).toUpperCase();
    if (local.length == 1) return local[0].toUpperCase();
    return '?';
  }
}
