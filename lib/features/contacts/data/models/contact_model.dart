import 'package:contactando/core/constants/remote_constants.dart';

import '../../domain/entities/contact_entity.dart';

class ContactModel {
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final String? photo;
  final String? notes;
  final String? tags;
  final String? address;
  final String? country;
  final DateTime createdAt;

  const ContactModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.photo,
    this.notes,
    this.tags,
    this.address,
    this.country,
    required this.createdAt,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) => ContactModel(
    id: json[RC.id] as String,
    name: json[RC.name] as String,
    phone: json[RC.phone] as String,
    email: json[RC.email] as String?,      // nullable en DB
    photo: json[RC.photo] as String?,       // no avatar_url
    notes: json[RC.notes] as String?,
    tags: json[RC.tags] as String?,
    address: json[RC.address] as String?,
    country: json[RC.country] as String?,
    createdAt: DateTime.parse(json[RC.created_at] as String),
  );

  Map<String, dynamic> toJson() => {
    RC.id: id,
    RC.name: name,
    RC.email: email,
    if (phone != null) RC.phone: phone,

    RC.created_at: createdAt.toIso8601String(),
  };

  ContactEntity toEntity() => ContactEntity(
    id: id,
    name: name,
    email: email!,
    phone: phone,
    createdAt: createdAt,
  );
}
