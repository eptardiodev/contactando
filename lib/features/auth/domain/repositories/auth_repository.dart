import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, UserEntity>> signInWithEmailPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> signUpWithEmailPassword({
    required String email,
    required String password,
    String? fullName,
  });

  Future<Either<Failure, Unit>> signOut();

  Future<Either<Failure, Unit>> sendPasswordResetEmail(String email);

  Future<Either<Failure, Unit>> updatePassword(String newPassword);

  UserEntity? get currentUser;
  bool get isAuthenticated;

  Stream<UserEntity?> get authStateChanges;
}
