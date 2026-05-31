import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// TODO (Fase 4): Migrar tu ProfileScreen aquí.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    return Scaffold(
      appBar: AppBar(title: const Text('Mi perfil')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person_outline, size: 48, color: Colors.grey),
            const SizedBox(height: 12),
            Text(user?.email ?? '', style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 4),
            const Text('Migrar tu ProfileScreen aquí',
                style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
