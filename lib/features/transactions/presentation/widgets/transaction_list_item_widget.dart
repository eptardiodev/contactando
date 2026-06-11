import 'package:flutter/material.dart';

import '../../domain/entities/transaction_entity.dart';

class TransactionListItemWidget extends StatelessWidget {
  const TransactionListItemWidget({
    super.key,
    required this.transaction,
    required this.onEdit,
    required this.onDelete,
  });

  final TransactionEntity transaction;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Header Row
            Row(
              children: [
                _ContactAvatar(contactId: transaction.senderId ?? ''),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction.senderId ?? 'Desconocido',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '→ ${transaction.receiverId}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '€${transaction.amount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _StatusBadge(status: transaction.status),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Description
            if (transaction.description != null &&
                transaction.description!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    transaction.description!,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),

            // Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(transaction.date ?? DateTime.now()),
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
                Row(
                  children: [
                    _PaymentMethodIcon(method: transaction.paymentMethod),
                    const SizedBox(width: 4),
                    Text(
                      _paymentMethodLabel(transaction.paymentMethod),
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => _showOptions(context),
                      child: Icon(
                        Icons.more_vert,
                        size: 16,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.blue),
              title: const Text('Editar transacción'),
              onTap: () {
                Navigator.pop(context);
                onEdit();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Eliminar transacción'),
              onTap: () {
                Navigator.pop(context);
                onDelete();
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final txDate = DateTime(date.year, date.month, date.day);

    if (txDate == today) return 'Hoy';
    if (txDate == yesterday) return 'Ayer';
    return '${date.day}/${date.month}/${date.year}';
  }

  String _paymentMethodLabel(String? method) {
    const labels = {
      'cash': 'Efectivo',
      'bank_transfer': 'Transferencia',
      'credit_card': 'Tarjeta Crédito',
      'debit_card': 'Tarjeta Débito',
      'paypal': 'PayPal',
      'crypto': 'Cripto',
    };
    return labels[method] ?? 'Otro';
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

class _ContactAvatar extends StatelessWidget {
  const _ContactAvatar({required this.contactId});
  final String contactId;

  @override
  Widget build(BuildContext context) {
    final initials =
        contactId.isNotEmpty ? contactId[0].toUpperCase() : '?';
    return CircleAvatar(
      radius: 20,
      backgroundColor: Colors.blue[100],
      child: Text(
        initials,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.blue[800],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final TransactionStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.labelEs,
        style: const TextStyle(
          fontSize: 10,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Color get _color => switch (status) {
        TransactionStatus.completed => Colors.green,
        TransactionStatus.pending => Colors.orange,
        TransactionStatus.failed => Colors.red,
        TransactionStatus.canceled => Colors.grey,
      };
}

class _PaymentMethodIcon extends StatelessWidget {
  const _PaymentMethodIcon({required this.method});
  final String? method;

  @override
  Widget build(BuildContext context) {
    return switch (method) {
      'cash' => Icon(Icons.attach_money, size: 14, color: Colors.green),
      'bank_transfer' =>
        Icon(Icons.account_balance, size: 14, color: Colors.blue),
      'credit_card' => Icon(Icons.credit_card, size: 14, color: Colors.purple),
      'debit_card' => Icon(Icons.credit_card, size: 14, color: Colors.orange),
      'paypal' => Icon(Icons.payment, size: 14, color: Colors.blue),
      'crypto' => Icon(Icons.currency_bitcoin, size: 14, color: Colors.amber),
      _ => Icon(Icons.euro, size: 14, color: Colors.grey),
    };
  }
}
