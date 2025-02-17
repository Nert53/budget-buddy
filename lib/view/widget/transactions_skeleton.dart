import 'package:flutter/material.dart';

class TransactionsSkeleton extends StatelessWidget {
  const TransactionsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text('Name of transaction'),
              leading: const Icon(Icons.category_outlined),
              subtitle: const Text('01. 01. 1970'),
              trailing: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.arrow_drop_down,
                  ),
                  SizedBox(width: 8),
                  Text('Amount'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
