import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:personal_finance/data/database.dart';
import 'package:personal_finance/model/transaction.dart';
import 'package:personal_finance/utils/functions.dart';

class TransactionViewModel extends ChangeNotifier {
  bool isLoading = true;
  final AppDatabase _db;

  List<Transaction> transactions = [];

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
    var transactionItems = await (_db.select(_db.transactionItems)
          ..where((t) => t.date.month.equals(currentMonth))
          ..where((t) => t.date.year.equals(currentYear))
          ..orderBy([
            (t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)
          ])) // Sort by date in descending order
        .get();

    transactions.clear();
    for (var t in transactionItems) {
      var category = await (_db.select(_db.categoryItems)
            ..where((c) => c.id.equals(t.category)))
          .getSingle();

      var selectedCurrency = _db.select(_db.currencyItems)
        ..where((c) => c.id.equals(t.currency));
      var currencyName =
          await selectedCurrency.getSingle().then((value) => value.symbol);

      transactions.add(Transaction(
        id: t.id.toString(),
        amount: t.amount,
        date: t.date,
        note: t.note,
        isOutcome: t.isOutcome,
        categoryId: t.category,
        categoryName: category.name,
        categoryIcon: convertIconNameToIcon(category.icon),
        categoryColor: Color(category.color),
        currencyId: t.currency,
        currencyName: currencyName,
      ));
    }

    transactions.sort((a, b) => b.date.compareTo(a.date));
    isLoading = false;

    notifyListeners();
  }

  deleteTransaction(TransactionItem transaction) async {
    await _db.delete(_db.transactionItems).delete(transaction);
    notifyListeners();
  }
}
