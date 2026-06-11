import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/transaction_entity.dart';
import '../../domain/usecases/transaction_usecases.dart';

part 'transactions_event.dart';
part 'transactions_state.dart';

@injectable
class TransactionsBloc extends Bloc<TransactionsEvent, TransactionsState> {
  TransactionsBloc({
    required GetTransactionsByUserUseCase getTransactionsByUser,
    required CreateTransactionUseCase createTransaction,
    required UpdateTransactionUseCase updateTransaction,
    required DeleteTransactionUseCase deleteTransaction,
  })  : _getTransactionsByUser = getTransactionsByUser,
        _createTransaction = createTransaction,
        _updateTransaction = updateTransaction,
        _deleteTransaction = deleteTransaction,
        super(const TransactionsInitial()) {
    on<TransactionsLoadRequested>(_onLoad);
    on<TransactionsStatusFilterChanged>(_onStatusFilter);
    on<TransactionsPaymentMethodFilterChanged>(_onPaymentMethodFilter);
    on<TransactionsCreateRequested>(_onCreate);
    on<TransactionsUpdateRequested>(_onUpdate);
    on<TransactionsDeleteRequested>(_onDelete);
  }

  final GetTransactionsByUserUseCase _getTransactionsByUser;
  final CreateTransactionUseCase _createTransaction;
  final UpdateTransactionUseCase _updateTransaction;
  final DeleteTransactionUseCase _deleteTransaction;

  // FIX #4: Igual que ContactsBloc — null si no hay sesión, no ''.
  String? get _currentUserId =>
      Supabase.instance.client.auth.currentUser?.id;

  // ── Handlers ──────────────────────────────────────────────────────────────

  Future<void> _onLoad(
    TransactionsLoadRequested event,
    Emitter<TransactionsState> emit,
  ) async {
    final userId = _currentUserId;
    if (userId == null || userId.isEmpty) {
      emit(const TransactionsError('Sesión no disponible. Vuelve a intentarlo.'));
      return;
    }

    emit(const TransactionsLoading());
    final result = await _getTransactionsByUser(
      GetTransactionsByUserParams(userId: userId),
    );
    result.fold(
      (failure) => emit(TransactionsError(failure.message)),
      (transactions) => emit(TransactionsLoaded(transactions)),
    );
  }

  Future<void> _onStatusFilter(
    TransactionsStatusFilterChanged event,
    Emitter<TransactionsState> emit,
  ) async {
    if (state is TransactionsLoaded) {
      emit(
        (state as TransactionsLoaded).copyWith(statusFilter: event.status),
      );
    }
  }

  Future<void> _onPaymentMethodFilter(
    TransactionsPaymentMethodFilterChanged event,
    Emitter<TransactionsState> emit,
  ) async {
    if (state is TransactionsLoaded) {
      emit(
        (state as TransactionsLoaded)
            .copyWith(paymentMethodFilter: event.method),
      );
    }
  }

  Future<void> _onCreate(
    TransactionsCreateRequested event,
    Emitter<TransactionsState> emit,
  ) async {
    if (state is TransactionsLoaded) {
      emit(TransactionsMutating(state as TransactionsLoaded));
    }
    final result = await _createTransaction(
      CreateTransactionParams(transaction: event.transaction),
    );
    result.fold(
      (failure) => emit(TransactionsError(failure.message)),
      (_) => add(const TransactionsLoadRequested()),
    );
  }

  Future<void> _onUpdate(
    TransactionsUpdateRequested event,
    Emitter<TransactionsState> emit,
  ) async {
    if (state is TransactionsLoaded) {
      emit(TransactionsMutating(state as TransactionsLoaded));
    }
    final result = await _updateTransaction(
      UpdateTransactionParams(transaction: event.transaction),
    );
    result.fold(
      (failure) => emit(TransactionsError(failure.message)),
      (_) => add(const TransactionsLoadRequested()),
    );
  }

  Future<void> _onDelete(
    TransactionsDeleteRequested event,
    Emitter<TransactionsState> emit,
  ) async {
    if (state is TransactionsLoaded) {
      emit(TransactionsMutating(state as TransactionsLoaded));
    }
    final result = await _deleteTransaction(
      DeleteTransactionParams(id: event.transactionId),
    );
    result.fold(
      (failure) => emit(TransactionsError(failure.message)),
      (_) => add(const TransactionsLoadRequested()),
    );
  }
}
