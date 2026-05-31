import 'package:flutter/material.dart';

/// TODO (Fase 4): Migrar tu TransactionsScreen aquí.
class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined, size: 48, color: Colors.grey),
          SizedBox(height: 12),
          Text('Transacciones', style: TextStyle(color: Colors.grey)),
          Text('Migrar tu TransactionsScreen aquí',
              style: TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}
