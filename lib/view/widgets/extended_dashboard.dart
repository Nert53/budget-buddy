import 'package:flutter/material.dart';
import 'package:personal_finance/utils/functions.dart';

class SpendingDetailExtension extends StatelessWidget {
  final double containerHeight;
  final double todaySpent;
  final double predictedSpent;

  const SpendingDetailExtension(
      {super.key,
      required this.containerHeight,
      required this.todaySpent,
      required this.predictedSpent});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(children: [
        Expanded(
          child: Container(
            height: containerHeight,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.all(Radius.circular(16.0)),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0, 1),
                  blurRadius: 5.0,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Today spent',
                ),
                Expanded(
                    child: Center(
                  child: Text('${amountPretty(todaySpent)} CZK',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold)),
                )),
              ],
            ),
          ),
        ),
        SizedBox(
          width: 12.0,
        ),
        Expanded(
          child: Container(
            height: containerHeight,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.all(Radius.circular(16.0)),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0, 1),
                  blurRadius: 5.0,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Monthly spending prediction'),
                Expanded(
                    child: Center(
                        child: Text(
                  '${amountPretty(predictedSpent)} CZK',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
                ))),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
