import 'package:flutter/material.dart';
import 'package:personal_finance/data/database.dart';

class DashboardViewmodel extends ChangeNotifier {
  double accountBalance = 0.0;
  final appDB = AppDatabase();

  DashboardViewmodel() {
    getAccountBalance();
  }

  getAccountBalance() async {
    List<TransactionItem> allTransactions =
        await appDB.select(appDB.transactionItems).get();
    accountBalance = allTransactions.fold(
        0, (previousValue, element) => previousValue + element.amount);
    notifyListeners();
  }
}
