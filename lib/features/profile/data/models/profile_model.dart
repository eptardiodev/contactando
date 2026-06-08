import 'package:contactando/core/constants/remote_constants.dart';

import '../../domain/entities/profile_entity.dart';

class ProfileModel {
  const ProfileModel({
    required this.id,
    required this.ownerUserId,
    required this.name,
    required this.phone,
    this.email,
    this.photo,
    this.notes,
    this.address,
    this.country,
    this.createdAt,
  });

  final String id;
  final String ownerUserId;
  final String name;
  final String phone;
  final String? email;
  final String? photo;
  final String? notes;
  final String? address;
  final String? country;
  final DateTime? createdAt;

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    id: json[RC.id] as String,
    ownerUserId: json[RC.contactOwnerUserId] as String,
    name: json[RC.contactName] as String? ?? '',
    phone: json[RC.contactPhone] as String? ?? '',
    email: json[RC.contactEmail] as String?,
    photo: json[RC.contactPhoto] as String?,
    notes: json[RC.contactNotes] as String?,
    address: json[RC.contactAddress] as String?,
    country: json[RC.contactCountry] as String?,
    createdAt: json[RC.createdAt] != null
        ? DateTime.parse(json[RC.createdAt] as String)
        : null,
  );

  Map<String, dynamic> toJson() => {
    RC.contactOwnerUserId: ownerUserId,
    RC.contactName: name,
    RC.contactPhone: phone,
    if (email != null) RC.contactEmail: email,
    if (photo != null) RC.contactPhoto: photo,
    if (notes != null) RC.contactNotes: notes,
    if (address != null) RC.contactAddress: address,
    if (country != null) RC.contactCountry: country,
    // isContactRole = false siempre para perfil
    RC.contactIsContactRole: false,
    RC.active: true,
  };

  ProfileEntity toEntity() => ProfileEntity(
    id: id,
    ownerUserId: ownerUserId,
    name: name,
    phone: phone,
    email: email,
    photo: photo,
    notes: notes,
    address: address,
    country: country,
    createdAt: createdAt,
  );

  factory ProfileModel.fromEntity(ProfileEntity entity) => ProfileModel(
    id: entity.id,
    ownerUserId: entity.ownerUserId,
    name: entity.name,
    phone: entity.phone,
    email: entity.email,
    photo: entity.photo,
    notes: entity.notes,
    address: entity.address,
    country: entity.country,
    createdAt: entity.createdAt,
  );
}