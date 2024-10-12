import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:personal_finance/data/database.dart';
import 'package:personal_finance/model/transaction.dart';
import 'package:personal_finance/utils/functions.dart';

class TransactionViewModel extends ChangeNotifier {
  bool isLoading = true;
  final AppDatabase _db;

  List<TransactionItem> transactions = [];
  List<Transaction> transactionsGrouped = [];

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

    var tmp = await trans.get();

    for (var t in tmp) {
      var selectedCategory = _db.select(_db.categoryItems)
        ..where((c) => c.id.equals(t.category));
      var catName = await selectedCategory.getSingle();

      var selectedCurrency = _db.select(_db.currencyItems)
        ..where((c) => c.id.equals(t.currency));
      var currencyName =
          await selectedCurrency.getSingle().then((value) => value.symbol);

      transactionsGrouped.add(Transaction(
        id: t.id.toString(),
        amount: t.amount,
        date: t.date,
        note: t.note,
        categoryId: t.category,
        categoryName: catName.name,
        categoryIcon: Icons.local_grocery_store_outlined,
        categoryColor: Colors.red,
        currencyId: t.currency,
        currencyName: currencyName,
      ));
    }

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
