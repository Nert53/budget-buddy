import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:personal_finance/data/database.dart';
import 'package:personal_finance/utils/functions.dart';

class TransactionViewModel extends ChangeNotifier {
  bool isLoading = true;
  final AppDatabase _db;

  List<TransactionItem> transactions = [];

  int currentMonth = DateTime.now().month;
  String currentMonthString = convertMontNumToMonthName(DateTime.now().month);
  int currentYear = DateTime.now().year;

  TransactionViewModel(this._db) {
    _db.watchAllTransactions().listen((event) {
      getAllData();
    });
    notifyListeners();
  }

  getAllData() {
    getTransactions();
    isLoading = false;
  }

  refresh() {
    getTransactions();
    notifyListeners();
  }

  previousMonth() {
    if (currentMonth == 1) {
      currentMonth = 12;
      currentYear--;
    } else {
      currentMonth--;
    }
    currentMonthString = convertMontNumToMonthName(currentMonth);
    refresh();
  }

  nextMonth() {
    if (currentMonth == 12) {
      currentMonth = 1;
      currentYear++;
    } else {
      currentMonth++;
    }
    currentMonthString = convertMontNumToMonthName(currentMonth);
    refresh();
  }

  getTransactions() async {
    var trans = _db.select(_db.transactionItems)
      ..where((t) => t.date.month.equals(currentMonth))
      ..where((t) => t.date.year.equals(currentYear));

    transactions = await trans.get();

    // transactions = await _db.select(_db.transactionItems).get();
    isLoading = false;

    notifyListeners();
  }

  deleteTransaction(TransactionItem transaction) async {
    await _db.delete(_db.transactionItems).delete(transaction);
    transactions.remove(transaction);
    notifyListeners();
  }
}
