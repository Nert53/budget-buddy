import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: ListTile(
              title: Text('Transaction $index'),
              leading: const Icon(Icons.food_bank_outlined),
              trailing: Text(
                '\$${index * 10}',
                style: TextStyle(color: Colors.red),
              ),
            ),
          );
        },
      ),
    );
  }
}
