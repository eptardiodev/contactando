import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/contact_entity.dart';
import '../../domain/usecases/contact_usecases.dart';

part 'contacts_event.dart';
part 'contacts_state.dart';

@injectable
class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  ContactsBloc({
    required GetContactsUseCase getContacts,
    required SearchContactsUseCase searchContacts,
    required CreateContactUseCase createContact,
    required UpdateContactUseCase updateContact,
    required DeleteContactUseCase deleteContact,
    required GetUniqueCountriesUseCase getUniqueCountries,
  })  : _getContacts = getContacts,
        _searchContacts = searchContacts,
        _createContact = createContact,
        _updateContact = updateContact,
        _deleteContact = deleteContact,
        _getUniqueCountries = getUniqueCountries,
        super(const ContactsInitial()) {
    on<ContactsLoadRequested>(_onLoad);
    on<ContactsSearchChanged>(_onSearch);
    on<ContactsSearchCleared>(_onSearchCleared);
    on<ContactsCreateRequested>(_onCreate);
    on<ContactsUpdateRequested>(_onUpdate);
    on<ContactsDeleteRequested>(_onDelete);
  }

  final GetContactsUseCase _getContacts;
  final SearchContactsUseCase _searchContacts;
  final CreateContactUseCase _createContact;
  final UpdateContactUseCase _updateContact;
  final DeleteContactUseCase _deleteContact;
  final GetUniqueCountriesUseCase _getUniqueCountries;

  // ── Helpers ───────────────────────────────────────────────────────────────

  // FIX #4: Devuelve null si Supabase aún no tiene sesión restaurada,
  // en lugar de '' que causaba queries vacías silenciosas contra Supabase.
  String? get _currentUserId =>
      Supabase.instance.client.auth.currentUser?.id;

  // ── Handlers ─────────────────────────────────────────────────────────────

  Future<void> _onLoad(
    ContactsLoadRequested event,
    Emitter<ContactsState> emit,
  ) async {
    final userId = _currentUserId;
    // FIX #4: Si no hay userId, no lanzamos una query con '' que devuelve 0
    // resultados — emitimos error para que el usuario vea algo accionable
    // y para que el retry en la UI funcione cuando la sesión esté lista.
    if (userId == null || userId.isEmpty) {
      emit(const ContactsError('Sesión no disponible. Vuelve a intentarlo.'));
      return;
    }

    emit(const ContactsLoading());
    final result = await _getContacts(
      GetContactsParams(userId: userId),
    );
    result.fold(
      (failure) => emit(ContactsError(failure.message)),
      (contacts) => emit(ContactsLoaded(contacts)),
    );
  }

  Future<void> _onSearch(
    ContactsSearchChanged event,
    Emitter<ContactsState> emit,
  ) async {
    if (event.query.trim().isEmpty) {
      add(const ContactsSearchCleared());
      return;
    }

    final userId = _currentUserId;
    if (userId == null || userId.isEmpty) {
      emit(const ContactsError('Sesión no disponible. Vuelve a intentarlo.'));
      return;
    }

    final current = state is ContactsLoaded
        ? (state as ContactsLoaded).allContacts
        : <ContactEntity>[];

    emit(ContactsLoaded(current, searchQuery: event.query, isSearching: true));

    final result = await _searchContacts(
      SearchContactsParams(userId: userId, query: event.query.trim()),
    );
    result.fold(
      (failure) => emit(ContactsError(failure.message)),
      (contacts) => emit(
        ContactsLoaded(contacts, searchQuery: event.query, isSearching: false),
      ),
    );
  }

  Future<void> _onSearchCleared(
    ContactsSearchCleared event,
    Emitter<ContactsState> emit,
  ) async {
    add(const ContactsLoadRequested());
  }

  Future<void> _onCreate(
    ContactsCreateRequested event,
    Emitter<ContactsState> emit,
  ) async {
    final result = await _createContact(
      CreateContactParams(contact: event.contact),
    );
    result.fold(
      (failure) => emit(ContactsError(failure.message)),
      (_) => add(const ContactsLoadRequested()),
    );
  }

  Future<void> _onUpdate(
    ContactsUpdateRequested event,
    Emitter<ContactsState> emit,
  ) async {
    final result = await _updateContact(
      UpdateContactParams(contact: event.contact),
    );
    result.fold(
      (failure) => emit(ContactsError(failure.message)),
      (_) => add(const ContactsLoadRequested()),
    );
  }

  Future<void> _onDelete(
    ContactsDeleteRequested event,
    Emitter<ContactsState> emit,
  ) async {
    final result = await _deleteContact(
      DeleteContactParams(id: event.contactId),
    );
    result.fold(
      (failure) => emit(ContactsError(failure.message)),
      (_) => add(const ContactsLoadRequested()),
    );
  }
}
