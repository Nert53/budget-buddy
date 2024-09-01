import 'package:flutter/material.dart';

class AddModalBottom extends StatelessWidget {
  const AddModalBottom({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
  });

  final double screenHeight;
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: screenHeight * 0.65,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 48,
              width: screenWidth,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(28.0),
                  topRight: Radius.circular(28.0),
                ),
              ),
              child: Center(
                  child: Text(
                'Add Transaction',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              )),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.error,
                      side: BorderSide(
                          color: Theme.of(context).colorScheme.error)),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Discard'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                    onPressed: () {},
                    child: const Text('Save Transaction')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
