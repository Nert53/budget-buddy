import 'package:flutter/material.dart';
import 'package:personal_finance/constants.dart';
import 'package:personal_finance/view/screen/dashboard_screen.dart';
import 'package:personal_finance/view/nav_destinations.dart';
import 'package:personal_finance/view/screen/graph_screen.dart';
import 'package:personal_finance/view/screen/history_screen.dart';
import 'package:personal_finance/view/widget/add_modal_bottom.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _screens = <Widget>[
    const DashboardScreen(),
    const HistoryScreen(),
    const GraphScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    bool wideScreen = screenWidth > laptopScreenWidth;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Personal Finance',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (wideScreen)
            NavigationRail(
              selectedIndex: _selectedIndex,
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
                  selectedIcon: Icon(d.selectedIcon),
                );
              }).toList(),
              onDestinationSelected: onDestinationSelected,
            ),
          _screens[_selectedIndex]
        ],
      ),
      floatingActionButton: wideScreen
          ? null
          : FloatingActionButton(
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return AddModalBottom(
                        screenHeight: screenHeight, screenWidth: screenWidth);
                  },
                );
              },
              child: const Icon(Icons.add),
            ),
      bottomNavigationBar: wideScreen
          ? null
          : NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: onDestinationSelected,
              height: 70,
              destinations: destinations.map<NavigationDestination>((d) {
                return NavigationDestination(
                  icon: Icon(d.icon),
                  selectedIcon: Icon(d.selectedIcon),
                  label: d.label,
                );
              }).toList(),
            ),
    );
  }
}
