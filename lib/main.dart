import 'package:flutter/material.dart';
import 'package:personal_finance/data/database.dart';
import 'package:personal_finance/view/screen/main_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(Provider<AppDatabase>(
    create: (context) => AppDatabase(),
    child: const PersonalFinanceApp(),
    dispose: (context, db) => db.close(),
  ));
}

class PersonalFinanceApp extends StatelessWidget {
  const PersonalFinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Finance',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0x007fb9ae)),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}
