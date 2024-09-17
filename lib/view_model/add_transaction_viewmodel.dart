import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:personal_finance/data/database.dart';
import 'package:personal_finance/data/transaction_database.dart';
import 'package:personal_finance/model/transaction.dart';
import 'package:shortuid/shortuid.dart';

class AddTransactionViewModel extends ChangeNotifier {
  final amountController = TextEditingController();
  final noteController = TextEditingController();
  final appDB = AppDatabase();

  void saveTransaction() async {
    Value<double> amoutValue = amountController.text.isNotEmpty
        ? Value(double.parse(amountController.text))
        : const Value(0.0);
    Value<String> noteValue = noteController.text.isNotEmpty
        ? Value(noteController.text)
        : const Value('');

    await appDB.into(appDB.transactionItems).insert(
          TransactionItemsCompanion(
            amount: amoutValue,
            date: Value(DateTime.now()),
            note: noteValue,
            category: const Value('Outcome'),
            currency: const Value('CZK'),
          ),
        );

    Transaction transaction = Transaction(
        id: ShortUid.create(),
        amount: amountController.text.isNotEmpty
            ? double.parse(amountController.text)
            : 0.0,
        date: DateTime.now(),
        note: noteController.text.isNotEmpty ? noteController.text : '',
        category: 'General',
        currency: 'CZK');

    try {
      await TransactionDatabase.instance.addValue(transaction);
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }
}
