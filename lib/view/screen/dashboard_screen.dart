import 'package:flutter/material.dart';
import 'package:personal_finance/constants.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DasahboardScreenState();
}

class _DasahboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    bool wideScreen = screenWidth > laptopScreenWidth;
    double contentWidth =
        screenWidth - (wideScreen ? (navigationRailWidth + 32) : 32);

    return Padding(
      padding: const EdgeInsets.only(
          left: 16.0, right: 16.0, top: 16.0, bottom: 16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Text('Sidebar'),
              height: 200,
              width: contentWidth,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainer,
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 1),
                    blurRadius: 5.0,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Container(
                  child: Text('Content'),
                  height: 200,
                  width: contentWidth / 2 - 8,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 1),
                        blurRadius: 5.0,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16.0),
                Container(
                  child: Text('Content'),
                  height: 200,
                  width: contentWidth / 2 - 8,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 1),
                        blurRadius: 5.0,
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
