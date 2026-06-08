import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/use_case.dart';
import '../entities/contact_entity.dart';
import '../repositories/contact_repository.dart';

// ─────────────────────────────────────────────────────────────────────────────
// GetContactsUseCase
// ─────────────────────────────────────────────────────────────────────────────

class GetContactsParams {
  const GetContactsParams({required this.userId});
  final String userId;
}

@injectable
class GetContactsUseCase extends UseCase<List<ContactEntity>, GetContactsParams> {
  GetContactsUseCase(this._repository);
  final ContactRepository _repository;

  @override
  Future<Either<Failure, List<ContactEntity>>> call(GetContactsParams params) =>
      _repository.getContacts(params.userId);
}

// ─────────────────────────────────────────────────────────────────────────────
// GetContactByIdUseCase
// ─────────────────────────────────────────────────────────────────────────────

class GetContactByIdParams {
  const GetContactByIdParams({required this.id});
  final String id;
}

@injectable
class GetContactByIdUseCase extends UseCase<ContactEntity, GetContactByIdParams> {
  GetContactByIdUseCase(this._repository);
  final ContactRepository _repository;

  @override
  Future<Either<Failure, ContactEntity>> call(GetContactByIdParams params) =>
      _repository.getContactById(params.id);
}

// ─────────────────────────────────────────────────────────────────────────────
// SearchContactsUseCase
// ─────────────────────────────────────────────────────────────────────────────

class SearchContactsParams {
  const SearchContactsParams({required this.userId, required this.query});
  final String userId;
  final String query;
}

@injectable
class SearchContactsUseCase
    extends UseCase<List<ContactEntity>, SearchContactsParams> {
  SearchContactsUseCase(this._repository);
  final ContactRepository _repository;

  @override
  Future<Either<Failure, List<ContactEntity>>> call(SearchContactsParams params) =>
      _repository.searchContacts(userId: params.userId, query: params.query);
}

// ─────────────────────────────────────────────────────────────────────────────
// CreateContactUseCase
// ─────────────────────────────────────────────────────────────────────────────

class CreateContactParams {
  const CreateContactParams({required this.contact});
  final ContactEntity contact;
}

@injectable
class CreateContactUseCase extends UseCase<ContactEntity, CreateContactParams> {
  CreateContactUseCase(this._repository);
  final ContactRepository _repository;

  @override
  Future<Either<Failure, ContactEntity>> call(CreateContactParams params) =>
      _repository.createContact(params.contact);
}

// ─────────────────────────────────────────────────────────────────────────────
// UpdateContactUseCase
// ─────────────────────────────────────────────────────────────────────────────

class UpdateContactParams {
  const UpdateContactParams({required this.contact});
  final ContactEntity contact;
}

@injectable
class UpdateContactUseCase extends UseCase<ContactEntity, UpdateContactParams> {
  UpdateContactUseCase(this._repository);
  final ContactRepository _repository;

  @override
  Future<Either<Failure, ContactEntity>> call(UpdateContactParams params) =>
      _repository.updateContact(params.contact);
}

// ─────────────────────────────────────────────────────────────────────────────
// DeleteContactUseCase
// ─────────────────────────────────────────────────────────────────────────────

class DeleteContactParams {
  const DeleteContactParams({required this.id});
  final String id;
}

@injectable
class DeleteContactUseCase extends UseCase<ContactEntity, DeleteContactParams> {
  DeleteContactUseCase(this._repository);
  final ContactRepository _repository;

  @override
  Future<Either<Failure, ContactEntity>> call(DeleteContactParams params) =>
      _repository.deleteContact(params.id);
}

// ─────────────────────────────────────────────────────────────────────────────
// GetUniqueCountriesUseCase
// ─────────────────────────────────────────────────────────────────────────────

class GetUniqueCountriesParams {
  const GetUniqueCountriesParams({required this.userId});
  final String userId;
}

@injectable
class GetUniqueCountriesUseCase
    extends UseCase<List<String>, GetUniqueCountriesParams> {
  GetUniqueCountriesUseCase(this._repository);
  final ContactRepository _repository;

  @override
  Future<Either<Failure, List<String>>> call(GetUniqueCountriesParams params) =>
      _repository.getUniqueCountries(params.userId);
}
