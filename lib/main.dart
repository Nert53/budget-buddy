import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_finance/data/database.dart';
import 'package:personal_finance/view/screen/dashboard_screen.dart';
import 'package:personal_finance/view/screen/graph_screen.dart';
import 'package:personal_finance/view/screen/screen_container.dart';
import 'package:personal_finance/view/screen/settings_screen.dart';
import 'package:personal_finance/view/screen/transaction_screen.dart';
import 'package:personal_finance/view_model/add_transaction_viewmodel.dart';
import 'package:personal_finance/view_model/dashboard_viewmodel.dart';
import 'package:personal_finance/view_model/transaction_viewmodel.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    Provider<AppDatabase>(
      create: (_) => AppDatabase(),
    ),
    ChangeNotifierProvider<TransactionViewModel>(
      create: (context) => TransactionViewModel(context.read<AppDatabase>()),
    ),
    ChangeNotifierProvider(
        create: (context) => DashboardViewmodel(context.read<AppDatabase>())),
    ChangeNotifierProvider<AddTransactionViewModel>(
      create: (context) => AddTransactionViewModel(context.read<AppDatabase>()),
    ),
  ], child: const PersonalFinanceApp()));
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/dashboard',
    routes: [
      StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return ScreenContainer(navigationShell: navigationShell);
          },
          branches: [
            StatefulShellBranch(routes: <RouteBase>[
              GoRoute(
                path: '/dashboard',
                builder: (BuildContext context, GoRouterState state) {
                  return const DashboardScreen();
                },
              ),
            ]),
            StatefulShellBranch(routes: <RouteBase>[
              GoRoute(
                path: '/transactions',
                builder: (BuildContext context, GoRouterState state) {
                  return const TransactionScreen();
                },
              )
            ]),
            StatefulShellBranch(routes: <RouteBase>[
              GoRoute(
                path: '/graphs',
                builder: (BuildContext context, GoRouterState state) {
                  return const GraphScreen();
                },
              ),
            ]),
            StatefulShellBranch(routes: <RouteBase>[
              GoRoute(
                path: '/settings',
                builder: (BuildContext context, GoRouterState state) {
                  return SettingsScreen();
                },
              ),
            ])
          ]),
    ]);

class PersonalFinanceApp extends StatelessWidget {
  const PersonalFinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Personal Finance',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0x007fb9ae)),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}
