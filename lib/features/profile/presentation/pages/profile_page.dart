
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/di/injection.dart';
import '../../domain/entities/profile_entity.dart';
import '../bloc/profile_bloc.dart';

/// Provee el BLoC y dispara la carga del perfil.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = Supabase.instance.client.auth.currentUser?.id ?? '';
    return BlocProvider(
      create: (_) => getIt<ProfileBloc>()
        ..add(ProfileLoadRequested(userId)),
      child: const _ProfileView(),
    );
  }
}

// ── View ──────────────────────────────────────────────────────────────────────

class _ProfileView extends StatefulWidget {
  const _ProfileView();

  @override
  State<_ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<_ProfileView> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listenWhen: (p, c) =>
      c is ProfileLoaded && c.successMessage != null ||
          c is ProfileError,
      listener: (context, state) {
        if (state is ProfileLoaded && state.successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.successMessage!)),
          );
        }
        if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is ProfileLoading || state is ProfileInitial) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final profile = switch (state) {
          ProfileLoaded s => s.profile,
          ProfileUpdating s => s.profile,
          ProfileError s => s.previous,
          _ => null,
        };

        if (profile == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Perfil')),
            body: const Center(
              child: Text('No se pudo cargar el perfil.'),
            ),
          );
        }

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle: true,
            title: const Text('Perfil'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ProfileHeaderSection(
                  profile: profile,
                  onEdit: () => _openEditModal(context, profile),
                ),
                const SizedBox(height: 12),
                _ProfileTabsSection(
                  selectedTab: _selectedTab,
                  onTabSelected: (i) => setState(() => _selectedTab = i),
                ),
                const SizedBox(height: 12),
                _ProfileContentSection(
                  selectedTab: _selectedTab,
                  profile: profile,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Edit Modal ─────────────────────────────────────────────────────────────

  void _openEditModal(BuildContext ctx, ProfileEntity profile) {
    final nameCtrl = TextEditingController(text: profile.name);
    final emailCtrl = TextEditingController(text: profile.email ?? '');
    final phoneCtrl = TextEditingController(text: profile.phone);
    final addressCtrl = TextEditingController(text: profile.address ?? '');
    final photoCtrl = TextEditingController(text: profile.photo ?? '');

    showModalBottomSheet<void>(
      context: ctx,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Editar Perfil',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: phoneCtrl,
              decoration: const InputDecoration(labelText: 'Teléfono'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: addressCtrl,
              decoration: const InputDecoration(labelText: 'Dirección'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: photoCtrl,
              decoration: const InputDecoration(labelText: 'URL Foto'),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final updated = profile.copyWith(
                    name: nameCtrl.text.trim(),
                    email: emailCtrl.text.trim().isEmpty
                        ? null
                        : emailCtrl.text.trim(),
                    phone: phoneCtrl.text.trim(),
                    address: addressCtrl.text.trim().isEmpty
                        ? null
                        : addressCtrl.text.trim(),
                    photo: photoCtrl.text.trim().isEmpty
                        ? null
                        : photoCtrl.text.trim(),
                  );
                  ctx.read<ProfileBloc>().add(ProfileUpdateRequested(updated));
                  Navigator.pop(ctx);
                },
                child: const Text('Guardar Cambios'),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────────

class _ProfileHeaderSection extends StatelessWidget {
  const _ProfileHeaderSection({
    required this.profile,
    required this.onEdit,
  });

  final ProfileEntity profile;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            (profile.photo ?? '').isNotEmpty
                ? CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(profile.photo!),
            )
                : CircleAvatar(
              radius: 40,
              backgroundColor:
              Theme.of(context).colorScheme.primaryContainer,
              child: Text(
                profile.initials,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              profile.name,
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
            if ((profile.email ?? '').isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                profile.email!,
                style:
                TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
            ],
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.edit, size: 16),
              label: const Text('Editar Perfil'),
              onPressed: onEdit,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Tabs ──────────────────────────────────────────────────────────────────────

class _ProfileTabsSection extends StatelessWidget {
  const _ProfileTabsSection({
    required this.selectedTab,
    required this.onTabSelected,
  });

  final int selectedTab;
  final ValueChanged<int> onTabSelected;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _tab(context, 'Información', Icons.info_outline, 0),
            _tab(context, 'Estadísticas', Icons.bar_chart, 1),
            _tab(context, 'Cuenta', Icons.settings, 2),
          ],
        ),
      ),
    );
  }

  Widget _tab(
      BuildContext context,
      String label,
      IconData icon,
      int index,
      ) {
    final isSelected = selectedTab == index;
    return OutlinedButton.icon(
      icon: Icon(
        icon,
        color: isSelected
            ? Theme.of(context).colorScheme.onPrimary
            : Colors.black87,
        size: 18,
      ),
      label: Text(
        label,
        style: TextStyle(
          color: isSelected
              ? Theme.of(context).colorScheme.onPrimary
              : Colors.black87,
          fontSize: 13,
        ),
      ),
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected
            ? Theme.of(context).colorScheme.primary
            : Colors.white,
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
        padding:
        const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      ),
      onPressed: () => onTabSelected(index),
    );
  }
}

// ── Content ───────────────────────────────────────────────────────────────────

class _ProfileContentSection extends StatelessWidget {
  const _ProfileContentSection({
    required this.selectedTab,
    required this.profile,
  });

  final int selectedTab;
  final ProfileEntity profile;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    return switch (selectedTab) {
      0 => _infoTab(),
      1 => _placeholderTab('La sección de estadísticas está en desarrollo'),
      2 => _placeholderTab('La sección de manejo de cuenta está en desarrollo'),
      _ => const SizedBox.shrink(),
    };
  }

  Widget _infoTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Información del Usuario',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _infoRow('Nombre', profile.name),
        _infoRow('Email', profile.email ?? ''),
        _infoRow('Teléfono', profile.phone),
        _infoRow('Dirección', profile.address ?? ''),
        if ((profile.country ?? '').isNotEmpty)
          _infoRow('País', profile.country!),
      ],
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              value.isEmpty ? '—' : value,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholderTab(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.construction_outlined,
                size: 48, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }
}