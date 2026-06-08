import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/di/injection.dart';
import '../../domain/entities/contact_entity.dart';
import '../bloc/contact_detail_bloc.dart';

/// Recibe el [ContactEntity] completo via GoRouter `extra`.
/// Si `extra` es null intenta cargar por ID (future use).
class ContactDetailPage extends StatelessWidget {
  const ContactDetailPage({
    required this.contactId,
    this.contact,
    super.key,
  });

  final String contactId;
  final ContactEntity? contact;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final bloc = getIt<ContactDetailBloc>();
        if (contact != null) {
          bloc.add(ContactDetailLoaded(contact!));
        }
        return bloc;
      },
      child: const _ContactDetailView(),
    );
  }
}

// ── View ──────────────────────────────────────────────────────────────────────

class _ContactDetailView extends StatefulWidget {
  const _ContactDetailView();

  @override
  State<_ContactDetailView> createState() => _ContactDetailViewState();
}

class _ContactDetailViewState extends State<_ContactDetailView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ContactDetailBloc, ContactDetailState>(
      listenWhen: (p, c) => c is ContactDetailDeleted || c is ContactDetailError,
      listener: (context, state) {
        if (state is ContactDetailDeleted) {
          // Notificar a la lista para que recargue
          context.pop(true);
        }
        if (state is ContactDetailError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is ContactDetailInitial ||
            state is ContactDetailDeleting ||
            state is ContactDetailDeleted) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final contact = switch (state) {
          ContactDetailSuccess s => s.contact,
          ContactDetailUpdating s => s.contact,
          ContactDetailError s => s.contact,
          _ => null,
        };

        if (contact == null) {
          return const Scaffold(
            body: Center(child: Text('No se pudo cargar el contacto.')),
          );
        }

        return Scaffold(
          backgroundColor: Colors.grey.shade50,
          appBar: _buildAppBar(context, contact),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                _ContactInfoCard(contact: contact),
                const SizedBox(height: 8),
                _buildTabSection(contact),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── AppBar ─────────────────────────────────────────────────────────────────

  AppBar _buildAppBar(BuildContext context, ContactEntity contact) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: const Text(
        'Detalles del Contacto',
        style: TextStyle(
            color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => context.pop(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit_outlined, color: Colors.black87),
          onPressed: () => _onEdit(context, contact),
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: () => _showDeleteDialog(context),
        ),
      ],
    );
  }

  // ── Tab section ────────────────────────────────────────────────────────────

  Widget _buildTabSection(ContactEntity contact) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      shadowColor: Colors.black12,
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelPadding: EdgeInsets.zero,
            dividerColor: Colors.transparent,
            indicatorColor: Colors.black87,
            labelColor: Colors.black87,
            unselectedLabelColor: Colors.grey.shade500,
            labelStyle:
                const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            tabs: const [
              Tab(text: 'Relaciones'),
              Tab(text: 'Transacciones'),
              Tab(text: 'Recordatorios'),
            ],
          ),
          const Divider(height: 1),
          SizedBox(
            height: 300,
            child: TabBarView(
              controller: _tabController,
              children: [
                _PlaceholderTab(
                  icon: Icons.people_outline,
                  message: 'No hay relaciones registradas',
                  actionLabel: 'Agregar',
                  onAction: () {
                    // TODO: navegar a agregar relación cuando el feature exista
                  },
                ),
                const _PlaceholderTab(
                  icon: Icons.swap_horiz_outlined,
                  message: 'No hay transacciones registradas',
                ),
                const _PlaceholderTab(
                  icon: Icons.access_time_outlined,
                  message: 'No hay recordatorios activos',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Actions ────────────────────────────────────────────────────────────────

  void _onEdit(BuildContext context, ContactEntity contact) {
    // TODO: navegar a EditContactPage cuando exista
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edición próximamente')),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('¿Eliminar contacto?'),
        content: const Text(
          'Esta acción no se puede deshacer. Se eliminarán también todas '
          'las relaciones y transacciones asociadas.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context
                  .read<ContactDetailBloc>()
                  .add(const ContactDetailDeleteRequested());
            },
            child:
                const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

// ── Contact Info Card ─────────────────────────────────────────────────────────

class _ContactInfoCard extends StatelessWidget {
  const _ContactInfoCard({required this.contact});
  final ContactEntity contact;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      shadowColor: Colors.black12,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Avatar
            _buildAvatar(),
            const SizedBox(height: 12),
            Text(
              contact.name,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            if ((contact.email ?? '').isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                contact.email!,
                style: TextStyle(
                    fontSize: 13, color: Colors.grey.shade600),
              ),
            ],
            const SizedBox(height: 16),
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: _SquareButton(
                    icon: Icons.phone_outlined,
                    label: 'Llamar',
                    onPressed: () => _makePhoneCall(context, contact.phone),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _SquareButton(
                    icon: Icons.message_outlined,
                    label: 'SMS',
                    onPressed: () => _sendSMS(context, contact.phone),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _SquareButton(
                    icon: Icons.chat_outlined,
                    label: 'WhatsApp',
                    onPressed: () => _openWhatsApp(context, contact.phone),
                  ),
                ),
                if ((contact.email ?? '').isNotEmpty) ...[
                  const SizedBox(width: 8),
                  Expanded(
                    child: _SquareButton(
                      icon: Icons.email_outlined,
                      label: 'Email',
                      onPressed: () =>
                          _sendEmail(context, contact.email!),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            // Info rows
            if (contact.phone.isNotEmpty)
              _InfoRow(icon: Icons.phone_outlined, text: contact.phone),
            if ((contact.address ?? '').isNotEmpty) ...[
              const SizedBox(height: 8),
              _InfoRow(
                  icon: Icons.location_on_outlined, text: contact.address!),
            ],
            if ((contact.country ?? '').isNotEmpty) ...[
              const SizedBox(height: 8),
              _InfoRow(icon: Icons.flag_outlined, text: contact.country!),
            ],
            if ((contact.notes ?? '').isNotEmpty) ...[
              const SizedBox(height: 8),
              _InfoRow(icon: Icons.notes_outlined, text: contact.notes!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    if ((contact.photo ?? '').isNotEmpty) {
      return CircleAvatar(
        radius: 40,
        backgroundImage: NetworkImage(contact.photo!),
      );
    }
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade100,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          contact.initials,
          style: TextStyle(
            fontSize: contact.initials.length > 1 ? 22 : 28,
            fontWeight: FontWeight.w700,
            color: Colors.blueGrey.shade700,
          ),
        ),
      ),
    );
  }

  Future<void> _makePhoneCall(BuildContext context, String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _sendSMS(BuildContext context, String phone) async {
    final uri = Uri(scheme: 'sms', path: phone);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _openWhatsApp(BuildContext context, String phone) async {
    final cleaned = phone.replaceAll(RegExp(r'[^0-9]'), '');
    final uri = Uri.parse('https://wa.me/$cleaned');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _sendEmail(BuildContext context, String email) async {
    final uri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

// ── Info Row ──────────────────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade500),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
          ),
        ),
      ],
    );
  }
}

// ── Square Button ─────────────────────────────────────────────────────────────

class _SquareButton extends StatelessWidget {
  const _SquareButton({
    required this.icon,
    required this.label,
    this.onPressed,
  });
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: BorderSide(color: Colors.grey.shade300),
        padding: const EdgeInsets.symmetric(vertical: 8),
        foregroundColor: Colors.black87,
      ),
      onPressed: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }
}

// ── Placeholder Tab ───────────────────────────────────────────────────────────

class _PlaceholderTab extends StatelessWidget {
  const _PlaceholderTab({
    required this.icon,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (actionLabel != null)
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                icon: const Icon(Icons.add, size: 16),
                label: Text(actionLabel!),
                onPressed: onAction,
              ),
            ),
          const Spacer(),
          Icon(icon, size: 48, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          Text(
            message,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
