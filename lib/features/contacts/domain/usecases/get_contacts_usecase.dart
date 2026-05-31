import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/use_case.dart';
import '../entities/contact_entity.dart';
import '../repositories/contact_repository.dart';

@injectable
class GetContactsUseCase extends UseCase<List<ContactEntity>, NoParams> {
  GetContactsUseCase(this._repository);
  final ContactRepository _repository;

  @override
  Future<Either<Failure, List<ContactEntity>>> call(NoParams params) =>
      _repository.getContacts();
}
