import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:personal_finance/repository/database.dart';
import 'package:personal_finance/model/category_spent_graph.dart';
import 'package:personal_finance/model/transaction.dart';
import 'package:personal_finance/utils/functions.dart';

class DashboardViewmodel extends ChangeNotifier {
  bool isLoading = true;
  final AppDatabase _db;

  double accountBalance = 0.0;
  double thisMonthSpent = 0.0;
  double todaySpent = 0.0;
  double predictedSpent = 0.0;
  List<Transaction> lastTransactions = [];
  List<CategorySpentGraph> categoryGraphData = [];

  DateTime currrentDate = DateTime.now();
  int currentMonth = DateTime.now().month;
  int currentYear = DateTime.now().year;
  int numOfLastTransactions = 5;

  DashboardViewmodel(this._db) {
    _db.watchTransactions().listen((event) {
      getAllData();
    });
    _db.watchCategories().listen((event) {
      getAllData();
    });
    _db.watchCurrencies().listen((event) {
      getAllData();
    });

    notifyListeners();
  }

  void getAllData() {
    isLoading = true;
    getAccountBalance();
    getLastNTransactions(numOfLastTransactions);
    getThisMonthSpent();
    getTodaySpent();
    getPredictedSpentThisMonth();
    getCategorySpentData();
    isLoading = false;
  }

  void getAccountBalance() async {
    final transactionItems = await _db.getAllTransactionItems();
    accountBalance = transactionItems.fold<double>(
      0,
      (previousValue, element) => element.isOutcome
          ? previousValue - element.amountInCZK
          : previousValue + element.amountInCZK,
    );
    notifyListeners();
  }

  void getLastNTransactions(int n) async {
    var transactions = await (_db.select(_db.transactionItems)
          ..orderBy([
            (t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)
          ])
          ..limit(n)) // Sort by date in descending order
        .get();

    lastTransactions.clear();
    for (var t in transactions) {
      var category = await (_db.select(_db.categoryItems)
            ..where((c) => c.id.equals(t.category)))
          .getSingle();

      var selectedCurrency = _db.select(_db.currencyItems)
        ..where((c) => c.id.equals(t.currency));
      var currencyName =
          await selectedCurrency.getSingle().then((cur) => cur.name);
      var currencySymbol =
          await selectedCurrency.getSingle().then((cur) => cur.symbol);

      if (!lastTransactions.any((item) => item.id == t.id.toString())) {
        lastTransactions.add(Transaction(
          id: t.id.toString(),
          amount: t.amount,
          date: t.date,
          note: t.note,
          isOutcome: t.isOutcome,
          categoryId: t.category,
          categoryName: category.name,
          categoryIcon: convertIconCodePointToIcon(category.icon),
          categoryColor: Color(category.color),
          currencyId: t.currency,
          currencyName: currencyName,
          currencySymbol: currencySymbol,
        )); // Skip if the transaction already exists
      }
    }

    notifyListeners();
  }

  void getThisMonthSpent() {
    final query = _db.select(_db.transactionItems)
      ..where((transaction) =>
          transaction.date.month.equals(currentMonth) &
          transaction.date.year.equals(currentYear) &
          transaction.isOutcome.equals(true));

    query.get().then((value) {
      thisMonthSpent = value.fold(
        0,
        (previousValue, element) => previousValue + element.amountInCZK,
      );
    });
    notifyListeners();
  }

  void getTodaySpent() {
    final query = _db.select(_db.transactionItems)
      ..where((transaction) =>
          transaction.date.day.equals(currrentDate.day) &
          transaction.date.month.equals(currrentDate.month) &
          transaction.date.year.equals(currrentDate.year) &
          transaction.isOutcome.equals(true));

    query.get().then((value) {
      todaySpent = value.fold(
        0,
        (previousValue, element) => previousValue + element.amountInCZK,
      );
    });
    notifyListeners();
  }

  void getPredictedSpentThisMonth() async {
    final q = _db.select(_db.transactionItems)
      ..where((transaction) =>
          transaction.date.month.equals(currentMonth) &
          transaction.date.year.equals(currentYear) &
          transaction.isOutcome.equals(true));

    double tillNowSpent = 0;
    await q.get().then((value) {
      tillNowSpent = value.fold(
        0,
        (previousValue, element) => previousValue + element.amountInCZK,
      );
    });

    predictedSpent = tillNowSpent / currrentDate.day * 30;
    notifyListeners();
  }

  void getCategorySpentData() async {
    final query = _db.selectOnly(_db.transactionItems)
      ..addColumns([
        _db.categoryItems.name, // Category name
        _db.categoryItems.colorCode, // Category color
        _db.categoryItems.icon, // Category icon
        _db.categoryItems.id, // Category ID
        _db.transactionItems.isOutcome,
        _db.transactionItems.amountInCZK
            .sum() // Total amount spent for the category
      ])
      ..join([
        innerJoin(_db.categoryItems,
            _db.categoryItems.id.equalsExp(_db.transactionItems.category))
      ])
      ..where(_db.transactionItems.isOutcome.equals(true))
      ..where(_db.transactionItems.date.month.equals(currentMonth))
      ..groupBy([
        _db.transactionItems.category,
        _db.categoryItems.name,
        _db.categoryItems.colorCode,
        _db.categoryItems.icon,
        _db.categoryItems.id
      ]);
    var result = await query.get();

    final List<CategorySpentGraph> categorySpendings = result.map((row) {
      return CategorySpentGraph(
        id: row.read<String>(_db.categoryItems.id) ?? '',
        name: row.read<String>(_db.categoryItems.name) ?? '',
        color: convertColorCodeToColor(
            row.read<int>(_db.categoryItems.colorCode) ?? 0),
        icon: convertIconCodePointToIcon(
            row.read<int>(_db.categoryItems.icon) ?? 0),
        amount: row.read<double>(_db.transactionItems.amountInCZK.sum()) ?? 0,
      );
    }).toList();

    categoryGraphData.clear();
    for (var category in categorySpendings) {
      categoryGraphData.add(CategorySpentGraph(
          color: category.color,
          amount: category.amount,
          name: category.name,
          icon: category.icon,
          id: category.id));
    }
  }
}
