import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../entities/transaction_entity.dart';

abstract interface class TransactionRepository {
  Future<Either<Failure, List<TransactionEntity>>> getTransactionsByUser(
    String userId,
  );

  Future<Either<Failure, List<TransactionEntity>>> getTransactionsBySender(
    String senderId,
  );

  Future<Either<Failure, List<TransactionEntity>>> getTransactionsByReceiver(
    String receiverId,
  );

  Future<Either<Failure, TransactionEntity?>> getTransactionById(String id);

  Future<Either<Failure, TransactionEntity>> createTransaction(
    TransactionEntity transaction,
  );

  Future<Either<Failure, TransactionEntity>> updateTransaction(
    TransactionEntity transaction,
  );

  Future<Either<Failure, bool>> deleteTransaction(String id);
}
