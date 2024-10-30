import 'package:flutter/material.dart';

class SpendingDetailExtension extends StatelessWidget {
  final double containerHeight;

  const SpendingDetailExtension({super.key, required this.containerHeight});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(children: [
        Expanded(
          child: Container(
            height: containerHeight,
            color: Colors.red,
            child: Text('Today spent'),
          ),
        ),
        SizedBox(
          width: 16.0,
        ),
        Expanded(
          child: Container(
            height: containerHeight,
            color: Colors.red,
            child: Text('Predicted spent this month'),
          ),
        ),
      ]),
    );
  }
}
