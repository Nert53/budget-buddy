import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_finance/constants.dart';
import 'package:personal_finance/view/nav_destinations.dart';
import 'package:personal_finance/view/widget/add_transaction_dialog.dart';

class ScreenContainer extends StatelessWidget {
  const ScreenContainer({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    bool mediumScreen =
        screenWidth > mediumScreenWidth && screenWidth < largeScreenWidth;
    bool largeScreen = screenWidth > largeScreenWidth;

    bool graphsActive = navigationShell.currentIndex == 2;
    bool settingsActive = navigationShell.currentIndex == 3;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Budget Buddy',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Row(
        children: [
          if (mediumScreen || largeScreen)
            NavigationRail(
              selectedIndex: navigationShell.currentIndex,
              elevation: 5,
              labelType: largeScreen ? null : NavigationRailLabelType.all,
              extended: largeScreen,
              selectedLabelTextStyle: TextStyle(
                color: Theme.of(context).textTheme.labelMedium?.color,
                fontWeight: FontWeight.bold,
              ),
              leading: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SizedBox(
                  width: largeScreen ? 256 - 32 : null,
                  child: FloatingActionButton.extended(
                    elevation: 3,
                    label: largeScreen
                        ? const Text('Add Transaction')
                        : const Text('Add'),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    onPressed: () {
                      showDialog<void>(
                        context: context,
                        builder: (BuildContext context) {
                          if (screenWidth < mediumScreenWidth) {
                            return const AddWindowFullScreen();
                          } else {
                            return const AddWindow();
                          }
                        },
                      );
                    },
                    icon: const Icon(Icons.add),
                  ),
                ),
              ),
              destinations: destinations.map<NavigationRailDestination>((d) {
                return NavigationRailDestination(
                  icon: Icon(d.icon),
                  label: Text(d.label),
                  selectedIcon: Icon(d.selectedIcon),
                );
              }).toList(),
              onDestinationSelected: (int index) {
                navigationShell.goBranch(index);
              },
            ),
          Flexible(child: navigationShell)
        ],
      ),
      bottomNavigationBar: mediumScreen || largeScreen
          ? null
          : NavigationBar(
              destinations: destinations.map<NavigationDestination>((d) {
                return NavigationDestination(
                  icon: Icon(d.icon),
                  selectedIcon: Icon(d.selectedIcon),
                  label: d.label,
                );
              }).toList(),
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: (int index) {
                navigationShell.goBranch(index);
              },
            ),
      floatingActionButton:
          mediumScreen || largeScreen || settingsActive || graphsActive
              ? null
              : FloatingActionButton(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  onPressed: () {
                    showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        if (screenWidth < mediumScreenWidth) {
                          return const AddWindowFullScreen();
                        } else {
                          return const AddWindow();
                        }
                      },
                    );
                  },
                  child: const Icon(Icons.add),
                ),
    );
  }
}

/* -----------------------------------------------------------------------------
//! not in use

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
    const TransactionScreen(),
    const GraphScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    bool wideScreen = screenWidth > mediumScreenWidth;

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
                  onPressed: () {
                    showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return const AddModalWindow();
                      },
                    );
                  },
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
      bottomNavigationBar: wideScreen
          ? null
          : NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: onDestinationSelected,
              height: 80,
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

*/