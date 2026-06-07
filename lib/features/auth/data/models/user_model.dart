import 'package:contactando/core/constants/remote_constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    super.fullName,
    super.avatarUrl,
  });

  factory UserModel.fromSupabaseUser(sb.User user) {
    return UserModel(
      id: user.id,
      email: user.email ?? '',
      fullName: user.userMetadata?[RC.fullName] as String?,
      avatarUrl: user.userMetadata?[RC.avatarUrl] as String?,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json[RC.id] as String,
      email: json[RC.email] as String,
      fullName: json[RC.fullName] as String?,
      avatarUrl: json[RC.avatarUrl] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'full_name': fullName,
        'avatar_url': avatarUrl,
      };
}
