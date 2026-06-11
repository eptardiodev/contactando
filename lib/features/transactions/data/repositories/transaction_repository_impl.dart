import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/transaction_remote_datasource.dart';
import '../models/transaction_model.dart';

@Injectable(as: TransactionRepository)
class TransactionRepositoryImpl implements TransactionRepository {
  const TransactionRepositoryImpl(this._datasource);
  final TransactionRemoteDatasource _datasource;

  Either<Failure, T> _handleException<T>(Object e) {
    if (e is AppException) return left(ServerFailure(e.message));
    return left(ServerFailure(e.toString()));
  }

  @override
  Future<Either<Failure, List<TransactionEntity>>> getTransactionsByUser(
    String userId,
  ) async {
    try {
      final sent = await _datasource.getTransactionsBySender(userId);
      final received = await _datasource.getTransactionsByReceiver(userId);

      // Merge & dedup by id, then sort by date desc
      final map = <String, TransactionModel>{};
      for (final t in [...sent, ...received]) {
        map[t.id] = t;
      }
      final sorted = map.values.toList()
        ..sort((a, b) {
          final da = a.date ?? DateTime(0);
          final db = b.date ?? DateTime(0);
          return db.compareTo(da);
        });

      return right(sorted.map((m) => m.toEntity()).toList());
    } catch (e) {
      return _handleException(e);
    }
  }

  @override
  Future<Either<Failure, List<TransactionEntity>>> getTransactionsBySender(
    String senderId,
  ) async {
    try {
      final models = await _datasource.getTransactionsBySender(senderId);
      return right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return _handleException(e);
    }
  }

  @override
  Future<Either<Failure, List<TransactionEntity>>> getTransactionsByReceiver(
    String receiverId,
  ) async {
    try {
      final models = await _datasource.getTransactionsByReceiver(receiverId);
      return right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return _handleException(e);
    }
  }

  @override
  Future<Either<Failure, TransactionEntity?>> getTransactionById(
    String id,
  ) async {
    try {
      final model = await _datasource.getTransactionById(id);
      return right(model?.toEntity());
    } catch (e) {
      return _handleException(e);
    }
  }

  @override
  Future<Either<Failure, TransactionEntity>> createTransaction(
    TransactionEntity transaction,
  ) async {
    try {
      final model = TransactionModel.fromEntity(transaction);
      return right((await _datasource.createTransaction(model)).toEntity());
    } catch (e) {
      return _handleException(e);
    }
  }

  @override
  Future<Either<Failure, TransactionEntity>> updateTransaction(
    TransactionEntity transaction,
  ) async {
    try {
      final model = TransactionModel.fromEntity(transaction);
      return right((await _datasource.updateTransaction(model)).toEntity());
    } catch (e) {
      return _handleException(e);
    }
  }

  @override
  Future<Either<Failure, bool>> deleteTransaction(String id) async {
    try {
      return right(await _datasource.deleteTransaction(id));
    } catch (e) {
      return _handleException(e);
    }
  }
}
