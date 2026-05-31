import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/contact_entity.dart';
import '../../domain/repositories/contact_repository.dart';
import '../datasources/contact_remote_datasource.dart';
import '../models/contact_model.dart';

@Injectable(as: ContactRepository)
class ContactRepositoryImpl implements ContactRepository {
  ContactRepositoryImpl(this._datasource);
  final ContactRemoteDatasource _datasource;

  @override
  Future<Either<Failure, List<ContactEntity>>> getContacts() async {
    try {
      final models = await _datasource.getContacts();
      return right(models.map((m) => m.toEntity()).toList());
    } on Exception catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ContactEntity>> getContactById(String id) async {
    try {
      return right((await _datasource.getContactById(id)).toEntity());
    } on Exception catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ContactEntity>> createContact(ContactEntity contact) async {
    try {
      final model = ContactModel(id: contact.id, name: contact.name, email: contact.email,
        phone: contact.phone, company: contact.company, avatarUrl: contact.avatarUrl, createdAt: contact.createdAt);
      return right((await _datasource.createContact(model)).toEntity());
    } on Exception catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ContactEntity>> updateContact(ContactEntity contact) async {
    try {
      final model = ContactModel(id: contact.id, name: contact.name, email: contact.email,
        phone: contact.phone, company: contact.company, avatarUrl: contact.avatarUrl, createdAt: contact.createdAt);
      return right((await _datasource.updateContact(model)).toEntity());
    } on Exception catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteContact(String id) async {
    try {
      await _datasource.deleteContact(id);
      return right(null);
    } on Exception catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
