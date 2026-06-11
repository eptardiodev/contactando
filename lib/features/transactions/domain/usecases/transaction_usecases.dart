import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/use_case.dart';
import '../entities/transaction_entity.dart';
import '../repositories/transaction_repository.dart';

// ─────────────────────────────────────────────────────────────────────────────
// GetTransactionsByUserUseCase
// ─────────────────────────────────────────────────────────────────────────────

class GetTransactionsByUserParams {
  const GetTransactionsByUserParams({required this.userId});
  final String userId;
}

@injectable
class GetTransactionsByUserUseCase
    extends UseCase<List<TransactionEntity>, GetTransactionsByUserParams> {
  GetTransactionsByUserUseCase(this._repository);
  final TransactionRepository _repository;

  @override
  Future<Either<Failure, List<TransactionEntity>>> call(
    GetTransactionsByUserParams params,
  ) =>
      _repository.getTransactionsByUser(params.userId);
}

// ─────────────────────────────────────────────────────────────────────────────
// GetTransactionByIdUseCase
// ─────────────────────────────────────────────────────────────────────────────

class GetTransactionByIdParams {
  const GetTransactionByIdParams({required this.id});
  final String id;
}

@injectable
class GetTransactionByIdUseCase
    extends UseCase<TransactionEntity?, GetTransactionByIdParams> {
  GetTransactionByIdUseCase(this._repository);
  final TransactionRepository _repository;

  @override
  Future<Either<Failure, TransactionEntity?>> call(
    GetTransactionByIdParams params,
  ) =>
      _repository.getTransactionById(params.id);
}

// ─────────────────────────────────────────────────────────────────────────────
// CreateTransactionUseCase
// ─────────────────────────────────────────────────────────────────────────────

class CreateTransactionParams {
  const CreateTransactionParams({required this.transaction});
  final TransactionEntity transaction;
}

@injectable
class CreateTransactionUseCase
    extends UseCase<TransactionEntity, CreateTransactionParams> {
  CreateTransactionUseCase(this._repository);
  final TransactionRepository _repository;

  @override
  Future<Either<Failure, TransactionEntity>> call(
    CreateTransactionParams params,
  ) =>
      _repository.createTransaction(params.transaction);
}

// ─────────────────────────────────────────────────────────────────────────────
// UpdateTransactionUseCase
// ─────────────────────────────────────────────────────────────────────────────

class UpdateTransactionParams {
  const UpdateTransactionParams({required this.transaction});
  final TransactionEntity transaction;
}

@injectable
class UpdateTransactionUseCase
    extends UseCase<TransactionEntity, UpdateTransactionParams> {
  UpdateTransactionUseCase(this._repository);
  final TransactionRepository _repository;

  @override
  Future<Either<Failure, TransactionEntity>> call(
    UpdateTransactionParams params,
  ) =>
      _repository.updateTransaction(params.transaction);
}

// ─────────────────────────────────────────────────────────────────────────────
// DeleteTransactionUseCase
// ─────────────────────────────────────────────────────────────────────────────

class DeleteTransactionParams {
  const DeleteTransactionParams({required this.id});
  final String id;
}

@injectable
class DeleteTransactionUseCase
    extends UseCase<bool, DeleteTransactionParams> {
  DeleteTransactionUseCase(this._repository);
  final TransactionRepository _repository;

  @override
  Future<Either<Failure, bool>> call(DeleteTransactionParams params) =>
      _repository.deleteTransaction(params.id);
}
