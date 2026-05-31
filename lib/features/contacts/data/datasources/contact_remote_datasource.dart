import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/contact_model.dart';

abstract interface class ContactRemoteDatasource {
  Future<List<ContactModel>> getContacts();
  Future<ContactModel> getContactById(String id);
  Future<ContactModel> createContact(ContactModel contact);
  Future<ContactModel> updateContact(ContactModel contact);
  Future<void> deleteContact(String id);
}

@Injectable(as: ContactRemoteDatasource)
class SupabaseContactDatasource implements ContactRemoteDatasource {
  SupabaseContactDatasource(this._supabase);
  final SupabaseClient _supabase;
  static const _table = 'contacts';

  @override
  Future<List<ContactModel>> getContacts() async {
    final data = await _supabase.from(_table).select().order('name');
    return (data as List).map((e) => ContactModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<ContactModel> getContactById(String id) async {
    final data = await _supabase.from(_table).select().eq('id', id).single();
    return ContactModel.fromJson(data);
  }

  @override
  Future<ContactModel> createContact(ContactModel contact) async {
    final data = await _supabase.from(_table).insert(contact.toJson()).select().single();
    return ContactModel.fromJson(data);
  }

  @override
  Future<ContactModel> updateContact(ContactModel contact) async {
    final data = await _supabase.from(_table).update(contact.toJson()).eq('id', contact.id).select().single();
    return ContactModel.fromJson(data);
  }

  @override
  Future<void> deleteContact(String id) async {
    await _supabase.from(_table).delete().eq('id', id);
  }
}
