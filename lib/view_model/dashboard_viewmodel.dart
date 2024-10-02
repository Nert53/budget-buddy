import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:personal_finance/data/database.dart';

class DashboardViewmodel extends ChangeNotifier {
  bool isLoading = true;
  final AppDatabase _db;

  double accountBalance = 0.0;
  double thisMonthBalance = 0.0;
  Future<List<TransactionItem>> lastFiveTransactions = Future.value([]);
  Future<List<TransactionItem>> lastTransactions = Future.value([]);

  int currentMonth = DateTime.now().month;
  int currentYear = DateTime.now().year;

  DashboardViewmodel(this._db) {
    _db.watchAllTransactions().listen((event) {
      getAllData();
    });
    notifyListeners();
  }

  getAllData() {
    getAccountBalance();
    getLastNTransactions(5);
    getThisMonthBalance();
    isLoading = false;
  }

  getAccountBalance() async {
    List<TransactionItem> allTransactions =
        await _db.select(_db.transactionItems).get();
    accountBalance = allTransactions.fold(
        0, (previousValue, element) => previousValue + element.amount);
    notifyListeners();
  }

  getLastNTransactions(int n) {
    final query = _db.select(_db.transactionItems)
      ..orderBy([
        (transaction) =>
            OrderingTerm(expression: transaction.date, mode: OrderingMode.desc)
      ])
      ..limit(n);
    lastTransactions = query.get();
    notifyListeners();
  }

  getThisMonthBalance() {
    //TODO only outcomes

    final query = _db.select(_db.transactionItems)
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
