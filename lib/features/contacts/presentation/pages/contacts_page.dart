import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../domain/entities/contact_entity.dart';
import '../bloc/contacts_bloc.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ContactsView();
  }
}

// ── View ──────────────────────────────────────────────────────────────────────

class _ContactsView extends StatefulWidget {
  const _ContactsView();

  @override
  State<_ContactsView> createState() => _ContactsViewState();
}

class _ContactsViewState extends State<_ContactsView> {
  final _searchController = TextEditingController();

  // FIX #3: Usamos didChangeDependencies con un guard en vez de initState.
  // initState se ejecuta antes de que el BuildContext tenga acceso al BlocProvider
  // cuando el widget es reconstruido por GoRouter. didChangeDependencies se ejecuta
  // después del primer build y cada vez que una dependencia del contexto cambia,
  // garantizando que context.read<ContactsBloc>() ya está disponible.
  bool _loadRequested = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loadRequested) {
      _loadRequested = true;
      context.read<ContactsBloc>().add(const ContactsLoadRequested());
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black87,
        onPressed: _navigateToAddContact,
        child: const Icon(Icons.person_add_alt_1, color: Colors.white),
      ),
    );
  }

  // ── Body ───────────────────────────────────────────────────────────────────

  Widget _buildBody() {
    return BlocConsumer<ContactsBloc, ContactsState>(
      listenWhen: (previous, current) =>
      current is ContactsError && previous is! ContactsError,
      listener: (context, state) {
        if (state is ContactsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is ContactsLoading || state is ContactsInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        final contacts = state is ContactsLoaded ? state.allContacts : <ContactEntity>[];
        final isSearching = state is ContactsLoaded && state.isSearching;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchRow(),
            _buildResultsCount(contacts.length, isSearching),
            Expanded(
              child: contacts.isEmpty
                  ? _EmptyState(
                isSearching: _searchController.text.trim().isNotEmpty,
                onCreateFirst: _navigateToAddContact,
              )
                  : ListView.builder(
                padding: const EdgeInsets.only(top: 4, bottom: 80),
                itemCount: contacts.length,
                itemBuilder: (context, index) =>
                    _ContactCard(contact: contacts[index]),
              ),
            ),
          ],
        );
      },
    );
  }

  // ── Search row ─────────────────────────────────────────────────────────────

  Widget _buildSearchRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: _SearchField(
        controller: _searchController,
        onChanged: (query) {
          context.read<ContactsBloc>().add(ContactsSearchChanged(query));
        },
        onCleared: () {
          context.read<ContactsBloc>().add(const ContactsSearchCleared());
        },
      ),
    );
  }

  Widget _buildResultsCount(int count, bool isSearching) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
      child: Row(
        children: [
          Text(
            '$count contacto${count != 1 ? 's' : ''} encontrado${count != 1 ? 's' : ''}',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
          ),
          if (isSearching) ...[
            const SizedBox(width: 8),
            const SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(strokeWidth: 1.5),
            ),
          ],
        ],
      ),
    );
  }

  // ── Navigation ─────────────────────────────────────────────────────────────

  void _navigateToAddContact() {
    context.pushNamed(AppRoutes.contactAddName).then((result) {
      if (result == true && mounted) {
        _searchController.clear();
        context.read<ContactsBloc>().add(const ContactsLoadRequested());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Contacto agregado')),
        );
      }
    });
  }
}

// ── Search Field ──────────────────────────────────────────────────────────────

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.onChanged,
    required this.onCleared,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onCleared;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: 'Buscar contactos...',
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        prefixIcon: Icon(Icons.search, color: Colors.grey.shade400, size: 20),
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (_, value, __) => value.text.isEmpty
              ? const SizedBox.shrink()
              : IconButton(
            icon: Icon(Icons.clear,
                size: 16, color: Colors.grey.shade400),
            onPressed: () {
              controller.clear();
              onCleared();
            },
          ),
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding:
        const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

// ── Empty State ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.isSearching, required this.onCreateFirst});

  final bool isSearching;
  final VoidCallback onCreateFirst;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.people_outline, size: 56, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              isSearching
                  ? 'No se encontraron contactos que\ncoincidan con tu búsqueda.'
                  : 'No hay contactos registrados.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
            ),
            if (!isSearching) ...[
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Crear primer contacto'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                onPressed: onCreateFirst,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Contact Card ──────────────────────────────────────────────────────────────

class _ContactCard extends StatelessWidget {
  const _ContactCard({required this.contact});

  final ContactEntity contact;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade100),
      ),
      elevation: 1,
      shadowColor: Colors.black12,
      child: ListTile(
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: _buildAvatar(),
        title: _buildTitle(),
        subtitle: _buildSubtitle(),
        onTap: () => context.pushNamed(
          AppRoutes.contactDetailName,
          pathParameters: {'id': contact.id},
          extra: contact,
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    if ((contact.photo ?? '').isNotEmpty) {
      return CircleAvatar(
        radius: 23,
        backgroundImage: NetworkImage(contact.photo!),
      );
    }
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade100,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          contact.initials,
          style: TextStyle(
            fontSize: contact.initials.length > 1 ? 14 : 18,
            fontWeight: FontWeight.w700,
            color: Colors.blueGrey.shade700,
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      contact.name,
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildSubtitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 6),
        _IconRow(icon: Icons.phone_outlined, text: contact.phone),
        if ((contact.email ?? '').isNotEmpty) ...[
          const SizedBox(height: 3),
          _IconRow(
            icon: Icons.email_outlined,
            text: contact.email!,
            expanded: true,
          ),
        ],
        if (contact.createdAt != null) ...[
          const SizedBox(height: 5),
          Text(
            'Creado: ${_formatDate(contact.createdAt!)}',
            style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
          ),
        ],
      ],
    );
  }

  String _formatDate(DateTime d) => '${d.day}/${d.month}/${d.year}';
}

// ── Icon Row ──────────────────────────────────────────────────────────────────

class _IconRow extends StatelessWidget {
  const _IconRow({
    required this.icon,
    required this.text,
    this.expanded = false,
  });

  final IconData icon;
  final String text;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final textWidget = Text(
      text,
      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
      overflow: expanded ? TextOverflow.ellipsis : null,
    );
    return Row(
      children: [
        Icon(icon, size: 13, color: Colors.grey.shade500),
        const SizedBox(width: 5),
        expanded ? Expanded(child: textWidget) : textWidget,
      ],
    );
  }
}
