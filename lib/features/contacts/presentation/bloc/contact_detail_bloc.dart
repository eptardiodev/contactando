import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/contact_entity.dart';
import '../../domain/usecases/contact_usecases.dart';

part 'contact_detail_event.dart';
part 'contact_detail_state.dart';

@injectable
class ContactDetailBloc extends Bloc<ContactDetailEvent, ContactDetailState> {
  ContactDetailBloc({
    required UpdateContactUseCase updateContact,
    required DeleteContactUseCase deleteContact,
  })  : _updateContact = updateContact,
        _deleteContact = deleteContact,
        super(const ContactDetailInitial()) {
    on<ContactDetailLoaded>(_onLoaded);
    on<ContactDetailUpdateRequested>(_onUpdate);
    on<ContactDetailDeleteRequested>(_onDelete);
  }

  final UpdateContactUseCase _updateContact;
  final DeleteContactUseCase _deleteContact;

  void _onLoaded(ContactDetailLoaded event, Emitter<ContactDetailState> emit) {
    // El contacto llega completo desde la lista — no hace falta fetch extra.
    emit(ContactDetailSuccess(event.contact));
  }

  Future<void> _onUpdate(
    ContactDetailUpdateRequested event,
    Emitter<ContactDetailState> emit,
  ) async {
    emit(ContactDetailUpdating(event.contact));
    final result = await _updateContact(
      UpdateContactParams(contact: event.contact),
    );
    result.fold(
      (failure) => emit(ContactDetailError(
        contact: event.contact,
        message: failure.message,
      )),
      (updated) => emit(ContactDetailSuccess(updated)),
    );
  }

  Future<void> _onDelete(
    ContactDetailDeleteRequested event,
    Emitter<ContactDetailState> emit,
  ) async {
    final current = state;
    if (current is! ContactDetailSuccess) return;

    emit(ContactDetailDeleting(current.contact));
    final result = await _deleteContact(
      DeleteContactParams(id: current.contact.id),
    );
    result.fold(
      (failure) => emit(ContactDetailError(
        contact: current.contact,
        message: failure.message,
      )),
      (_) => emit(const ContactDetailDeleted()),
    );
  }
}
