import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';
import '../models/profile_model.dart';

@LazySingleton(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this._datasource);
  final ProfileRemoteDatasource _datasource;

  @override
  Future<Either<Failure, ProfileEntity>> getProfile(String userId) async {
    try {
      final model = await _datasource.getProfile(userId);
      if (model == null) {
        return left(const NotFoundFailure('Perfil no encontrado'));
      }
      return right(model.toEntity());
    } on AppException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProfileEntity>> updateProfile(
      ProfileEntity profile) async {
    try {
      final model = ProfileModel.fromEntity(profile);
      return right((await _datasource.updateProfile(model)).toEntity());
    } on AppException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}