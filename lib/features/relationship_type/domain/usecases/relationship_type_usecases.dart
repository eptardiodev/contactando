import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/use_case.dart';
import '../entities/relationship_type_entity.dart';
import '../repositories/relationship_type_repository.dart';

// ─────────────────────────────────────────────────────────────────────────────
// GetAllRelationshipTypesUseCase
// ─────────────────────────────────────────────────────────────────────────────

@injectable
class GetAllRelationshipTypesUseCase
    extends UseCase<List<RelationshipTypeEntity>, NoParams> {
  GetAllRelationshipTypesUseCase(this._repository);
  final RelationshipTypeRepository _repository;

  @override
  Future<Either<Failure, List<RelationshipTypeEntity>>> call(
    NoParams params,
  ) =>
      _repository.getAll();
}

// ─────────────────────────────────────────────────────────────────────────────
// GetRelationshipTypeByIdUseCase
// ─────────────────────────────────────────────────────────────────────────────

class GetRelationshipTypeByIdParams {
  const GetRelationshipTypeByIdParams({required this.id});
  final int id;
}

@injectable
class GetRelationshipTypeByIdUseCase
    extends UseCase<RelationshipTypeEntity?, GetRelationshipTypeByIdParams> {
  GetRelationshipTypeByIdUseCase(this._repository);
  final RelationshipTypeRepository _repository;

  @override
  Future<Either<Failure, RelationshipTypeEntity?>> call(
    GetRelationshipTypeByIdParams params,
  ) =>
      _repository.getById(params.id);
}
