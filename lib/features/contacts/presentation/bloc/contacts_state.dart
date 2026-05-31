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

final class ContactsLoaded extends ContactsState {
  const ContactsLoaded(this.contacts, {this.searchQuery = ''});
  final List<ContactEntity> contacts;
  final String searchQuery;
  @override
  List<Object?> get props => [contacts, searchQuery];
}

final class ContactsError extends ContactsState {
  const ContactsError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
