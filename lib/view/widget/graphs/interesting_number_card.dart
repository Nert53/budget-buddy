import 'package:flutter/material.dart';
import 'package:personal_finance/constants.dart';
import 'package:personal_finance/utils/functions.dart';

class InterestingNumberCardHorizontal extends StatelessWidget {
  final double numberValue;
  final String valueName;
  final String numberSymbol;
  final bool largeScreen;
  final bool noData;
  final int coloredStyle;

  const InterestingNumberCardHorizontal({
    super.key,
    required this.valueName,
    required this.numberValue,
    required this.numberSymbol,
    required this.largeScreen,
    this.noData = false,
    this.coloredStyle = 0,
  });

  @override
  Widget build(BuildContext context) {
    String prettyNumberValue = amountPretty(numberValue);

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
                          fontStyle: FontStyle.italic,
                        ),
                      )
                    : Text(
                        '$prettyNumberValue $numberSymbol',
                        style: coloredStyle == 1
                            ? TextStyle(
                                fontSize: largeScreen ? 38 : 28,
                                color: successColor,
                              )
                            : coloredStyle == 2
                                ? TextStyle(
                                    fontSize: largeScreen ? 38 : 28,
                                    color: warningColor,
                                  )
                                : coloredStyle == 3
                                    ? TextStyle(
                                        fontSize: largeScreen ? 38 : 28,
                                        color:
                                            Theme.of(context).colorScheme.error,
                                      )
                                    : TextStyle(
                                        fontSize: largeScreen ? 38 : 28,
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
  final double numberValue;
  final String valueName;
  final String numberSymbol;
  final bool largeScreen;
  final bool noData;
  final int coloredStyle;

  const InterestingNumberCardVertical({
    super.key,
    required this.valueName,
    required this.numberValue,
    required this.numberSymbol,
    required this.largeScreen,
    this.noData = false,
    this.coloredStyle = 0,
  });

  @override
  Widget build(BuildContext context) {
    String prettyNumberValue = amountPretty(numberValue);

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
                          fontStyle: FontStyle.italic,
                        ),
                      )
                    : Text(
                        '$prettyNumberValue $numberSymbol',
                        style: TextStyle(
                          fontSize: largeScreen ? 44 : 32,
                          color: coloredStyle == 1
                              ? successColor
                              : coloredStyle == 2
                                  ? warningColor
                                  : coloredStyle == 3
                                      ? Theme.of(context).colorScheme.error
                                      : Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.color,
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
