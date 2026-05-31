import 'package:fpdart/fpdart.dart';

import '../errors/failures.dart';

/// Contrato base para todos los casos de uso.
/// [Type] = tipo de retorno exitoso.
/// [Params] = parámetros de entrada.
///
/// Uso:
/// ```dart
/// @injectable
/// class GetContactsUseCase extends UseCase<List<Contact>, NoParams> {
///   GetContactsUseCase(this._repository);
///   final ContactRepository _repository;
///
///   @override
///   Future<Either<Failure, List<Contact>>> call(NoParams params) =>
///       _repository.getContacts();
/// }
/// ```
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Para casos de uso sin parámetros.
/// Uso: `useCase(const NoParams())`
final class NoParams {
  const NoParams();
}
