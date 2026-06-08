part of 'relationship_type_bloc.dart';

sealed class RelationshipTypeState extends Equatable {
  const RelationshipTypeState();
  @override
  List<Object?> get props => [];
}

final class RelationshipTypeInitial extends RelationshipTypeState {
  const RelationshipTypeInitial();
}

final class RelationshipTypeLoading extends RelationshipTypeState {
  const RelationshipTypeLoading();
}

final class RelationshipTypeLoaded extends RelationshipTypeState {
  const RelationshipTypeLoaded(this.types);
  final List<RelationshipTypeEntity> types;
  @override
  List<Object?> get props => [types];
}

final class RelationshipTypeError extends RelationshipTypeState {
  const RelationshipTypeError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
