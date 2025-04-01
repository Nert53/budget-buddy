import 'package:flutter/material.dart';
import 'package:personal_finance/utils/functions.dart';

class InterestingNumberCardHorizontal extends StatelessWidget {
  final double numberValue;
  final String valueName;
  final String numberSymbol;
  final bool largeScreen;
  final bool noData;

  const InterestingNumberCardHorizontal({
    super.key,
    required this.valueName,
    required this.numberValue,
    required this.numberSymbol,
    required this.largeScreen,
    this.noData = false,
  });

  @override
  Widget build(BuildContext context) {
    String prettyNumberValue = '';
    if (numberSymbol.compareTo('CZK') == 0) {
      prettyNumberValue = amountPretty(numberValue);
    } else {
      prettyNumberValue = numberValue.toString();
    }

    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 6.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        height: 260,
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(valueName,
                style:
                    TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal)),
            Expanded(
              child: Center(
                child: noData
                    ? Text(
                        'No data to display.',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary),
                      )
                    : Text(
                        '$prettyNumberValue $numberSymbol',
                        style: TextStyle(
                          fontSize: largeScreen ? 40 : 28,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InterestingNumberCardVertical extends StatelessWidget {
  final bool largeScreen;
  final String numberValue;
  final String valueName;
  final String numberSymbol;
  final bool noData;

  const InterestingNumberCardVertical({
    super.key,
    required this.valueName,
    required this.numberValue,
    required this.numberSymbol,
    required this.largeScreen,
    this.noData = false,
  });

  @override
  Widget build(BuildContext context) {
    String prettyNumberValue = '';
    if (numberSymbol.compareTo('CZK') == 0) {
      prettyNumberValue = amountPretty(double.parse(numberValue));
    } else {
      prettyNumberValue = numberValue;
    }

    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 6.0, horizontal: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        height: 200,
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(valueName,
                style:
                    TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal)),
            Expanded(
              child: Center(
                child: noData
                    ? Text(
                        'No data to display.',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      )
                    : Text(
                        '$prettyNumberValue $numberSymbol',
                        style: TextStyle(
                          fontSize: largeScreen ? 44 : 32,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
