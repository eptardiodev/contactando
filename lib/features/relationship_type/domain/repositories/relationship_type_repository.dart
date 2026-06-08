import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../entities/relationship_type_entity.dart';

abstract interface class RelationshipTypeRepository {
  /// Devuelve todos los tipos de relación ordenados por nombre_es.
  Future<Either<Failure, List<RelationshipTypeEntity>>> getAll();

  /// Devuelve un tipo de relación por su id.
  Future<Either<Failure, RelationshipTypeEntity?>> getById(int id);
}
