part of 'contacts_bloc.dart';

sealed class ContactsState extends Equatable {
  const ContactsState();
  @override
  List<Object?> get props => [];
}

final class ContactsInitial extends ContactsState {
  const ContactsInitial();
}

final class ContactsLoading extends ContactsState {
  const ContactsLoading();
}

/// Estado principal: lista cargada (completa o filtrada por búsqueda).
/// [allContacts]  → lista completa del servidor (para búsqueda local si hace falta)
/// [searchQuery]  → query activa (vacía = sin filtro)
/// [isSearching]  → true mientras espera resultado del servidor
final class ContactsLoaded extends ContactsState {
  const ContactsLoaded(
    this.allContacts, {
    this.searchQuery = '',
    this.isSearching = false,
  });

  final List<ContactEntity> allContacts;
  final String searchQuery;
  final bool isSearching;

  bool get hasSearch => searchQuery.isNotEmpty;

  @override
  List<Object?> get props => [allContacts, searchQuery, isSearching];
}

final class ContactsError extends ContactsState {
  const ContactsError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
