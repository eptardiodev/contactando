import 'package:equatable/equatable.dart';

/// Entidad de dominio pura — sin dependencias de infraestructura.
/// Representa tanto un contacto del usuario (isContactRole: true)
/// como el propio usuario como contacto (isContactRole: false).
class ContactEntity extends Equatable {
  const ContactEntity({
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

  /// Etiquetas separadas por coma, p.ej. "familia,trabajo"
  final String? tags;
  final String? address;
  final String? country;
  final bool active;

  /// true  → es un contacto del usuario (aparece en la lista de contactos)
  /// false → es el propio usuario como contacto (datos de perfil)
  final bool isContactRole;

  final DateTime? createdAt;
  final DateTime? deactivatedAt;

  // ── Helpers ───────────────────────────────────────────────────────────────

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  List<String> get tagList =>
      tags?.split(',').map((t) => t.trim()).where((t) => t.isNotEmpty).toList() ??
      [];

  ContactEntity copyWith({
    String? id,
    String? ownerUserId,
    String? name,
    String? phone,
    String? email,
    String? photo,
    String? notes,
    String? tags,
    String? address,
    String? country,
    bool? active,
    bool? isContactRole,
    DateTime? createdAt,
    DateTime? deactivatedAt,
  }) =>
      ContactEntity(
        id: id ?? this.id,
        ownerUserId: ownerUserId ?? this.ownerUserId,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        photo: photo ?? this.photo,
        notes: notes ?? this.notes,
        tags: tags ?? this.tags,
        address: address ?? this.address,
        country: country ?? this.country,
        active: active ?? this.active,
        isContactRole: isContactRole ?? this.isContactRole,
        createdAt: createdAt ?? this.createdAt,
        deactivatedAt: deactivatedAt ?? this.deactivatedAt,
      );

  @override
  List<Object?> get props => [
        id, ownerUserId, name, phone, email, photo,
        notes, tags, address, country, active,
        isContactRole, createdAt, deactivatedAt,
      ];
}
