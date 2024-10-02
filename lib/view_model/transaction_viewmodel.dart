import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:personal_finance/data/database.dart';

class TransactionViewModel extends ChangeNotifier {
  bool isLoading = true;
  final AppDatabase _db;

  List<TransactionItem> transactions = [];

  int currentMonth = DateTime.now().month;
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
    transactions.add(TransactionItem(
      id: 'aegaegwhjt38957',
      amount: 25,
      date: DateTime.now(),
      note: 'alaza',
      category: 'Elektro',
      currency: 'CZK',
    ));
    insertExample();

    notifyListeners();
  }

  getTransactions() async {
    transactions = await _db.select(_db.transactionItems).get();
    isLoading = false;

    notifyListeners();
  }

  deleteTransaction(TransactionItem transaction) async {
    await _db.delete(_db.transactionItems).delete(transaction);
    transactions.remove(transaction);
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  insertExample() async {
    await _db.into(_db.transactionItems).insert(
          TransactionItemsCompanion(
            amount: const Value(25),
            date: Value(DateTime.now()),
            note: const Value('alaza'),
            category: const Value('Elektro'),
            currency: const Value('CZK'),
          ),
        );
  }
}
