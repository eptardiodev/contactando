import 'package:flutter/material.dart';

/// TODO (Fase 4): Migrar tu ContactsScreen aquí.
class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 48, color: Colors.grey),
          SizedBox(height: 12),
          Text('Contactos', style: TextStyle(color: Colors.grey)),
          Text('Migrar tu ContactsScreen aquí',
              style: TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}
