import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/remote_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/relationship_type_model.dart';

abstract interface class RelationshipTypeRemoteDatasource {
  /// Devuelve todos los tipos de relación ordenados por nombre_es.
  Future<List<RelationshipTypeModel>> getAll();

  /// Devuelve un tipo de relación por su id, o null si no existe.
  Future<RelationshipTypeModel?> getById(int id);
}

@LazySingleton(as: RelationshipTypeRemoteDatasource)
class SupabaseRelationshipTypeDatasource
    implements RelationshipTypeRemoteDatasource {
  const SupabaseRelationshipTypeDatasource(this._supabase);
  final SupabaseClient _supabase;

  @override
  Future<List<RelationshipTypeModel>> getAll() async {
    try {
      final data = await _supabase
          .from(RC.tableRelationshipType)
          .select()
          .order(RC.roleNameEs);

      return data.map(RelationshipTypeModel.fromJson).toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<RelationshipTypeModel?> getById(int id) async {
    try {
      final data = await _supabase
          .from(RC.tableRelationshipType)
          .select()
          .eq(RC.id, id)
          .maybeSingle();

      return data != null ? RelationshipTypeModel.fromJson(data) : null;
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
