import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.settings_outlined, size: 48, color: Colors.grey),
          SizedBox(height: 12),
          Text('Ajustes', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
