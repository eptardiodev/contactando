import 'package:contactando/core/constants/remote_constants.dart';

import '../../domain/entities/relationship_type_entity.dart';

class RelationshipTypeModel {
  const RelationshipTypeModel({
    required this.id,
    required this.nameEs,
    required this.nameEn,
  });

  final int id;
  final String nameEs;
  final String nameEn;

  factory RelationshipTypeModel.fromJson(Map<String, dynamic> json) =>
      RelationshipTypeModel(
        id: json[RC.id] as int,
        nameEs: json[RC.roleNameEs] as String? ?? '',
        nameEn: json[RC.roleNameEn] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        RC.id: id,
        RC.roleNameEs: nameEs,
        RC.roleNameEn: nameEn,
      };

  RelationshipTypeEntity toEntity() => RelationshipTypeEntity(
        id: id,
        nameEs: nameEs,
        nameEn: nameEn,
      );

  factory RelationshipTypeModel.fromEntity(RelationshipTypeEntity entity) =>
      RelationshipTypeModel(
        id: entity.id,
        nameEs: entity.nameEs,
        nameEn: entity.nameEn,
      );
}
