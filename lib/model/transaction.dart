import 'package:personal_finance/model/category.dart';

class Transaction {
  double amount;
  DateTime date;
  String note;
  Category category;
  String currency;
  
  Transaction({
    required this.amount,
    required this.date,
    required this.note,
    required this.category,
    required this.currency,
  });
}