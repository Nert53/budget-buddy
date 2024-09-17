import 'package:flutter/material.dart';
import 'package:personal_finance/data/database.dart';

class TransactionViewModel extends ChangeNotifier {
  bool isLoading = true;
  List<TransactionItem> transactions = [];
  final appDB = AppDatabase();

  TransactionViewModel() {
    getTransactions();
  }

  getTransactions() async {
    transactions = await appDB.select(appDB.transactionItems).get();
    notifyListeners();

    isLoading = false;
    notifyListeners();
  }

  deleteTransaction(TransactionItem transaction) async {
    await appDB.delete(appDB.transactionItems).delete(transaction);
    getTransactions();
    notifyListeners();
  }


  /*
  insertExample() async {
    await appDB.into(appDB.transactionItems).insert(
          TransactionItemsCompanion(
            amount: const Value(25),
            date: Value(DateTime.now()),
            note: const Value('alaza'),
            category: const Value('Elektro'),
            currency: const Value('CZK'),
          ),
        );
  }
  */
}
