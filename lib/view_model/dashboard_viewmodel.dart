import 'package:drift/drift.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:personal_finance/data/database.dart';
import 'package:personal_finance/model/category_spending.dart';
import 'package:personal_finance/model/transaction.dart';
import 'package:personal_finance/utils/functions.dart';

class DashboardViewmodel extends ChangeNotifier {
  bool isLoading = true;
  final AppDatabase _db;

  double accountBalance = 0.0;
  double thisMonthSpent = 0.0;
  double todaySpent = 0.0;
  double predictedSpentThisMonth = 0.0;
  List<Transaction> lastTransactions = [];
  List<PieChartSectionData> categoryPieData = [];

  DateTime currrentDate = DateTime.now();
  int currentMonth = DateTime.now().month;
  int currentYear = DateTime.now().year;
  int numOfLastTransactions = 5;

  DashboardViewmodel(this._db) {
    _db.watchAllTransactions().listen((event) {
      getAllData();
    });
    notifyListeners();
  }

  getAllData() {
    getAccountBalance();
    getLastNTransactions(numOfLastTransactions);
    getThisMonthSpent();
    getTodaySpent();
    getPredictedSpentThisMonth();
    getCategoryPieData();
    isLoading = false;
  }

  getAccountBalance() async {
    List<TransactionItem> allTransactions =
        await _db.select(_db.transactionItems).get();
    accountBalance = allTransactions.fold(
      0,
      (previousValue, element) => element.isOutcome
          ? previousValue - element.amountInCZK
          : previousValue + element.amountInCZK,
    );
    notifyListeners();
  }

  getLastNTransactions(int n) async {
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
          await selectedCurrency.getSingle().then((value) => value.symbol);

      lastTransactions.add(Transaction(
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

    notifyListeners();
  }

  getThisMonthSpent() {
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

  getTodaySpent() {
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

  getPredictedSpentThisMonth() async {
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

    predictedSpentThisMonth = tillNowSpent / currrentDate.day * 30;
    notifyListeners();
  }

  getCategoryPieData() async {
    final query = _db.selectOnly(_db.transactionItems)
      ..addColumns([
        _db.categoryItems.name, // Category name
        _db.categoryItems.color, // Category color
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
        _db.categoryItems.color,
        _db.categoryItems.icon,
        _db.categoryItems.id
      ]);
    var result = await query.get();

    final List<CategorySpending> categorySpendings = result.map((row) {
      return CategorySpending(
        id: row.read<String>(_db.categoryItems.id) ?? '',
        name: row.read<String>(_db.categoryItems.name) ?? '',
        color: convertColorCodeToColor(
            row.read<int>(_db.categoryItems.color) ?? 0),
        icon: convertIconNameToIcon(
            row.read<String>(_db.categoryItems.icon) ?? ''),
        amount: row.read<double>(_db.transactionItems.amountInCZK.sum()) ?? 0,
      );
    }).toList();

    categoryPieData.clear();
    for (var category in categorySpendings) {
      categoryPieData.add(PieChartSectionData(
        color: category.color,
        value: category.amount,
        title: category.name,
        titleStyle: TextStyle(
          color: Colors.white,
        ),
        radius: 50,
      ));
    }
  }
}
