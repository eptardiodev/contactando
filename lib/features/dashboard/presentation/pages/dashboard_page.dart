import 'package:flutter/material.dart';

/// TODO (Fase 4): Migrar tu DashboardScreen aquí.
/// Este placeholder mantiene la app compilando mientras configuras la estructura.
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.dashboard_outlined, size: 48, color: Colors.grey),
          SizedBox(height: 12),
          Text('Dashboard', style: TextStyle(color: Colors.grey)),
          Text('Migrar tu DashboardScreen aquí',
              style: TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}
