import '../../domain/entities/contact_entity.dart';

class ContactModel {
  const ContactModel({
    required this.id, required this.name, required this.email,
    this.phone, this.company, this.avatarUrl, required this.createdAt,
  });
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? company;
  final String? avatarUrl;
  final DateTime createdAt;

  factory ContactModel.fromJson(Map<String, dynamic> json) => ContactModel(
    id: json['id'] as String, name: json['name'] as String,
    email: json['email'] as String, phone: json['phone'] as String?,
    company: json['company'] as String?, avatarUrl: json['avatar_url'] as String?,
    createdAt: DateTime.parse(json['created_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id, 'name': name, 'email': email,
    if (phone != null) 'phone': phone,
    if (company != null) 'company': company,
    if (avatarUrl != null) 'avatar_url': avatarUrl,
    'created_at': createdAt.toIso8601String(),
  };

  ContactEntity toEntity() => ContactEntity(
    id: id, name: name, email: email, phone: phone,
    company: company, avatarUrl: avatarUrl, createdAt: createdAt,
  );
}
