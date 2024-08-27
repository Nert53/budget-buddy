import 'package:flutter/material.dart';
import 'package:personal_finance/destinations.dart';

class DasahboardScreen extends StatelessWidget {
  const DasahboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    bool wideScreen = screenWidth > 600;
    bool reallyWideScreen = screenWidth > 900;

    var railDestinations = destinations.map<NavigationRailDestination>((d) {
      return NavigationRailDestination(
        icon: Icon(d.icon),
        label: Text(d.label),
      );
    }).toList();

    railDestinations.insert(
      0,
      NavigationRailDestination(
        icon: Icon(Icons.add),
        label: const Text('Add'),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Finance'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        leading: IconButton(
          icon: const Icon(Icons.account_circle_outlined),
          onPressed: () {},
        ),
      ),
      floatingActionButton: wideScreen
          ? null
          : FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.add),
            ),
      bottomNavigationBar: wideScreen
          ? null
          : NavigationBar(
              destinations: destinations.map<NavigationDestination>((d) {
                return NavigationDestination(
                  icon: Icon(d.icon),
                  label: d.label,
                );
              }).toList(),
            ),
      body: Row(
        children: [
          if (wideScreen)
            NavigationRail(
              selectedIndex: 0,
              labelType: NavigationRailLabelType.all,
              elevation: 5,
              leading: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: FloatingActionButton.extended(
                  elevation: 3,
                  label: const Text('Add'),
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                ),
              ),
              destinations: destinations.map<NavigationRailDestination>((d) {
                return NavigationRailDestination(
                  icon: Icon(d.icon),
                  label: Text(d.label),
                );
              }).toList(),
              onDestinationSelected: (int index) {},
            ),
        ],
      ),
    );
  }
}
