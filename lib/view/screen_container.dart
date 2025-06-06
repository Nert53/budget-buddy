import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:personal_finance/constants.dart';
import 'package:personal_finance/view/constants/nav_destinations.dart';
import 'package:personal_finance/view/widgets/dialogs/add_transaction_dialog.dart';

class ScreenContainer extends StatelessWidget {
  const ScreenContainer({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    bool smallScreen = screenWidth < mediumScreenWidth;
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
                          if (smallScreen) {
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
              trailing: largeScreen
                  ? Expanded(
                      child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color:
                              Theme.of(context).colorScheme.secondaryContainer,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              DateFormat('EEEE').format(DateTime.now()),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              DateFormat('dd. MMMM y').format(DateTime.now()),
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w100),
                            ),
                          ],
                        ),
                      ),
                    ))
                  : null,
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
      bottomNavigationBar: mediumScreen || (screenWidth > largeScreenWidth)
          ? null
          : NavigationBar(
              destinations:
                  destinations.map<NavigationDestination>((destination) {
                return NavigationDestination(
                  icon: Icon(destination.icon),
                  selectedIcon: Icon(destination.selectedIcon),
                  label: destination.label,
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
                        if (smallScreen) {
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
