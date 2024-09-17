class TransactionFields {
  static const String tableName = 'transactions';

  static const String idType = 'TEXT PRIMARY KEY';
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
  final String id;
  double amount;
  DateTime date;
  String note;
  String category;
  String currency;

  Transaction({
    required this.id,
    required this.amount,
    required this.date,
    required this.note,
    required this.category,
    required this.currency,
  });

  String get dateDayFormatted => '${date.day}.${date.month}.${date.year}';

  Map<String, Object?> toJson() {
    return {
      TransactionFields.id: id,
      TransactionFields.amount: amount,
      TransactionFields.date: date.toIso8601String(),
      TransactionFields.note: note,
      TransactionFields.category: category,
      TransactionFields.currency: currency,
    };
  }

  static Transaction fromJson(Map<String, Object?> json) {
    return Transaction(
      id: json[TransactionFields.id] as String,
      amount: json[TransactionFields.amount] as double,
      date: DateTime.parse(json[TransactionFields.date] as String),
      note: json[TransactionFields.note] as String,
      category: json[TransactionFields.category] as String,
      currency: json[TransactionFields.currency] as String,
    );
  }

  Transaction copy({
    String? id,
    double? amount,
    DateTime? date,
    String? note,
    String? category,
    String? currency,
  }) {
    return Transaction(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      note: note ?? this.note,
      category: category ?? this.category,
      currency: currency ?? this.currency,
    );
  }
}
