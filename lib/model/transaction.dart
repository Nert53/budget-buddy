import 'package:personal_finance/model/category.dart';

class TransactionFields {
  static const String tableName = 'transactions';
  static const String idType = 'STRING PRIMARY KEY';
  static const String amountType = 'REAL NOT NULL';
  static const String dateType = 'TEXT NOT NULL';
  static const String noteType = 'TEXT';
  static const String categoryType = 'TEXT NOT NULL';
  static const String currencyType = 'TEXT NOT NULL';
  static const String id = 'id';
  static const String amount = 'amount';
  static const String date = 'date';
  static const String note = 'note';
  static const String category = 'category';
  static const String currency = 'currency';
}

class Transaction {
  String id;
  double amount;
  DateTime date;
  String note;
  Category category;
  String currency;

  Transaction({
    required this.id,
    required this.amount,
    required this.date,
    required this.note,
    required this.category,
    required this.currency,
  });

  Map<String, Object?> toJson() {
    return {
      TransactionFields.id: id,
      TransactionFields.amount: amount,
      TransactionFields.date: date.toIso8601String(),
      TransactionFields.note: note,
      TransactionFields.category: category.name,
      TransactionFields.currency: currency,
    };
  }
}
