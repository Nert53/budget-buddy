import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:personal_finance/data/database.dart';
import 'package:personal_finance/model/category_spent_graph.dart';
import 'package:personal_finance/model/graph.dart';
import 'package:personal_finance/utils/functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GraphViewModel extends ChangeNotifier {
  final AppDatabase _db;
  bool isLoading = true;
  DateTimeRange selectedDateRange = DateTimeRange(
      start: DateTime.now().subtract(Duration(days: 30)), end: DateTime.now());
  List<Graph> allGraphs = [
    Graph(
        id: 1,
        name: 'top-categories-graph',
        namePretty: 'Top Categories',
        icon: Icons.sort,
        selected: true),
    Graph(
        id: 2,
        name: 'spent-month-graph',
        namePretty: 'Spent during month',
        icon: Icons.bar_chart,
        selected: true),
    Graph(
        id: 3,
        name: 'numbers-graph',
        namePretty: 'Interesting numbers',
        icon: Icons.pin_outlined,
        selected: true),
    Graph(
        id: 4,
        name: 'catgory-ratio-graph',
        namePretty: 'Category ratio',
        icon: Icons.pie_chart_outline,
        selected: true),
  ];
  List<CategorySpentGraph> topCategoriesGraphData = [];
  List<MapEntry<int, double>> dailySpentInMonthGraphData = [];
  List<CategorySpentGraph> incomeCategories = [];
  List<CategorySpentGraph> outcomeCategories = [];
  double averageDailySpending = 0;
  double percentageForeignCurrencyTransactions = 0;
  double savingFromIncome = 0;

  GraphViewModel(this._db) {
    _db.watchAllTransactions().listen((event) {
      getAllData();
    });
    _db.watchAllCategories().listen((event) {
      getAllData();
    });
    _db.watchAllCurrencies().listen((event) {
      getAllData();
    });

    notifyListeners();
  }

  void getAllData() {
    getTopCategoriesGraphData();
    getDailySpentInMotnhGraphData();
    getSavingFromIncome();
    getPercentageForeignCurrencyTransactions();
    getAverageDailySpending();
    getIncomeCategories();
    getOutcomeCategories();
    isLoading = false;
  }

  void reselectGraph(int graphId, String graphName, bool newValue) async {
    allGraphs.firstWhere((element) => element.id == graphId).selected =
        newValue;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(graphName, newValue);

    getAllData();
    notifyListeners();
  }

  void loadVisibleGraphs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (var graph in allGraphs) {
      graph.selected = prefs.getBool(graph.name) ?? false;
    }
  }

  void changeSelectedDateRange(DateTimeRange newDateRange) {
    selectedDateRange = newDateRange;
    getAllData();
    notifyListeners();
  }

  void getTopCategoriesGraphData() async {
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
      ..where(_db.transactionItems.date
          .isBiggerOrEqualValue(selectedDateRange.start))
      ..where(_db.transactionItems.date
          .isSmallerOrEqualValue(selectedDateRange.end))
      ..groupBy([
        _db.transactionItems.category,
        _db.categoryItems.name,
        _db.categoryItems.color,
        _db.categoryItems.icon,
        _db.categoryItems.id
      ]);
    var result = await query.get();

    final List<CategorySpentGraph> categorySpendings = result.map((row) {
      return CategorySpentGraph(
        id: row.read<String>(_db.categoryItems.id) ?? '',
        name: row.read<String>(_db.categoryItems.name) ?? '',
        color: convertColorCodeToColor(
            row.read<int>(_db.categoryItems.color) ?? 0),
        icon: convertIconCodePointToIcon(
            row.read<int>(_db.categoryItems.icon) ?? 0),
        amount: row.read<double>(_db.transactionItems.amountInCZK.sum()) ?? 0,
      );
    }).toList();
    categorySpendings.sort((a, b) => b.amount.compareTo(a.amount));
    categorySpendings.take(5);

    topCategoriesGraphData.clear();
    for (var category in categorySpendings) {
      topCategoriesGraphData.add(CategorySpentGraph(
          color: category.color,
          amount: category.amount.roundToDouble(),
          name: category.name,
          icon: category.icon,
          id: category.id));
    }
    notifyListeners();
  }

  void getDailySpentInMotnhGraphData() async {
    final query = _db.selectOnly(_db.transactionItems)
      ..addColumns(
          [_db.transactionItems.date, _db.transactionItems.amountInCZK.sum()])
      ..where(_db.transactionItems.isOutcome.equals(true))
      ..where(_db.transactionItems.date
          .isBiggerOrEqualValue(selectedDateRange.start))
      ..where(_db.transactionItems.date
          .isSmallerOrEqualValue(selectedDateRange.end))
      ..groupBy([_db.transactionItems.date]);
    var result = await query.get();

    dailySpentInMonthGraphData.clear();
    for (var row in result) {
      dailySpentInMonthGraphData.add(MapEntry(
          row.read<DateTime>(_db.transactionItems.date)!.day,
          row.read<double>(_db.transactionItems.amountInCZK.sum()) ?? 0.0));
    }

    notifyListeners();
  }

  void getAverageDailySpending() async {
    final allTransactions = _db.select(_db.transactionItems)
      ..where((t) =>
          t.date.isBiggerOrEqualValue(selectedDateRange.start) &
          t.date.isSmallerOrEqualValue(selectedDateRange.end) &
          t.isOutcome.equals(true));

    // only days with transactions are used to count the average
    allTransactions.get().then((value) {
      double totalAmount = 0;
      List daysWithTransactions = [];
      for (var transaction in value) {
        totalAmount += transaction.amountInCZK;
        if (!daysWithTransactions.contains(transaction.date.day)) {
          daysWithTransactions.add(transaction.date.day);
        }
      }
      averageDailySpending = totalAmount / daysWithTransactions.length;
      notifyListeners();
    });
  }

  void getSavingFromIncome() async {
    final incomeTransactions = _db.select(_db.transactionItems)
      ..where((t) =>
          t.date.isBiggerOrEqualValue(selectedDateRange.start) &
          t.date.isSmallerOrEqualValue(selectedDateRange.end) &
          t.isOutcome.equals(false));

    final outcomeTransactions = _db.select(_db.transactionItems)
      ..where((t) =>
          t.date.isBiggerOrEqualValue(selectedDateRange.start) &
          t.date.isSmallerOrEqualValue(selectedDateRange.end) &
          t.isOutcome.equals(true));

    incomeTransactions.get().then((incomeTransactions) {
      double totalIncome = 0;
      for (var transaction in incomeTransactions) {
        totalIncome += transaction.amountInCZK;
      }

      outcomeTransactions.get().then((outcomeTransactions) {
        double totalOutcome = 0;
        for (var transaction in outcomeTransactions) {
          totalOutcome += transaction.amountInCZK;
        }

        savingFromIncome = (totalIncome - totalOutcome) / totalIncome * 100;
        notifyListeners();
      });
    });
  }

  void getPercentageForeignCurrencyTransactions() async {
    String currencyCzkId = await (_db.select(_db.currencyItems)
          ..where((currency) => currency.name.equals('Czech Koruna')))
        .getSingle()
        .then((currency) => currency.id);

    final query = _db.select(_db.transactionItems)
      ..where((t) =>
          t.currency.equals(currencyCzkId).not() &
          t.date.isBiggerOrEqualValue(selectedDateRange.start) &
          t.date.isSmallerOrEqualValue(selectedDateRange.end));
    var foreignTransactions = await query.get();

    final totalTransactionsQuery = _db.selectOnly(_db.transactionItems)
      ..addColumns([_db.transactionItems.id])
      ..where(_db.transactionItems.date
          .isBiggerOrEqualValue(selectedDateRange.start))
      ..where(_db.transactionItems.date
          .isSmallerOrEqualValue(selectedDateRange.end));
    var allTransactions = await totalTransactionsQuery.get();

    double percentage = 0;
    if (allTransactions.isNotEmpty) {
      percentage = (foreignTransactions.length / allTransactions.length) * 100;
    }
    percentageForeignCurrencyTransactions = percentage;
    notifyListeners();
  }

  void getIncomeCategories() {
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
      ..where(_db.transactionItems.isOutcome.equals(false))
      ..where(_db.transactionItems.date
          .isBiggerOrEqualValue(selectedDateRange.start))
      ..where(_db.transactionItems.date
          .isSmallerOrEqualValue(selectedDateRange.end))
      ..groupBy([
        _db.transactionItems.category,
        _db.categoryItems.name,
        _db.categoryItems.color,
        _db.categoryItems.icon,
        _db.categoryItems.id
      ]);

    query.get().then((result) {
      incomeCategories = result.map((row) {
        return CategorySpentGraph(
          id: row.read<String>(_db.categoryItems.id) ?? '',
          name: row.read<String>(_db.categoryItems.name) ?? '',
          color: convertColorCodeToColor(
              row.read<int>(_db.categoryItems.color) ?? 0),
          icon: convertIconCodePointToIcon(
              row.read<int>(_db.categoryItems.icon) ?? 0),
          amount: row.read<double>(_db.transactionItems.amountInCZK.sum()) ?? 0,
        );
      }).toList();
      notifyListeners();
    });
  }

  void getOutcomeCategories() {
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
      ..where(_db.transactionItems.date
          .isBiggerOrEqualValue(selectedDateRange.start))
      ..where(_db.transactionItems.date
          .isSmallerOrEqualValue(selectedDateRange.end))
      ..groupBy([
        _db.transactionItems.category,
        _db.categoryItems.name,
        _db.categoryItems.color,
        _db.categoryItems.icon,
        _db.categoryItems.id
      ]);

    query.get().then((result) {
      outcomeCategories = result.map((row) {
        return CategorySpentGraph(
          id: row.read<String>(_db.categoryItems.id) ?? '',
          name: row.read<String>(_db.categoryItems.name) ?? '',
          color: convertColorCodeToColor(
              row.read<int>(_db.categoryItems.color) ?? 0),
          icon: convertIconCodePointToIcon(
              row.read<int>(_db.categoryItems.icon) ?? 0),
          amount: row.read<double>(_db.transactionItems.amountInCZK.sum()) ?? 0,
        );
      }).toList();
      notifyListeners();
    });
  }
}
