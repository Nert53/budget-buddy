// model for displaying transactions in transaction_screen

import 'package:flutter/material.dart';

class Transaction {
  final String id;
  double amount;
  DateTime date;
  String note;
  bool isOutcome;
  String categoryId;
  String categoryName;
  IconData categoryIcon;
  Color categoryColor;
  String currencyId;
  String currencyName;
  String currencySymbol;

  Transaction({
    required this.id,
    required this.amount,
    required this.date,
    required this.note,
    required this.isOutcome,
    required this.categoryId,
    required this.categoryName,
    required this.categoryIcon,
    required this.categoryColor,
    required this.currencyId,
    required this.currencyName,
    required this.currencySymbol,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'amount': amount,
    'date': date.toIso8601String(),
    'note': note,
    'isOutcome': isOutcome,
    'categoryName': categoryName,
    'categoryIcon': categoryIcon.codePoint,
    'categoryColor': categoryColor.value,
    'currencyName': currencyName,
    'currencySymbol': currencySymbol,
  };
}
