import 'package:flutter/material.dart';

class MyNavigationBar extends StatelessWidget {
  const MyNavigationBar({
    super.key,
    required this.selectedIndex,
    this.onDestinationSelected, required this.destinations,
  });

  final int selectedIndex;
  final ValueChanged<int>? onDestinationSelected;

  final List<NavigationDestination> destinations;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      elevation: 0,
      destinations: destinations.map<NavigationDestination>((d) {
        return NavigationDestination(
          icon: d.icon,
          label: d.label,
        );
      }).toList(),
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
    );
  }
}
