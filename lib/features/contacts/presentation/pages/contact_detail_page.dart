import 'package:flutter/material.dart';
// TODO: Implementar ContactDetailPage.
// Recibe contactId desde GoRouter path parameters.
class ContactDetailPage extends StatelessWidget {
  const ContactDetailPage({required this.contactId, super.key});
  final String contactId;
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text('Contact $contactId')), body: const Center(child: Text('Contact Detail — TODO')));
}
