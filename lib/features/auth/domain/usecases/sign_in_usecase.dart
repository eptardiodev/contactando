// import 'package:fpdart/fpdart.dart';
// import 'package:injectable/injectable.dart';
// import '../../../../core/errors/failures.dart';
// import '../entities/user_entity.dart';
// import '../repositories/auth_repository.dart';
//
// @injectable
// class SignInUseCase {
//   const SignInUseCase(this._repository);
//   final AuthRepository _repository;
//
//   Future<Either<Failure, UserEntity>> call({
//     required String email,
//     required String password,
//   }) =>
//       _repository.signInWithEmailPassword(email: email, password: password);
// }


import 'package:contactando/core/utils/use_case.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

@injectable
class SignInUseCase implements UseCase<UserEntity, LoginParam>{
  final AuthRepository _repository;
  const SignInUseCase(this._repository);

  @override
  Future<Either<Failure, UserEntity>> call(params) async {
    return await _repository.signInWithEmailPassword(
        email: params.email,
        password: params.password
    );
  }
}

class LoginParam {
  final String email;
  final String password;

  LoginParam({required this.email, required this.password});
}