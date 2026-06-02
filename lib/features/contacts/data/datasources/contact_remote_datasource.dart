import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/remote_constants.dart';
import '../models/contact_model.dart';

abstract interface class ContactRemoteDatasource {
  Future<List<ContactModel>> getContacts(String userId);
  Future<ContactModel> getContactById(String id);
  Future<ContactModel> createContact(ContactModel contact);
  Future<ContactModel> updateContact(ContactModel contact);
  Future<void> deleteContact(String id);
}

@Injectable(as: ContactRemoteDatasource)
class SupabaseContactDatasource implements ContactRemoteDatasource {
  SupabaseContactDatasource(this._supabase);
  final SupabaseClient _supabase;

  @override
  Future<List<ContactModel>> getContacts(String userId) async {
    final data = await _supabase
        .from(RC.tableContact)
        .select()
        .eq(RC.contactOwnerUserId, userId)
        .eq(RC.active, true);

    return data.map((e) => ContactModel.fromJson(e)).toList();
  }

  @override
  Future<ContactModel> getContactById(String id) async {
    final data = await _supabase
        .from(RC.tableContact)
        .select()
        .eq(RC.id, id)
        .single();
    return ContactModel.fromJson(data);
  }

  @override
  Future<ContactModel> createContact(ContactModel contact) async {
    final data = await _supabase
        .from(RC.tableContact)
        .insert(contact.toJson())
        .select()
        .single();
    return ContactModel.fromJson(data);
  }

  @override
  Future<ContactModel> updateContact(ContactModel contact) async {
    final data = await _supabase
        .from(RC.tableContact)
        .update(contact.toJson())
        .eq(RC.id, contact.id)
        .select()
        .single();
    return ContactModel.fromJson(data);
  }

  @override
  Future<void> deleteContact(String id) async {
    await _supabase
        .from(RC.tableContact)
        .delete()
        .eq(RC.id, id);
  }
}