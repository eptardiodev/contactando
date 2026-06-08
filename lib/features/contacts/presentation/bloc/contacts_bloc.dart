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

  String get _currentUserId =>
      Supabase.instance.client.auth.currentUser?.id ?? '';

  // ── Handlers ─────────────────────────────────────────────────────────────

  Future<void> _onLoad(
    ContactsLoadRequested event,
    Emitter<ContactsState> emit,
  ) async {
    emit(const ContactsLoading());
    final result = await _getContacts(
      GetContactsParams(userId: _currentUserId),
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

    // Mantener la lista actual mientras se busca para no mostrar pantalla vacía
    final current = state is ContactsLoaded
        ? (state as ContactsLoaded).allContacts
        : <ContactEntity>[];

    emit(ContactsLoaded(current, searchQuery: event.query, isSearching: true));

    final result = await _searchContacts(
      SearchContactsParams(userId: _currentUserId, query: event.query.trim()),
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
