import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/contact_entity.dart';
import '../../domain/repositories/contact_repository.dart';
import '../datasources/contact_remote_datasource.dart';
import '../models/contact_model.dart';

@Injectable(as: ContactRepository)
class ContactRepositoryImpl implements ContactRepository {
  const ContactRepositoryImpl(this._datasource);
  final ContactRemoteDatasource _datasource;

  // ── Helpers ───────────────────────────────────────────────────────────────

  Either<Failure, T> _handleException<T>(Object e) {
    if (e is AppException) return left(ServerFailure(e.message));
    return left(ServerFailure(e.toString()));
  }

  // ── Lectura ───────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, List<ContactEntity>>> getContacts(String userId) async {
    try {
      final models = await _datasource.getContacts(userId);
      return right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return _handleException(e);
    }
  }

  @override
  Future<Either<Failure, ContactEntity>> getContactById(String id) async {
    try {
      return right((await _datasource.getContactById(id)).toEntity());
    } catch (e) {
      return _handleException(e);
    }
  }

  @override
  Future<Either<Failure, List<ContactEntity>>> searchContacts({
    required String userId,
    required String query,
  }) async {
    try {
      final models = await _datasource.searchContacts(
        userId: userId,
        query: query,
      );
      return right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return _handleException(e);
    }
  }

  @override
  Future<Either<Failure, List<ContactEntity>>> getContactsByTag({
    required String userId,
    required String tag,
  }) async {
    try {
      final models = await _datasource.getContactsByTag(
        userId: userId,
        tag: tag,
      );
      return right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return _handleException(e);
    }
  }

  @override
  Future<Either<Failure, List<ContactEntity>>> getContactsByCountry({
    required String userId,
    required String country,
  }) async {
    try {
      final models = await _datasource.getContactsByCountry(
        userId: userId,
        country: country,
      );
      return right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return _handleException(e);
    }
  }

  // ── Estadísticas ──────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, int>> getTotalContacts(String userId) async {
    try {
      return right(await _datasource.getTotalContacts(userId));
    } catch (e) {
      return _handleException(e);
    }
  }

  @override
  Future<Either<Failure, List<String>>> getUniqueTags(String userId) async {
    try {
      return right(await _datasource.getUniqueTags(userId));
    } catch (e) {
      return _handleException(e);
    }
  }

  @override
  Future<Either<Failure, List<String>>> getUniqueCountries(String userId) async {
    try {
      return right(await _datasource.getUniqueCountries(userId));
    } catch (e) {
      return _handleException(e);
    }
  }

  // ── Escritura ─────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, ContactEntity>> createContact(
    ContactEntity contact,
  ) async {
    try {
      final model = ContactModel.fromEntity(contact);
      return right((await _datasource.createContact(model)).toEntity());
    } catch (e) {
      return _handleException(e);
    }
  }

  @override
  Future<Either<Failure, ContactEntity>> updateContact(
    ContactEntity contact,
  ) async {
    try {
      final model = ContactModel.fromEntity(contact);
      return right((await _datasource.updateContact(model)).toEntity());
    } catch (e) {
      return _handleException(e);
    }
  }

  @override
  Future<Either<Failure, ContactEntity>> deleteContact(String id) async {
    try {
      return right((await _datasource.deleteContact(id)).toEntity());
    } catch (e) {
      return _handleException(e);
    }
  }
}
