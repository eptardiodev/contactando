import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/transactions_bloc.dart';

class TransactionFilterBarWidget extends StatefulWidget {
  const TransactionFilterBarWidget({
    super.key,
    required this.currentStatusFilter,
    required this.currentPaymentMethodFilter,
  });

  final String currentStatusFilter;
  final String currentPaymentMethodFilter;

  @override
  State<TransactionFilterBarWidget> createState() =>
      _TransactionFilterBarWidgetState();
}

class _TransactionFilterBarWidgetState
    extends State<TransactionFilterBarWidget> {
  bool _showFilters = false;

  bool get _hasActiveFilters =>
      widget.currentStatusFilter != 'all' ||
      widget.currentPaymentMethodFilter != 'all';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () =>
                      setState(() => _showFilters = !_showFilters),
                  icon: const Icon(Icons.filter_list, size: 18),
                  label: const Text('Filtros'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _hasActiveFilters ? Colors.blue : null,
                    side: BorderSide(
                      color: _hasActiveFilters ? Colors.blue : Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_showFilters)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildStatusChip('Todos', 'all'),
                _buildStatusChip('Completadas', 'completed'),
                _buildStatusChip('Pendientes', 'pending'),
                _buildStatusChip('Fallidas', 'failed'),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildStatusChip(String label, String value) {
    final selected = widget.currentStatusFilter == value;
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => context
          .read<TransactionsBloc>()
          .add(TransactionsStatusFilterChanged(value)),
      backgroundColor: selected ? Colors.blue[50] : null,
      selectedColor: Colors.blue[100],
      checkmarkColor: Colors.blue,
    );
  }
}
