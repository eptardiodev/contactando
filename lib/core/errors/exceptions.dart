sealed class AppException implements Exception {
  const AppException(this.message);
  final String message;
}

final class NetworkException extends AppException {
  const NetworkException([super.message = 'Sin conexión']);
}

final class ServerException extends AppException {
  const ServerException([super.message = 'Error del servidor']);
}

final class AppAuthException  extends AppException {
  const AppAuthException ([super.message = 'Error de autenticación']);
}

final class NotFoundException extends AppException {
  const NotFoundException([super.message = 'No encontrado']);
}

final class CacheException extends AppException {
  const CacheException([super.message = 'Error de caché']);
}
