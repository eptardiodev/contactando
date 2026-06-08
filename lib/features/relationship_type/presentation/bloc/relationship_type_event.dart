part of 'relationship_type_bloc.dart';

sealed class RelationshipTypeEvent extends Equatable {
  const RelationshipTypeEvent();
  @override
  List<Object?> get props => [];
}

/// Disparado al abrir cualquier pantalla que necesite el catálogo.
/// El BLoC ignora el evento si el catálogo ya está en memoria.
final class RelationshipTypeLoadRequested extends RelationshipTypeEvent {
  const RelationshipTypeLoadRequested();
}
