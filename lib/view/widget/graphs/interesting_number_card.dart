import 'package:flutter/material.dart';

class InterestingNumberCardHorizontal extends StatelessWidget {
  final String numberValue;
  final String valueName;
  final String numberSymbol;
  final bool largeScreen;

  const InterestingNumberCardHorizontal({
    super.key,
    required this.valueName,
    required this.numberValue,
    required this.numberSymbol,
    required this.largeScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        height: 316,
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Tooltip(
              message: 'Percentage is meauser from last 6 months.',
              child: Text(valueName,
                  style:
                      TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal)),
            ),
            Expanded(
              child: Center(
                child: Text(
                  '$numberValue $numberSymbol',
                  style: TextStyle(
                    fontSize: largeScreen ? 48 : 32,
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

  const InterestingNumberCardVertical({
    super.key,
    required this.valueName,
    required this.numberValue,
    required this.numberSymbol,
    required this.largeScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 6.0),
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
            Tooltip(
              message: 'Percentage is meauser from last 6 months.',
              child: Text(valueName,
                  style:
                      TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal)),
            ),
            Expanded(
              child: Center(
                child: Text(
                  '$numberValue $numberSymbol',
                  style: TextStyle(
                    fontSize: largeScreen ? 48 : 32,
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
