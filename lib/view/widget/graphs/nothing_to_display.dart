import 'package:flutter/material.dart';

class NothingToDisplay extends StatelessWidget {
  const NothingToDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Center(
            child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'No data to display',
        ),
        SizedBox(width: 8.0),
        Icon(
          Icons.sentiment_dissatisfied,
        )
      ],
    )));
  }
}
