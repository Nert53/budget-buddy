import 'package:flutter/material.dart';
import 'package:personal_finance/view/screen/main_screen.dart';
import 'package:personal_finance/view_model/transaction_viewmodel.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => TransactionViewModel(),
      child: const PersonalFinanceApp()));
}

class PersonalFinanceApp extends StatelessWidget {
  const PersonalFinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Finance',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}
