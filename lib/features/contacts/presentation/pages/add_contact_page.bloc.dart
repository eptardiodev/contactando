part of 'add_contact_page.dart';

// ── Events ────────────────────────────────────────────────────────────────────
sealed class AddContactEvent extends Equatable {
  const AddContactEvent();
  @override
  List<Object?> get props => [];
}

/// Disparado al abrir la pantalla: carga países existentes.
final class AddContactFormLoaded extends AddContactEvent {
  const AddContactFormLoaded(this.userId);
  final String userId;
  @override
  List<Object?> get props => [userId];
}

final class AddContactSubmitted extends AddContactEvent {
  const AddContactSubmitted(this.contact);
  final ContactEntity contact;
  @override
  List<Object?> get props => [contact];
}

// ── State ─────────────────────────────────────────────────────────────────────

enum AddContactFormStatus { initial, loading, success, failure }

class AddContactFormState extends Equatable {
  const AddContactFormState({
    this.status = AddContactFormStatus.initial,
    this.countries = const [],
    this.errorMessage,
  });

  final AddContactFormStatus status;
  final List<String> countries;
  final String? errorMessage;

  AddContactFormState copyWith({
    AddContactFormStatus? status,
    List<String>? countries,
    String? errorMessage,
  }) =>
      AddContactFormState(
        status: status ?? this.status,
        countries: countries ?? this.countries,
        errorMessage: errorMessage ?? this.errorMessage,
      );

  @override
  List<Object?> get props => [status, countries, errorMessage];
}

// ── BLoC ──────────────────────────────────────────────────────────────────────

class AddContactBloc extends Bloc<AddContactEvent, AddContactFormState> {
  AddContactBloc({
    required CreateContactUseCase createContact,
    required GetUniqueCountriesUseCase getUniqueCountries,
  })  : _createContact = createContact,
        _getUniqueCountries = getUniqueCountries,
        super(const AddContactFormState()) {
    on<AddContactFormLoaded>(_onFormLoaded);
    on<AddContactSubmitted>(_onSubmitted);
  }

  final CreateContactUseCase _createContact;
  final GetUniqueCountriesUseCase _getUniqueCountries;

  Future<void> _onFormLoaded(
    AddContactFormLoaded event,
    Emitter<AddContactFormState> emit,
  ) async {
    emit(state.copyWith(status: AddContactFormStatus.loading));
    final result = await _getUniqueCountries(
      GetUniqueCountriesParams(userId: event.userId),
    );
    result.fold(
      (_) => emit(state.copyWith(status: AddContactFormStatus.initial)),
      (countries) => emit(
        state.copyWith(
          status: AddContactFormStatus.initial,
          countries: countries,
        ),
      ),
    );
  }

  Future<void> _onSubmitted(
    AddContactSubmitted event,
    Emitter<AddContactFormState> emit,
  ) async {
    emit(state.copyWith(status: AddContactFormStatus.loading));
    final result = await _createContact(
      CreateContactParams(contact: event.contact),
    );
    result.fold(
      (failure) => emit(state.copyWith(
        status: AddContactFormStatus.failure,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(status: AddContactFormStatus.success)),
    );
  }
}
