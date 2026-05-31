import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  const Failure(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}

final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Sin conexión a internet']);
}

final class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Error de autenticación']);
}

final class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Error del servidor']);
}

final class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Recurso no encontrado']);
}

final class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Error de almacenamiento local']);
}

final class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}
