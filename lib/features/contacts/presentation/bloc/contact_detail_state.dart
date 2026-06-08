part of 'contact_detail_bloc.dart';

// ── States ────────────────────────────────────────────────────────────────────

sealed class ContactDetailState extends Equatable {
  const ContactDetailState();
  @override
  List<Object?> get props => [];
}

final class ContactDetailInitial extends ContactDetailState {
  const ContactDetailInitial();
}

final class ContactDetailSuccess extends ContactDetailState {
  const ContactDetailSuccess(this.contact);
  final ContactEntity contact;
  @override
  List<Object?> get props => [contact];
}

final class ContactDetailUpdating extends ContactDetailState {
  const ContactDetailUpdating(this.contact);
  final ContactEntity contact;
  @override
  List<Object?> get props => [contact];
}

final class ContactDetailDeleting extends ContactDetailState {
  const ContactDetailDeleting(this.contact);
  final ContactEntity contact;
  @override
  List<Object?> get props => [contact];
}

final class ContactDetailDeleted extends ContactDetailState {
  const ContactDetailDeleted();
}

final class ContactDetailError extends ContactDetailState {
  const ContactDetailError({required this.contact, required this.message});
  final ContactEntity contact;
  final String message;
  @override
  List<Object?> get props => [contact, message];
}
