import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/use_case.dart';
import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

// ─────────────────────────────────────────────────────────────────────────────
// GetProfileUseCase
// ─────────────────────────────────────────────────────────────────────────────

class GetProfileParams {
  const GetProfileParams({required this.userId});
  final String userId;
}

@injectable
class GetProfileUseCase extends UseCase<ProfileEntity, GetProfileParams> {
  GetProfileUseCase(this._repository);
  final ProfileRepository _repository;

  @override
  Future<Either<Failure, ProfileEntity>> call(GetProfileParams params) =>
      _repository.getProfile(params.userId);
}

// ─────────────────────────────────────────────────────────────────────────────
// UpdateProfileUseCase
// ─────────────────────────────────────────────────────────────────────────────

class UpdateProfileParams {
  const UpdateProfileParams({required this.profile});
  final ProfileEntity profile;
}

@injectable
class UpdateProfileUseCase extends UseCase<ProfileEntity, UpdateProfileParams> {
  UpdateProfileUseCase(this._repository);
  final ProfileRepository _repository;

  @override
  Future<Either<Failure, ProfileEntity>> call(UpdateProfileParams params) =>
      _repository.updateProfile(params.profile);
}