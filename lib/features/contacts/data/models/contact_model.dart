import 'package:contactando/core/constants/remote_constants.dart';

import '../../domain/entities/contact_entity.dart';

class ContactModel {
  const ContactModel({
    required this.id,
    required this.ownerUserId,
    required this.name,
    required this.phone,
    this.email,
    this.photo,
    this.notes,
    this.tags,
    this.address,
    this.country,
    this.active = true,
    this.isContactRole = true,
    this.createdAt,
    this.deactivatedAt,
  });

  final String id;
  final String ownerUserId;
  final String name;
  final String phone;
  final String? email;
  final String? photo;
  final String? notes;
  final String? tags;
  final String? address;
  final String? country;
  final bool active;
  final bool isContactRole;
  final DateTime? createdAt;
  final DateTime? deactivatedAt;

  // ── fromJson ──────────────────────────────────────────────────────────────

  factory ContactModel.fromJson(Map<String, dynamic> json) => ContactModel(
        id: json[RC.id] as String,
        ownerUserId: json[RC.contactOwnerUserId] as String,
        name: json[RC.contactName] as String? ?? '',
        phone: json[RC.contactPhone] as String? ?? '',
        email: json[RC.contactEmail] as String?,
        photo: json[RC.contactPhoto] as String?,
        notes: json[RC.contactNotes] as String?,
        tags: json[RC.contactTags] as String?,
        address: json[RC.contactAddress] as String?,
        country: json[RC.contactCountry] as String?,
        active: json[RC.active] as bool? ?? true,
        isContactRole: json[RC.contactIsContactRole] as bool? ?? true,
        createdAt: json[RC.createdAt] != null
            ? DateTime.parse(json[RC.createdAt] as String)
            : null,
        deactivatedAt: json[RC.contactDeactivatedAt] != null
            ? DateTime.parse(json[RC.contactDeactivatedAt] as String)
            : null,
      );

  // ── toJson (solo campos que van al INSERT / UPDATE) ───────────────────────

  Map<String, dynamic> toJson() => {
        RC.contactOwnerUserId: ownerUserId,
        RC.contactName: name,
        RC.contactPhone: phone,
        if (email != null) RC.contactEmail: email,
        if (photo != null) RC.contactPhoto: photo,
        if (notes != null) RC.contactNotes: notes,
        if (tags != null) RC.contactTags: tags,
        if (address != null) RC.contactAddress: address,
        if (country != null) RC.contactCountry: country,
        RC.active: active,
        RC.contactIsContactRole: isContactRole,
      };

  // ── toJson para soft-delete ───────────────────────────────────────────────

  Map<String, dynamic> toSoftDeleteJson() => {
        RC.active: false,
        RC.contactDeactivatedAt: DateTime.now().toIso8601String(),
      };

  // ── Domain conversion ─────────────────────────────────────────────────────

  ContactEntity toEntity() => ContactEntity(
        id: id,
        ownerUserId: ownerUserId,
        name: name,
        phone: phone,
        email: email,
        photo: photo,
        notes: notes,
        tags: tags,
        address: address,
        country: country,
        active: active,
        isContactRole: isContactRole,
        createdAt: createdAt,
        deactivatedAt: deactivatedAt,
      );

  factory ContactModel.fromEntity(ContactEntity entity) => ContactModel(
        id: entity.id,
        ownerUserId: entity.ownerUserId,
        name: entity.name,
        phone: entity.phone,
        email: entity.email,
        photo: entity.photo,
        notes: entity.notes,
        tags: entity.tags,
        address: entity.address,
        country: entity.country,
        active: entity.active,
        isContactRole: entity.isContactRole,
        createdAt: entity.createdAt,
        deactivatedAt: entity.deactivatedAt,
      );
}
