import 'package:equatable/equatable.dart';

/// Tipo de relación entre contactos (p. ej. Padre, Amigo, Socio).
/// Es un catálogo de solo lectura — no se crea ni elimina desde la app.
class RelationshipTypeEntity extends Equatable {
  const RelationshipTypeEntity({
    required this.id,
    required this.nameEs,
    required this.nameEn,
  });

  final int id;
  final String nameEs;
  final String nameEn;

  /// Nombre localizado: usa español si está disponible, inglés como fallback.
  String get displayName => nameEs.isNotEmpty ? nameEs : nameEn;

  @override
  List<Object?> get props => [id, nameEs, nameEn];
}
