part of 'transactions_bloc.dart';

sealed class TransactionsEvent extends Equatable {
  const TransactionsEvent();

  @override
  List<Object?> get props => [];
}

/// Carga todas las transacciones del usuario autenticado.
final class TransactionsLoadRequested extends TransactionsEvent {
  const TransactionsLoadRequested();
}

/// Filtra por estado (pending / completed / failed / canceled / all).
final class TransactionsStatusFilterChanged extends TransactionsEvent {
  const TransactionsStatusFilterChanged(this.status);
  final String status; // 'all' o TransactionStatus.value

  @override
  List<Object?> get props => [status];
}

/// Filtra por método de pago.
final class TransactionsPaymentMethodFilterChanged extends TransactionsEvent {
  const TransactionsPaymentMethodFilterChanged(this.method);
  final String method; // 'all' o valor concreto

  @override
  List<Object?> get props => [method];
}

/// Crea una nueva transacción.
final class TransactionsCreateRequested extends TransactionsEvent {
  const TransactionsCreateRequested(this.transaction);
  final TransactionEntity transaction;

  @override
  List<Object?> get props => [transaction];
}

/// Actualiza una transacción existente.
final class TransactionsUpdateRequested extends TransactionsEvent {
  const TransactionsUpdateRequested(this.transaction);
  final TransactionEntity transaction;

  @override
  List<Object?> get props => [transaction];
}

/// Elimina una transacción.
final class TransactionsDeleteRequested extends TransactionsEvent {
  const TransactionsDeleteRequested(this.transactionId);
  final String transactionId;

  @override
  List<Object?> get props => [transactionId];
}
