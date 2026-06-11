import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/transaction_entity.dart';
import '../bloc/transactions_bloc.dart';
import '../widgets/transaction_form_widget.dart';
import '../widgets/transaction_list_item_widget.dart';
import '../widgets/transaction_stat_card_widget.dart';
import '../widgets/transaction_filter_bar_widget.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  // FIX #3: Mismo patrón que ContactsPage. didChangeDependencies con guard
  // garantiza que el BlocProvider del shell ya está disponible en el contexto
  // cuando se dispara el evento, y que solo se dispara una vez por instancia.
  bool _loadRequested = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loadRequested) {
      _loadRequested = true;
      context.read<TransactionsBloc>().add(const TransactionsLoadRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    return const _TransactionsView();
  }
}

class _TransactionsView extends StatelessWidget {
  const _TransactionsView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransactionsBloc, TransactionsState>(
      listenWhen: (prev, curr) => curr is TransactionsError,
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
      builder: (context, state) {
        return Scaffold(
          floatingActionButton: _buildFab(context, state),
          body: switch (state) {
            TransactionsInitial() => const Center(
              child: CircularProgressIndicator(),
            ),
            TransactionsLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            TransactionsMutating(:final previous) => _TransactionsContent(
              loaded: previous,
              isMutating: true,
            ),
            TransactionsLoaded() => _TransactionsContent(
              loaded: state,
              isMutating: false,
            ),
            TransactionsError() => _TransactionsErrorView(
              message: state.message,
              onRetry: () => context
                  .read<TransactionsBloc>()
                  .add(const TransactionsLoadRequested()),
            ),
          },
        );
      },
    );
  }

  Widget? _buildFab(BuildContext context, TransactionsState state) {
    final isEnabled =
        state is TransactionsLoaded || state is TransactionsMutating;
    return FloatingActionButton(
      backgroundColor: isEnabled ? Theme.of(context).primaryColor : Colors.grey,
      onPressed: isEnabled ? () => _openCreateForm(context) : null,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: Icon(Icons.add, color: Theme.of(context).primaryColor),
      ),
    );
  }

  void _openCreateForm(BuildContext context) {
    final bloc = context.read<TransactionsBloc>();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider.value(
          value: bloc,
          child: const TransactionFormWidget(),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Content
// ─────────────────────────────────────────────────────────────────────────────

class _TransactionsContent extends StatelessWidget {
  const _TransactionsContent({
    required this.loaded,
    required this.isMutating,
  });

  final TransactionsLoaded loaded;
  final bool isMutating;

  @override
  Widget build(BuildContext context) {
    final transactions = loaded.filteredTransactions;

    return Stack(
      children: [
        Column(
          children: [
            // Stats Row
            Padding(
              padding: const EdgeInsets.fromLTRB(6, 6, 6, 0),
              child: Row(
                children: [
                  Expanded(
                    child: TransactionStatCardWidget(
                      title: 'Total',
                      value: '€${loaded.totalAmount.toStringAsFixed(2)}',
                      icon: Icons.euro,
                      color: Colors.green,
                    ),
                  ),
                  Expanded(
                    child: TransactionStatCardWidget(
                      title: 'Completadas',
                      value: loaded.completedCount.toString(),
                      icon: Icons.check_circle,
                      color: Colors.blue,
                    ),
                  ),
                  Expanded(
                    child: TransactionStatCardWidget(
                      title: 'Pendientes',
                      value: loaded.pendingCount.toString(),
                      icon: Icons.pending,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ),

            // Filter Bar
            TransactionFilterBarWidget(
              currentStatusFilter: loaded.statusFilter,
              currentPaymentMethodFilter: loaded.paymentMethodFilter,
            ),

            // List
            Expanded(
              child: transactions.isEmpty
                  ? _EmptyView(
                hasFilters: loaded.statusFilter != 'all' ||
                    loaded.paymentMethodFilter != 'all',
              )
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  return TransactionListItemWidget(
                    transaction: transactions[index],
                    onEdit: () =>
                        _openEditForm(context, transactions[index]),
                    onDelete: () =>
                        _confirmDelete(context, transactions[index]),
                  );
                },
              ),
            ),
          ],
        ),

        // Mutating overlay
        if (isMutating)
          const Positioned.fill(
            child: ColoredBox(
              color: Color(0x33000000),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
      ],
    );
  }

  void _openEditForm(BuildContext context, TransactionEntity transaction) {
    final bloc = context.read<TransactionsBloc>();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider.value(
          value: bloc,
          child: TransactionEditFormWidget(transaction: transaction),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, TransactionEntity transaction) {
    final messenger = ScaffoldMessenger.of(context);
    final bloc = context.read<TransactionsBloc>();

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar transacción'),
        content: const Text(
          '¿Estás seguro de que quieres eliminar esta transacción?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              bloc.add(TransactionsDeleteRequested(transaction.id));
              messenger.showSnackBar(
                const SnackBar(content: Text('Transacción eliminada')),
              );
            },
            child: const Text(
              'Eliminar',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Empty State
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.hasFilters});

  final bool hasFilters;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.swap_horiz, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            hasFilters
                ? 'No hay transacciones con los filtros actuales'
                : 'No hay transacciones',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          if (hasFilters)
            TextButton(
              onPressed: () {
                context.read<TransactionsBloc>()
                  ..add(const TransactionsStatusFilterChanged('all'))
                  ..add(const TransactionsPaymentMethodFilterChanged('all'));
              },
              child: const Text('Limpiar filtros'),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Error State
// ─────────────────────────────────────────────────────────────────────────────

class _TransactionsErrorView extends StatelessWidget {
  const _TransactionsErrorView({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
