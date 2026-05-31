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
