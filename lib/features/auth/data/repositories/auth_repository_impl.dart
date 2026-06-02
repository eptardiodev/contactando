import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._datasource);
  final AuthRemoteDatasource _datasource;

  @override
  Future<Either<Failure, UserEntity>> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _datasource.signInWithEmailPassword(
        email: email,
        password: password,
      );
      return right(user);
    } on AppAuthException catch (e) {
      return left(AuthFailure(e.message));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signUpWithEmailPassword({
    required String email,
    required String password,
    String? fullName,
  }) async {
    try {
      final user = await _datasource.signUpWithEmailPassword(
        email: email,
        password: password,
        fullName: fullName,
      );
      return right(user);
    } on AppAuthException catch (e) {
      return left(AuthFailure(e.message));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await _datasource.signOut();
      return right(unit);
    } on AppAuthException catch (e) {
      return left(AuthFailure(e.message));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> sendPasswordResetEmail(String email) async {
    try {
      await _datasource.sendPasswordResetEmail(email);
      return right(unit);
    } on AppAuthException catch (e) {
      return left(AuthFailure(e.message));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updatePassword(String newPassword) async {
    try {
      await _datasource.updatePassword(newPassword);
      return right(unit);
    } on AppAuthException catch (e) {
      return left(AuthFailure(e.message));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  UserEntity? get currentUser => _datasource.currentUser;

  @override
  bool get isAuthenticated => _datasource.currentUser != null;

  @override
  Stream<UserEntity?> get authStateChanges => _datasource.authStateChanges;

  @override
  Future<void> saveLoginTimestamp() => _datasource.saveLoginTimestamp();

  @override
  bool isLoginWithin24Hours() => _datasource.isLoginWithin24Hours();

  @override
  Future<void> clearLoginTimestamp() => _datasource.clearLoginTimestamp();
}
