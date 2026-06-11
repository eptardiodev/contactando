import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/transaction_entity.dart';
import '../bloc/transactions_bloc.dart';

/// Pantalla de creación de transacción.
/// Se usa como ruta independiente; recibe el [TransactionsBloc] vía contexto.
class TransactionFormWidget extends StatefulWidget {
  const TransactionFormWidget({super.key});

  @override
  State<TransactionFormWidget> createState() => _TransactionFormWidgetState();
}

class _TransactionFormWidgetState extends State<TransactionFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedSenderId;
  String? _selectedReceiverId;
  String _selectedPaymentMethod = 'cash';

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // ── Validation ─────────────────────────────────────────────────────────────

  String? _validateSender(String? v) {
    if (v == null || v.isEmpty) return 'Selecciona quien envía';
    return null;
  }

  String? _validateReceiver(String? v) {
    if (v == null || v.isEmpty) return 'Selecciona quien recibe';
    if (v == _selectedSenderId) return 'No puede enviarse dinero a sí mismo';
    return null;
  }

  String? _validateAmount(String? v) {
    if (v == null || v.isEmpty) return 'El monto es obligatorio';
    final amount = double.tryParse(v);
    if (amount == null || amount <= 0) return 'El monto debe ser mayor a 0';
    if (amount > 10000) return 'El monto no puede exceder €10,000';
    return null;
  }

  // ── Submit ──────────────────────────────────────────────────────────────────

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final transaction = TransactionEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      amount: double.parse(_amountController.text),
      description: _descriptionController.text,
      senderId: _selectedSenderId,
      receiverId: _selectedReceiverId!,
      paymentMethod: _selectedPaymentMethod,
      date: DateTime.now(),
      status: TransactionStatus.pending,
    );

    context
        .read<TransactionsBloc>()
        .add(TransactionsCreateRequested(transaction));

    Navigator.of(context).pop();
  }

  // ── UI ──────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Transacción'),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.send), onPressed: _submit),
        ],
      ),
      body: BlocListener<TransactionsBloc, TransactionsState>(
        listenWhen: (_, curr) => curr is TransactionsError,
        listener: (context, state) {
          if (state is TransactionsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // ── Contactos ───────────────────────────────────────────────
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _ContactDropdown(
                            label: 'Quien envía *',
                            value: _selectedSenderId,
                            onChanged: (v) =>
                                setState(() => _selectedSenderId = v),
                            validator: _validateSender,
                          ),
                          const SizedBox(height: 16),

                          // Arrow preview
                          if (_selectedSenderId != null)
                            _TransferPreviewRow(
                              senderId: _selectedSenderId!,
                              receiverId: _selectedReceiverId,
                            ),
                          if (_selectedSenderId != null)
                            const SizedBox(height: 16),

                          _ContactDropdown(
                            label: 'Quien recibe *',
                            value: _selectedReceiverId,
                            excludeId: _selectedSenderId,
                            onChanged: (v) =>
                                setState(() => _selectedReceiverId = v),
                            validator: _validateReceiver,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Monto y descripción ─────────────────────────────────────
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _FieldLabel(label: 'Monto *'),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _amountController,
                            decoration: const InputDecoration(
                              prefixText: '€',
                              border: OutlineInputBorder(),
                              hintText: '0.00',
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            validator: _validateAmount,
                            onChanged: (_) => setState(() {}),
                          ),
                          const SizedBox(height: 16),
                          _FieldLabel(label: 'Descripción *'),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _descriptionController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Ej: Pago de gastos compartidos...',
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                            maxLines: 3,
                            validator: (v) => (v == null || v.isEmpty)
                                ? 'La descripción es obligatoria'
                                : null,
                            onChanged: (_) => setState(() {}),
                          ),
                          const SizedBox(height: 16),
                          _FieldLabel(label: 'Método de Pago *'),
                          const SizedBox(height: 8),
                          _PaymentMethodDropdown(
                            value: _selectedPaymentMethod,
                            onChanged: (v) => setState(
                              () => _selectedPaymentMethod = v!,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Vista previa ────────────────────────────────────────────
                  if (_selectedSenderId != null &&
                      _selectedReceiverId != null &&
                      _amountController.text.isNotEmpty)
                    _TransactionPreviewCard(
                      senderName: _selectedSenderId!,
                      receiverName: _selectedReceiverId!,
                      amount: double.tryParse(_amountController.text) ?? 0,
                      description: _descriptionController.text,
                      status: TransactionStatus.pending,
                    ),

                  const SizedBox(height: 32),

                  // ── Botones ─────────────────────────────────────────────────
                  _ActionButtons(
                    onCancel: () => Navigator.of(context).pop(),
                    onSave: _submit,
                    saveLabel: 'Crear',
                    saveIcon: Icons.send,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Edit Form Widget
// ─────────────────────────────────────────────────────────────────────────────

/// Pantalla de edición de transacción.
class TransactionEditFormWidget extends StatefulWidget {
  const TransactionEditFormWidget({
    super.key,
    required this.transaction,
  });

  final TransactionEntity transaction;

  @override
  State<TransactionEditFormWidget> createState() =>
      _TransactionEditFormWidgetState();
}

class _TransactionEditFormWidgetState
    extends State<TransactionEditFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();

  late String? _selectedSenderId;
  late String? _selectedReceiverId;
  late String _selectedPaymentMethod;
  late TransactionStatus _selectedStatus;

  @override
  void initState() {
    super.initState();
    final tx = widget.transaction;
    _selectedSenderId = tx.senderId;
    _selectedReceiverId = tx.receiverId;
    _amountController.text = tx.amount.toString();
    _descriptionController.text = tx.description ?? '';
    _selectedPaymentMethod = tx.paymentMethod ?? 'cash';
    _selectedStatus = tx.status;

    final date = tx.date ?? DateTime.now();
    _dateController.text = _formatDate(date);
    _timeController.text = _formatTime(date);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  String _formatTime(DateTime d) =>
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

  String? _validateSender(String? v) {
    if (v == null || v.isEmpty) return 'Selecciona quien envía';
    return null;
  }

  String? _validateReceiver(String? v) {
    if (v == null || v.isEmpty) return 'Selecciona quien recibe';
    if (v == _selectedSenderId) return 'No puede enviarse dinero a sí mismo';
    return null;
  }

  String? _validateAmount(String? v) {
    if (v == null || v.isEmpty) return 'El monto es obligatorio';
    final amount = double.tryParse(v);
    if (amount == null || amount <= 0) return 'El monto debe ser mayor a 0';
    if (amount > 10000) return 'El monto no puede exceder €10,000';
    return null;
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: widget.transaction.date ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && mounted) {
      setState(() => _dateController.text = _formatDate(picked));
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
        widget.transaction.date ?? DateTime.now(),
      ),
    );
    if (picked != null && mounted) {
      setState(() => _timeController.text =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}');
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final dateTime = DateTime.parse(
      '${_dateController.text} ${_timeController.text}:00',
    );

    final updated = widget.transaction.copyWith(
      senderId: _selectedSenderId,
      receiverId: _selectedReceiverId,
      amount: double.parse(_amountController.text),
      description: _descriptionController.text,
      paymentMethod: _selectedPaymentMethod,
      status: _selectedStatus,
      date: dateTime,
    );

    context
        .read<TransactionsBloc>()
        .add(TransactionsUpdateRequested(updated));

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Transacción'),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _submit),
        ],
      ),
      body: BlocListener<TransactionsBloc, TransactionsState>(
        listenWhen: (_, curr) => curr is TransactionsError,
        listener: (context, state) {
          if (state is TransactionsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // ── Contactos ───────────────────────────────────────────────
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _ContactDropdown(
                            label: 'Quien envía *',
                            value: _selectedSenderId,
                            onChanged: (v) =>
                                setState(() => _selectedSenderId = v),
                            validator: _validateSender,
                          ),
                          const SizedBox(height: 16),

                          if (_selectedSenderId != null)
                            _TransferPreviewRow(
                              senderId: _selectedSenderId!,
                              receiverId: _selectedReceiverId,
                            ),
                          if (_selectedSenderId != null)
                            const SizedBox(height: 16),

                          _ContactDropdown(
                            label: 'Quien recibe *',
                            value: _selectedReceiverId,
                            excludeId: _selectedSenderId,
                            onChanged: (v) =>
                                setState(() => _selectedReceiverId = v),
                            validator: _validateReceiver,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Monto y descripción ─────────────────────────────────────
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _FieldLabel(label: 'Monto *'),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _amountController,
                            decoration: const InputDecoration(
                              prefixText: '€',
                              border: OutlineInputBorder(),
                              hintText: '0.00',
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            validator: _validateAmount,
                            onChanged: (_) => setState(() {}),
                          ),
                          const SizedBox(height: 16),
                          _FieldLabel(label: 'Descripción *'),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _descriptionController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Ej: Pago de gastos compartidos...',
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                            maxLines: 3,
                            validator: (v) => (v == null || v.isEmpty)
                                ? 'La descripción es obligatoria'
                                : null,
                            onChanged: (_) => setState(() {}),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Fecha, hora, estado, método ─────────────────────────────
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _FieldLabel(label: 'Fecha *'),
                                    const SizedBox(height: 8),
                                    TextFormField(
                                      controller: _dateController,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
                                      ),
                                      readOnly: true,
                                      onTap: _selectDate,
                                      validator: (v) =>
                                          (v == null || v.isEmpty)
                                              ? 'La fecha es obligatoria'
                                              : null,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _FieldLabel(label: 'Hora *'),
                                    const SizedBox(height: 8),
                                    TextFormField(
                                      controller: _timeController,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
                                      ),
                                      readOnly: true,
                                      onTap: _selectTime,
                                      validator: (v) =>
                                          (v == null || v.isEmpty)
                                              ? 'La hora es obligatoria'
                                              : null,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _FieldLabel(label: 'Estado'),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<TransactionStatus>(
                            value: _selectedStatus,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                            items: TransactionStatus.values
                                .map(
                                  (s) => DropdownMenuItem(
                                    value: s,
                                    child: Text(s.labelEs),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) =>
                                setState(() => _selectedStatus = v!),
                          ),
                          const SizedBox(height: 16),
                          _FieldLabel(label: 'Método de Pago *'),
                          const SizedBox(height: 8),
                          _PaymentMethodDropdown(
                            value: _selectedPaymentMethod,
                            onChanged: (v) => setState(
                              () => _selectedPaymentMethod = v!,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Vista previa ────────────────────────────────────────────
                  if (_selectedSenderId != null &&
                      _selectedReceiverId != null &&
                      _amountController.text.isNotEmpty)
                    _TransactionPreviewCard(
                      senderName: _selectedSenderId!,
                      receiverName: _selectedReceiverId!,
                      amount: double.tryParse(_amountController.text) ?? 0,
                      description: _descriptionController.text,
                      status: _selectedStatus,
                      date: (_dateController.text.isNotEmpty &&
                              _timeController.text.isNotEmpty)
                          ? DateTime.tryParse(
                              '${_dateController.text} ${_timeController.text}:00',
                            )
                          : null,
                    ),

                  const SizedBox(height: 32),

                  _ActionButtons(
                    onCancel: () => Navigator.of(context).pop(),
                    onSave: _submit,
                    saveLabel: 'Guardar',
                    saveIcon: Icons.save,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
    );
  }
}

/// Dropdown genérico de contacto. En la app real recibiría la lista de
/// ContactEntity; aquí usamos un id libre para no acoplar al módulo contacts.
class _ContactDropdown extends StatelessWidget {
  const _ContactDropdown({
    required this.label,
    required this.value,
    required this.onChanged,
    required this.validator,
    this.excludeId,
  });

  final String label;
  final String? value;
  final String? excludeId;
  final ValueChanged<String?> onChanged;
  final FormFieldValidator<String> validator;

  @override
  Widget build(BuildContext context) {
    // NOTE: In the real app you'd inject a list of ContactEntity here.
    // The dropdown is structured so it integrates naturally when contacts
    // are passed from a parent or read via a separate BLoC/provider.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
                const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: value,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'ID del contacto...',
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          onChanged: onChanged,
          validator: validator,
        ),
      ],
    );
  }
}

class _TransferPreviewRow extends StatelessWidget {
  const _TransferPreviewRow({
    required this.senderId,
    required this.receiverId,
  });

  final String senderId;
  final String? receiverId;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _MiniAvatar(label: senderId),
          const SizedBox(width: 16),
          const Icon(Icons.arrow_forward, color: Colors.blue, size: 24),
          const SizedBox(width: 16),
          receiverId != null
              ? _MiniAvatar(label: receiverId!)
              : Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey),
                  ),
                  child: const Icon(Icons.person, color: Colors.grey),
                ),
        ],
      ),
    );
  }
}

