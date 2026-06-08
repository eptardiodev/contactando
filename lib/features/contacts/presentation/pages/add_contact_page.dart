import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/di/injection.dart';
import '../../domain/entities/contact_entity.dart';
import '../../domain/usecases/contact_usecases.dart';
import '../bloc/contacts_bloc.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AddContactBloc (local a esta pantalla — no necesita injectable global)
// ─────────────────────────────────────────────────────────────────────────────

part 'add_contact_page.bloc.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Page
// ─────────────────────────────────────────────────────────────────────────────

/// Provee el BLoC y dispara la carga de datos del formulario.
class AddContactPage extends StatelessWidget {
  const AddContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = Supabase.instance.client.auth.currentUser?.id ?? '';
    return BlocProvider(
      create: (_) => AddContactBloc(
        createContact: getIt<CreateContactUseCase>(),
        getUniqueCountries: getIt<GetUniqueCountriesUseCase>(),
      )..add(AddContactFormLoaded(userId)),
      child: _AddContactView(ownerUserId: userId),
    );
  }
}

// ── View ──────────────────────────────────────────────────────────────────────

class _AddContactView extends StatefulWidget {
  const _AddContactView({required this.ownerUserId});
  final String ownerUserId;

  @override
  State<_AddContactView> createState() => _AddContactViewState();
}

class _AddContactViewState extends State<_AddContactView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _notesController = TextEditingController();
  final _addressController = TextEditingController();
  String? _selectedCountry;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _notesController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddContactBloc, AddContactFormState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: (context, state) {
        if (state.status == AddContactFormStatus.success) {
          context.pop(true); // go_router pop con resultado
        }
        if (state.status == AddContactFormStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Error desconocido'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Agregar Contacto'),
            actions: [
              TextButton(
                onPressed: state.status == AddContactFormStatus.loading
                    ? null
                    : _save,
                child: state.status == AddContactFormStatus.loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child:
                            CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('GUARDAR'),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildPhotoSection(),
                  const SizedBox(height: 24),
                  _buildTextField(
                    controller: _nameController,
                    label: 'Nombre *',
                    validator: _required,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _phoneController,
                    label: 'Teléfono *',
                    keyboardType: TextInputType.phone,
                    validator: _required,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _emailController,
                    label: 'Email',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  _buildCountryDropdown(state.countries),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _addressController,
                    label: 'Dirección',
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _notesController,
                    label: 'Notas',
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ── Widgets ───────────────────────────────────────────────────────────────

  Widget _buildPhotoSection() {
    return CircleAvatar(
      radius: 60,
      backgroundColor: Colors.grey.shade200,
      child: const Icon(Icons.camera_alt, size: 40, color: Colors.grey),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: validator,
    );
  }

  Widget _buildCountryDropdown(List<String> countries) {
    return InputDecorator(
      decoration: const InputDecoration(
        labelText: 'País',
        border: OutlineInputBorder(),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCountry,
          hint: const Text('Seleccionar país'),
          isExpanded: true,
          items: countries
              .map((c) => DropdownMenuItem(value: c, child: Text(c)))
              .toList(),
          onChanged: (value) => setState(() => _selectedCountry = value),
        ),
      ),
    );
  }

  // ── Logic ─────────────────────────────────────────────────────────────────

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Campo requerido' : null;

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final contact = ContactEntity(
      id: '', // El datasource ignora id en INSERT
      ownerUserId: widget.ownerUserId,
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim().isEmpty
          ? null
          : _emailController.text.trim(),
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      address: _addressController.text.trim().isEmpty
          ? null
          : _addressController.text.trim(),
      country: _selectedCountry,
      isContactRole: true,
    );

    context.read<AddContactBloc>().add(AddContactSubmitted(contact));
  }
}
