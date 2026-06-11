part of 'transactions_bloc.dart';

sealed class TransactionsState extends Equatable {
  const TransactionsState();

  @override
  List<Object?> get props => [];
}

final class TransactionsInitial extends TransactionsState {
  const TransactionsInitial();
}

final class TransactionsLoading extends TransactionsState {
  const TransactionsLoading();
}

final class TransactionsLoaded extends TransactionsState {
  const TransactionsLoaded(
    this.allTransactions, {
    this.statusFilter = 'all',
    this.paymentMethodFilter = 'all',
  });

  final List<TransactionEntity> allTransactions;
  final String statusFilter;
  final String paymentMethodFilter;

  List<TransactionEntity> get filteredTransactions {
    var list = allTransactions;
    if (statusFilter != 'all') {
      list = list.where((t) => t.status.value == statusFilter).toList();
    }
    if (paymentMethodFilter != 'all') {
      list = list
          .where((t) => t.paymentMethod == paymentMethodFilter)
          .toList();
    }
    return list;
  }

  double get totalAmount =>
      filteredTransactions.fold(0.0, (sum, t) => sum + t.amount);

  int get completedCount => filteredTransactions
      .where((t) => t.status == TransactionStatus.completed)
      .length;

  int get pendingCount => filteredTransactions
      .where((t) => t.status == TransactionStatus.pending)
      .length;

  TransactionsLoaded copyWith({
    List<TransactionEntity>? allTransactions,
    String? statusFilter,
    String? paymentMethodFilter,
  }) =>
      TransactionsLoaded(
        allTransactions ?? this.allTransactions,
        statusFilter: statusFilter ?? this.statusFilter,
        paymentMethodFilter: paymentMethodFilter ?? this.paymentMethodFilter,
      );

  @override
  List<Object?> get props => [
        allTransactions,
        statusFilter,
        paymentMethodFilter,
      ];
}

final class TransactionsError extends TransactionsState {
  const TransactionsError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

/// Estado transitorio que indica que se está procesando una mutación
/// (create / update / delete). La UI puede mostrar un indicador.
final class TransactionsMutating extends TransactionsState {
  const TransactionsMutating(this.previous);
  final TransactionsLoaded previous;

  @override
  List<Object?> get props => [previous];
}
