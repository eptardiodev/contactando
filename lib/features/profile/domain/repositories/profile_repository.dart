import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../entities/profile_entity.dart';

abstract interface class ProfileRepository {
  /// Obtiene el perfil del usuario (isContactRole = false).
  Future<Either<Failure, ProfileEntity>> getProfile(String userId);

  /// Actualiza los datos del perfil.
  Future<Either<Failure, ProfileEntity>> updateProfile(ProfileEntity profile);
}