class _MiniAvatar extends StatelessWidget {
  const _MiniAvatar({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: Colors.blue[100],
      child: Text(
        label.isNotEmpty ? label[0].toUpperCase() : '?',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.blue[800],
        ),
      ),
    );
  }
}

class _PaymentMethodDropdown extends StatelessWidget {
  const _PaymentMethodDropdown({
    required this.value,
    required this.onChanged,
  });

  final String value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      items: const [
        DropdownMenuItem(value: 'cash', child: Text('💵 Efectivo')),
        DropdownMenuItem(
            value: 'bank_transfer', child: Text('🏦 Transferencia Bancaria')),
        DropdownMenuItem(
            value: 'credit_card', child: Text('💳 Tarjeta de Crédito')),
        DropdownMenuItem(
            value: 'debit_card', child: Text('💳 Tarjeta de Débito')),
        DropdownMenuItem(value: 'paypal', child: Text('📱 PayPal')),
        DropdownMenuItem(value: 'crypto', child: Text('₿ Criptomoneda')),
        DropdownMenuItem(value: 'other', child: Text('⚪ Otro')),
      ],
      onChanged: onChanged,
    );
  }
}

class _TransactionPreviewCard extends StatelessWidget {
  const _TransactionPreviewCard({
    required this.senderName,
    required this.receiverName,
    required this.amount,
    required this.description,
    required this.status,
    this.date,
  });

  final String senderName;
  final String receiverName;
  final double amount;
  final String description;
  final TransactionStatus status;
  final DateTime? date;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Vista previa',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _statusColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status.labelEs,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '$senderName envía €${amount.toStringAsFixed(2)} a $receiverName',
              style: const TextStyle(fontSize: 14),
            ),
            if (description.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                '"$description"',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
            if (date != null) ...[
              const SizedBox(height: 4),
              Text(
                '${date!.day}/${date!.month}/${date!.year} a las '
                '${date!.hour.toString().padLeft(2, '0')}:'
                '${date!.minute.toString().padLeft(2, '0')}',
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color get _statusColor => switch (status) {
        TransactionStatus.completed => Colors.green,
        TransactionStatus.pending => Colors.orange,
        TransactionStatus.failed => Colors.red,
        TransactionStatus.canceled => Colors.grey,
      };
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({
    required this.onCancel,
    required this.onSave,
    required this.saveLabel,
    required this.saveIcon,
  });

  final VoidCallback onCancel;
  final VoidCallback onSave;
  final String saveLabel;
  final IconData saveIcon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: onCancel,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Cancelar'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: onSave,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(saveIcon, size: 20),
                const SizedBox(width: 8),
                Text(saveLabel),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
