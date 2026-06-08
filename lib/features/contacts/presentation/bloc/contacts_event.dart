part of 'contacts_bloc.dart';

sealed class ContactsEvent extends Equatable {
  const ContactsEvent();
  @override
  List<Object?> get props => [];
}

final class ContactsLoadRequested extends ContactsEvent {
  const ContactsLoadRequested();
}

final class ContactsSearchChanged extends ContactsEvent {
  const ContactsSearchChanged(this.query);
  final String query;
  @override
  List<Object?> get props => [query];
}

final class ContactsSearchCleared extends ContactsEvent {
  const ContactsSearchCleared();
}

final class ContactsCreateRequested extends ContactsEvent {
  const ContactsCreateRequested(this.contact);
  final ContactEntity contact;
  @override
  List<Object?> get props => [contact];
}

final class ContactsUpdateRequested extends ContactsEvent {
  const ContactsUpdateRequested(this.contact);
  final ContactEntity contact;
  @override
  List<Object?> get props => [contact];
}

final class ContactsDeleteRequested extends ContactsEvent {
  const ContactsDeleteRequested(this.contactId);
  final String contactId;
  @override
  List<Object?> get props => [contactId];
}
