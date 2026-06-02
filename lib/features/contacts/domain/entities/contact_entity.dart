import 'package:equatable/equatable.dart';

class ContactEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? company;
  final String? avatarUrl;
  final DateTime createdAt;

  const ContactEntity({
    required this.id, required this.name, required this.email,
    this.phone, this.company, this.avatarUrl, required this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, email, phone, company, avatarUrl, createdAt];
}
