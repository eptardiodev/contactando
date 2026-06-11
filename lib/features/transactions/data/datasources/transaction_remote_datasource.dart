import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/remote_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/transaction_model.dart';

abstract interface class TransactionRemoteDatasource {
  Future<List<TransactionModel>> getTransactionsBySender(String senderId);
  Future<List<TransactionModel>> getTransactionsByReceiver(String receiverId);
  Future<TransactionModel?> getTransactionById(String id);
  Future<TransactionModel> createTransaction(TransactionModel transaction);
  Future<TransactionModel> updateTransaction(TransactionModel transaction);
  Future<bool> deleteTransaction(String id);
}

@Injectable(as: TransactionRemoteDatasource)
class SupabaseTransactionDatasource implements TransactionRemoteDatasource {
  const SupabaseTransactionDatasource(this._supabase);
  final SupabaseClient _supabase;

  @override
  Future<List<TransactionModel>> getTransactionsBySender(
    String senderId,
  ) async {
    try {
      final data = await _supabase
          .from(RC.tableTransaction)
          .select()
          .eq(RC.transactionSenderId, senderId)
          .order(RC.transactionDate, ascending: false);
      return data.map(TransactionModel.fromJson).toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<TransactionModel>> getTransactionsByReceiver(
    String receiverId,
  ) async {
    try {
      final data = await _supabase
          .from(RC.tableTransaction)
          .select()
          .eq(RC.transactionReceiverId, receiverId)
          .order(RC.transactionDate, ascending: false);
      return data.map(TransactionModel.fromJson).toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<TransactionModel?> getTransactionById(String id) async {
    try {
      final data = await _supabase
          .from(RC.tableTransaction)
          .select()
          .eq(RC.id, id)
          .maybeSingle();
      return data != null ? TransactionModel.fromJson(data) : null;
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<TransactionModel> createTransaction(
    TransactionModel transaction,
  ) async {
    try {
      final data = await _supabase
          .from(RC.tableTransaction)
          .insert(transaction.toJson())
          .select()
          .single();
      return TransactionModel.fromJson(data);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<TransactionModel> updateTransaction(
    TransactionModel transaction,
  ) async {
    try {
      final data = await _supabase
          .from(RC.tableTransaction)
          .update(transaction.toJson())
          .eq(RC.id, transaction.id)
          .select()
          .single();
      return TransactionModel.fromJson(data);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> deleteTransaction(String id) async {
    try {
      await _supabase.from(RC.tableTransaction).delete().eq(RC.id, id);
      return true;
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
