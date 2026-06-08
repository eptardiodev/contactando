import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/relationship_type_entity.dart';
import '../../domain/repositories/relationship_type_repository.dart';
import '../datasources/relationship_type_remote_datasource.dart';

@LazySingleton(as: RelationshipTypeRepository)
class RelationshipTypeRepositoryImpl implements RelationshipTypeRepository {
  const RelationshipTypeRepositoryImpl(this._datasource);
  final RelationshipTypeRemoteDatasource _datasource;

  @override
  Future<Either<Failure, List<RelationshipTypeEntity>>> getAll() async {
    try {
      final models = await _datasource.getAll();
      return right(models.map((m) => m.toEntity()).toList());
    } on AppException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, RelationshipTypeEntity?>> getById(int id) async {
    try {
      final model = await _datasource.getById(id);
      return right(model?.toEntity());
    } on AppException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
