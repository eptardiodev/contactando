import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/contact_entity.dart';

abstract interface class ContactRepository {
  Future<Either<Failure, List<ContactEntity>>> getContacts();
  Future<Either<Failure, ContactEntity>> getContactById(String id);
  Future<Either<Failure, ContactEntity>> createContact(ContactEntity contact);
  Future<Either<Failure, ContactEntity>> updateContact(ContactEntity contact);
  Future<Either<Failure, void>> deleteContact(String id);
}
