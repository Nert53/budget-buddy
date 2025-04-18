import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_finance/repository/database.dart';
import 'package:personal_finance/theme/theme_provider.dart';
import 'package:personal_finance/view/screen/dashboard_screen.dart';
import 'package:personal_finance/view/screen/edit_categories_screen.dart';
import 'package:personal_finance/view/screen/filter_transactions_screen.dart';
import 'package:personal_finance/view/screen/reports_screen.dart';
import 'package:personal_finance/view/screen_container.dart';
import 'package:personal_finance/view/screen/settings_screen.dart';
import 'package:personal_finance/view/screen/transactions_screen.dart';
import 'package:personal_finance/view_model/add_transaction_viewmodel.dart';
import 'package:personal_finance/view_model/dashboard_viewmodel.dart';
import 'package:personal_finance/view_model/edit_categories_viewmodel.dart';
import 'package:personal_finance/view_model/reports_viewmodel.dart';
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
    ChangeNotifierProvider<ReportsViewModel>(
      create: (context) => ReportsViewModel(context.read<AppDatabase>()),
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
                  return const ReportsScreen();
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
        path: '/filter-transactions',
        builder: (context, state) {
          return const FilterTransactionsScreen();
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
