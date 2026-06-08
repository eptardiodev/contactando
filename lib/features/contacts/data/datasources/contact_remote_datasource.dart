import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/remote_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/contact_model.dart';

abstract interface class ContactRemoteDatasource {
  Future<List<ContactModel>> getContacts(String userId);
  Future<ContactModel> getContactById(String id);
  Future<List<ContactModel>> searchContacts({
    required String userId,
    required String query,
  });
  Future<List<ContactModel>> getContactsByTag({
    required String userId,
    required String tag,
  });
  Future<List<ContactModel>> getContactsByCountry({
    required String userId,
    required String country,
  });
  Future<int> getTotalContacts(String userId);
  Future<List<String>> getUniqueTags(String userId);
  Future<List<String>> getUniqueCountries(String userId);
  Future<ContactModel> createContact(ContactModel contact);
  Future<ContactModel> updateContact(ContactModel contact);

  /// Soft-delete: active = false, deactivated_at = now().
  Future<ContactModel> deleteContact(String id);
}

@Injectable(as: ContactRemoteDatasource)
class SupabaseContactDatasource implements ContactRemoteDatasource {
  const SupabaseContactDatasource(this._supabase);
  final SupabaseClient _supabase;

  // ── Helpers ───────────────────────────────────────────────────────────────

  /// Base query: solo contactos activos con isContactRole = true del userId.
  PostgrestFilterBuilder<List<Map<String, dynamic>>> _baseContactsQuery(
    String userId,
  ) =>
      _supabase
          .from(RC.tableContact)
          .select()
          .eq(RC.contactOwnerUserId, userId)
          .eq(RC.contactIsContactRole, true)
          .eq(RC.active, true);

  // ── Lectura ───────────────────────────────────────────────────────────────

  @override
  Future<List<ContactModel>> getContacts(String userId) async {
    try {
      final data = await _baseContactsQuery(userId).order(RC.contactName);
      return data.map(ContactModel.fromJson).toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ContactModel> getContactById(String id) async {
    try {
      final data = await _supabase
          .from(RC.tableContact)
          .select()
          .eq(RC.id, id)
          .single();
      return ContactModel.fromJson(data);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<ContactModel>> searchContacts({
    required String userId,
    required String query,
  }) async {
    try {
      final data = await _supabase
          .from(RC.tableContact)
          .select()
          .eq(RC.contactOwnerUserId, userId)
          .eq(RC.contactIsContactRole, true)
          .eq(RC.active, true)
          .or(
            '${RC.contactName}.ilike.%$query%,'
            '${RC.contactPhone}.ilike.%$query%,'
            '${RC.contactEmail}.ilike.%$query%',
          )
          .order(RC.contactName);
      return data.map(ContactModel.fromJson).toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<ContactModel>> getContactsByTag({
    required String userId,
    required String tag,
  }) async {
    try {
      final data = await _baseContactsQuery(userId)
          .textSearch(RC.contactTags, tag)
          .order(RC.contactName);
      return data.map(ContactModel.fromJson).toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<ContactModel>> getContactsByCountry({
    required String userId,
    required String country,
  }) async {
    try {
      final data = await _baseContactsQuery(userId)
          .eq(RC.contactCountry, country)
          .order(RC.contactName);
      return data.map(ContactModel.fromJson).toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // ── Estadísticas ──────────────────────────────────────────────────────────

  @override
  Future<int> getTotalContacts(String userId) async {
    try {
      final response = await _supabase
          .from(RC.tableContact)
          .select()
          .eq(RC.contactOwnerUserId, userId)
          .eq(RC.contactIsContactRole, true)
          .eq(RC.active, true)
          .count(CountOption.exact);
      return response.count;
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<String>> getUniqueTags(String userId) async {
    try {
      final data = await _supabase
          .from(RC.tableContact)
          .select(RC.contactTags)
          .eq(RC.contactOwnerUserId, userId)
          .eq(RC.active, true)
          .not(RC.contactTags, 'is', null);

      final tags = <String>{};
      for (final item in data) {
        final raw = item[RC.contactTags] as String?;
        if (raw != null && raw.isNotEmpty) {
          tags.addAll(raw.split(',').map((t) => t.trim()).where((t) => t.isNotEmpty));
        }
      }
      return tags.toList()..sort();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<String>> getUniqueCountries(String userId) async {
    try {
      final data = await _supabase
          .from(RC.tableContact)
          .select(RC.contactCountry)
          .eq(RC.contactOwnerUserId, userId)
          .eq(RC.active, true)
          .not(RC.contactCountry, 'is', null)
          .order(RC.contactCountry);

      final countries = <String>{};
      for (final item in data) {
        final c = item[RC.contactCountry] as String?;
        if (c != null && c.isNotEmpty) countries.add(c);
      }
      return countries.toList()..sort();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // ── Escritura ─────────────────────────────────────────────────────────────

  @override
  Future<ContactModel> createContact(ContactModel contact) async {
    try {
      final data = await _supabase
          .from(RC.tableContact)
          .insert(contact.toJson())
          .select()
          .single();
      return ContactModel.fromJson(data);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ContactModel> updateContact(ContactModel contact) async {
    try {
      final data = await _supabase
          .from(RC.tableContact)
          .update(contact.toJson())
          .eq(RC.id, contact.id)
          .select()
          .single();
      return ContactModel.fromJson(data);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ContactModel> deleteContact(String id) async {
    try {
      final data = await _supabase
          .from(RC.tableContact)
          .update({
            RC.active: false,
            RC.contactDeactivatedAt: DateTime.now().toIso8601String(),
          })
          .eq(RC.id, id)
          .select()
          .single();
      return ContactModel.fromJson(data);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
