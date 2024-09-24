import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:personal_finance/data/database.dart';

class DashboardViewmodel extends ChangeNotifier {
  double accountBalance = 0.0;
  double thisMonthBalance = 0.0;
  int currentMonth = DateTime.now().month;
  int currentYear = DateTime.now().year;
  Future<List<TransactionItem>> lastFiveTransactions = Future.value([]);

  final appDB = AppDatabase();

  DashboardViewmodel() {
    getAccountBalance();
    getLastFiveTransactions();
    getThisMonthBalance();
  }

  getAccountBalance() async {
    List<TransactionItem> allTransactions =
        await appDB.select(appDB.transactionItems).get();
    accountBalance = allTransactions.fold(
        0, (previousValue, element) => previousValue + element.amount);
    notifyListeners();
  }

  getLastFiveTransactions() {
    final query = appDB.select(appDB.transactionItems)
      ..orderBy([
        (transaction) =>
            OrderingTerm(expression: transaction.date, mode: OrderingMode.desc)
      ])
      ..limit(5);
    lastFiveTransactions = query.get();
    notifyListeners();
  }

  getThisMonthBalance() {
    //TODO only outcomes

    final query = appDB.select(appDB.transactionItems)
      ..where((transaction) =>
          transaction.date.month.equals(currentMonth) &
          transaction.date.year.equals(currentYear));
    query.get().then((value) {
      thisMonthBalance = value.fold(
          0, (previousValue, element) => previousValue + element.amount);
    });
    notifyListeners();
  }
}
