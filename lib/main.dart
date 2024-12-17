import 'package:drift_db_viewer/drift_db_viewer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_finance/data/database.dart';
import 'package:personal_finance/theme/theme_provider.dart';
import 'package:personal_finance/view/screen/dashboard_screen.dart';
import 'package:personal_finance/view/screen/edit_categories_screen.dart';
import 'package:personal_finance/view/screen/graph_screen.dart';
import 'package:personal_finance/view/screen/screen_container.dart';
import 'package:personal_finance/view/screen/settings_screen.dart';
import 'package:personal_finance/view/screen/transactions_screen.dart';
import 'package:personal_finance/view_model/add_transaction_viewmodel.dart';
import 'package:personal_finance/view_model/dashboard_viewmodel.dart';
import 'package:personal_finance/view_model/edit_categories_viewmodel.dart';
import 'package:personal_finance/view_model/graph_viewmodel.dart';
import 'package:personal_finance/view_model/settings_viewmodel.dart';
import 'package:personal_finance/view_model/transactions_viewmodel.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    Provider<AppDatabase>(
      create: (_) => AppDatabase(),
    ),
    ChangeNotifierProvider(create: (context) => ThemeProvider()),
    ChangeNotifierProvider<TransactionViewModel>(
      create: (context) => TransactionViewModel(context.read<AppDatabase>()),
    ),
    ChangeNotifierProvider(
        create: (context) => DashboardViewmodel(context.read<AppDatabase>())),
    ChangeNotifierProvider<AddTransactionViewModel>(
      create: (context) => AddTransactionViewModel(context.read<AppDatabase>()),
    ),
    ChangeNotifierProvider<GraphViewModel>(
      create: (context) => GraphViewModel(context.read<AppDatabase>()),
    ),
    ChangeNotifierProvider<SettingsViewmodel>(
        create: (context) => SettingsViewmodel(context.read<AppDatabase>())),
    ChangeNotifierProvider(
        create: (context) =>
            EditCategoriesViewmodel(context.read<AppDatabase>())),
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
                  return DashboardScreen();
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
            ]),
          ]),
      GoRoute(
          path: '/edit-categories',
          builder: (BuildContext context, GoRouterState state) {
            return EditCategoriesScreen();
          }),
      GoRoute(
        path: '/database',
        builder: (BuildContext context, GoRouterState state) {
          final db = AppDatabase();
          return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.home),
                  onPressed: () {
                    context.go('/dashboard');
                  },
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              body: DriftDbViewer(db));
        },
      ),
    ]);

class PersonalFinanceApp extends StatelessWidget {
  const PersonalFinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Budget Buddy',
      theme: Provider.of<ThemeProvider>(context).themeData,
      routerConfig: _router,
    );
  }
}

// const Color(0x007fb9ae)