import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/utils/use_case.dart';
import '../../domain/entities/relationship_type_entity.dart';
import '../../domain/usecases/relationship_type_usecases.dart';

part 'relationship_type_event.dart';
part 'relationship_type_state.dart';

/// BLoC de solo lectura para el catálogo de tipos de relación.
/// Se usa desde AddContactPage (y en el futuro desde la pantalla de relaciones).
/// Al ser @lazySingleton el catálogo se carga una sola vez por sesión.
@lazySingleton
class RelationshipTypeBloc
    extends Bloc<RelationshipTypeEvent, RelationshipTypeState> {
  RelationshipTypeBloc({
    required GetAllRelationshipTypesUseCase getAll,
  })  : _getAll = getAll,
        super(const RelationshipTypeInitial()) {
    on<RelationshipTypeLoadRequested>(_onLoad);
  }

  final GetAllRelationshipTypesUseCase _getAll;

  Future<void> _onLoad(
    RelationshipTypeLoadRequested event,
    Emitter<RelationshipTypeState> emit,
  ) async {
    // Si ya está cargado no volvemos a llamar a Supabase.
    if (state is RelationshipTypeLoaded) return;

    emit(const RelationshipTypeLoading());
    final result = await _getAll(const NoParams());
    result.fold(
      (failure) => emit(RelationshipTypeError(failure.message)),
      (types) => emit(RelationshipTypeLoaded(types)),
    );
  }
}
