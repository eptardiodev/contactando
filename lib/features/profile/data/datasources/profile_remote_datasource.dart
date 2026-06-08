import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/remote_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/profile_model.dart';

abstract interface class ProfileRemoteDatasource {
  /// Devuelve la fila contact donde owner_user_id = userId y isContactRole = false.
  Future<ProfileModel?> getProfile(String userId);

  Future<ProfileModel> updateProfile(ProfileModel profile);
}

@LazySingleton(as: ProfileRemoteDatasource)
class SupabaseProfileDatasource implements ProfileRemoteDatasource {
  const SupabaseProfileDatasource(this._supabase);
  final SupabaseClient _supabase;

  @override
  Future<ProfileModel?> getProfile(String userId) async {
    try {
      final data = await _supabase
          .from(RC.tableContact)
          .select()
          .eq(RC.contactOwnerUserId, userId)
          .eq(RC.contactIsContactRole, false)
          .eq(RC.active, true)
          .maybeSingle();

      return data != null ? ProfileModel.fromJson(data) : null;
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ProfileModel> updateProfile(ProfileModel profile) async {
    try {
      final data = await _supabase
          .from(RC.tableContact)
          .update(profile.toJson())
          .eq(RC.id, profile.id)
          .select()
          .single();
      return ProfileModel.fromJson(data);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}