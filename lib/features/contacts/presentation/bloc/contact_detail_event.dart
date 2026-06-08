part of 'contact_detail_bloc.dart';

// ── Events ────────────────────────────────────────────────────────────────────

sealed class ContactDetailEvent extends Equatable {
  const ContactDetailEvent();
  @override
  List<Object?> get props => [];
}

/// Invocado al entrar a la pantalla con el contacto ya cargado desde la lista.
final class ContactDetailLoaded extends ContactDetailEvent {
  const ContactDetailLoaded(this.contact);
  final ContactEntity contact;
  @override
  List<Object?> get props => [contact];
}

final class ContactDetailUpdateRequested extends ContactDetailEvent {
  const ContactDetailUpdateRequested(this.contact);
  final ContactEntity contact;
  @override
  List<Object?> get props => [contact];
}

final class ContactDetailDeleteRequested extends ContactDetailEvent {
  const ContactDetailDeleteRequested();
}
