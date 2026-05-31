// ─────────────────────────────────────────────────────────────────────────────
// TEMPLATE de BLoC completo para un feature.
// Copia este patrón para DashboardBloc, TransactionsBloc, etc.
// ─────────────────────────────────────────────────────────────────────────────

// lib/features/contacts/presentation/bloc/contacts_bloc.dart
import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/utils/use_case.dart';
import '../../domain/entities/contact_entity.dart';
import '../../domain/usecases/get_contacts_usecase.dart';

part 'contacts_event.dart';
part 'contacts_state.dart';

@injectable
class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  ContactsBloc(this._getContacts) : super(const ContactsInitial()) {
    on<ContactsLoadRequested>(_onLoadRequested);
    on<ContactsSearchChanged>(_onSearchChanged);
  }

  final GetContactsUseCase _getContacts;

  Future<void> _onLoadRequested(
    ContactsLoadRequested event,
    Emitter<ContactsState> emit,
  ) async {
    emit(const ContactsLoading());

    final result = await _getContacts(const NoParams());

    result.fold(
      (failure) => emit(ContactsError(failure.message)),
      (contacts) => emit(ContactsLoaded(contacts)),
    );
  }

  Future<void> _onSearchChanged(
    ContactsSearchChanged event,
    Emitter<ContactsState> emit,
  ) async {
    if (state is! ContactsLoaded) return;

    final allContacts = (state as ContactsLoaded).contacts;

    if (event.query.isEmpty) {
      emit(ContactsLoaded(allContacts));
      return;
    }

    final filtered = allContacts
        .where((c) => c.name.toLowerCase().contains(event.query.toLowerCase()))
        .toList();

    emit(ContactsLoaded(filtered, searchQuery: event.query));
  }
}
