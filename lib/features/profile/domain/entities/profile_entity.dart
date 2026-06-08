import 'package:equatable/equatable.dart';

/// Perfil del usuario autenticado.
/// Corresponde a la fila de la tabla `contact` donde isContactRole = false.
class ProfileEntity extends Equatable {
  const ProfileEntity({
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

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  ProfileEntity copyWith({
    String? id,
    String? ownerUserId,
    String? name,
    String? phone,
    String? email,
    String? photo,
    String? notes,
    String? address,
    String? country,
    DateTime? createdAt,
  }) =>
      ProfileEntity(
        id: id ?? this.id,
        ownerUserId: ownerUserId ?? this.ownerUserId,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        photo: photo ?? this.photo,
        notes: notes ?? this.notes,
        address: address ?? this.address,
        country: country ?? this.country,
        createdAt: createdAt ?? this.createdAt,
      );

  @override
  List<Object?> get props => [
    id, ownerUserId, name, phone, email,
    photo, notes, address, country, createdAt,
  ];
}