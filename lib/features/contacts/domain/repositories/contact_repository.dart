import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../entities/contact_entity.dart';

abstract interface class ContactRepository {
  // ── Lectura ───────────────────────────────────────────────────────────────

  /// Devuelve los contactos del usuario (isContactRole = true, active = true).
  Future<Either<Failure, List<ContactEntity>>> getContacts(String userId);

  Future<Either<Failure, ContactEntity>> getContactById(String id);

  /// Búsqueda por nombre, teléfono o email (ilike).
  Future<Either<Failure, List<ContactEntity>>> searchContacts({
    required String userId,
    required String query,
  });

  Future<Either<Failure, List<ContactEntity>>> getContactsByTag({
    required String userId,
    required String tag,
  });

  Future<Either<Failure, List<ContactEntity>>> getContactsByCountry({
    required String userId,
    required String country,
  });

  // ── Estadísticas ──────────────────────────────────────────────────────────

  Future<Either<Failure, int>> getTotalContacts(String userId);

  Future<Either<Failure, List<String>>> getUniqueTags(String userId);

  Future<Either<Failure, List<String>>> getUniqueCountries(String userId);

  // ── Escritura ─────────────────────────────────────────────────────────────

  Future<Either<Failure, ContactEntity>> createContact(ContactEntity contact);

  Future<Either<Failure, ContactEntity>> updateContact(ContactEntity contact);

  /// Soft-delete: marca active = false y deactivated_at = now().
  Future<Either<Failure, ContactEntity>> deleteContact(String id);
}
