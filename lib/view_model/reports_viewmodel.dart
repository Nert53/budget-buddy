import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:personal_finance/repository/database.dart';
import 'package:personal_finance/model/category_spent_graph.dart';
import 'package:personal_finance/model/graph_type.dart';
import 'package:personal_finance/model/one_day_spent.dart';
import 'package:personal_finance/utils/functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportsViewModel extends ChangeNotifier {
  final AppDatabase _db;
  bool isLoading = true;

  DateTimeRange selectedDateRange = DateTimeRange(
      start: DateTime.now().subtract(Duration(days: 30)), end: DateTime.now());

  // List of avaliavable graphs
  List<GraphType> allGraphs = [
    GraphType(
        id: 1,
        name: 'top-categories-graph',
        namePretty: 'Top categories',
        icon: Icons.sort,
        selected: true),
    GraphType(
        id: 2,
        name: 'spent-time-graph',
        namePretty: 'Spent during time',
        icon: Icons.bar_chart,
        selected: true),
    GraphType(
        id: 3,
        name: 'numbers-graph',
        namePretty: 'Interesting numbers',
        icon: Icons.pin_outlined,
        selected: true),
    GraphType(
        id: 4,
        name: 'catgory-ratio-graph',
        namePretty: 'Category ratio',
        icon: Icons.pie_chart_outline,
        selected: false),
    GraphType(
        id: 5,
        name: 'income-outcome-numbers',
        namePretty: 'Income / Outcome numbers',
        icon: Icons.swap_vert_circle_rounded,
        selected: false),
  ];

  // Structures for graph data
  List<CategorySpentGraph> highestSpendingCategoriesData = [];
  int countHighestSpendingCategories = 5;
  List<MapEntry<DateTime, double>> spendingOverTimeData = [];
  List<CategorySpentGraph> incomeCategories = [];
  List<CategorySpentGraph> outcomeCategories = [];
  double averageDailySpent = 0;
  double transactionsForeignCurrenciesPercent = 0;
  double savedFromIncome = 0;
  double totalIncome = 0;
  double totalOutcome = 0;
  double accountBalance = 0;

  ReportsViewModel(this._db) {
    _db.watchTransactions().listen((event) {
      getAllData();
    });
    _db.watchCategories().listen((event) {
      getAllData();
    });
    _db.watchCurrencies().listen((event) {
      getAllData();
    });

    setDefaultVisibleGraphs();

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
    getIncomeAmount();
    getOutcomeAmount();
    getBalance();
    loadVisibleGraphs();
    isLoading = false;
  }

  // Set default visible graphs to be ready in shared preferences
  void setDefaultVisibleGraphs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (var graph in allGraphs) {
      prefs.setBool(graph.name, graph.selected);
    }
  }

  void loadVisibleGraphs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (var graph in allGraphs) {
      graph.selected = prefs.getBool(graph.name) ?? false;
    }
  }

  void reselectGraph(int graphId, String graphName, bool newValue) async {
    allGraphs.firstWhere((element) => element.id == graphId).selected =
        newValue;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(graphName, newValue);

    getAllData();
    notifyListeners();
  }

  void changeSelectedDateRange(DateTimeRange newDateRange) {
    selectedDateRange = newDateRange;
    getAllData();
    notifyListeners();
  }

  void getTopCategoriesGraphData() async {
    final query = _db.selectOnly(_db.transactionItems)
      ..addColumns([
        _db.categoryItems.name,
        _db.categoryItems.colorCode,
        _db.categoryItems.icon,
        _db.categoryItems.id,
        _db.transactionItems.isOutcome,
        _db.transactionItems.amountInCZK.sum()
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
        _db.categoryItems.colorCode,
        _db.categoryItems.icon,
        _db.categoryItems.id
      ]);
    query.limit(countHighestSpendingCategories);
    List result = await query.get();

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
    categorySpendings.sort((a, b) => b.amount.compareTo(a.amount));
    categorySpendings.take(countHighestSpendingCategories);

    highestSpendingCategoriesData.clear();
    for (var category in categorySpendings) {
      highestSpendingCategoriesData.add(CategorySpentGraph(
          color: category.color,
          amount: category.amount.roundToDouble(),
          name: category.name,
          icon: category.icon,
          id: category.id));
    }
    notifyListeners();
  }

  void getDailySpentInMotnhGraphData() async {
    final queryOutcomeTransactions = _db.select(_db.transactionItems)
      ..where((t) =>
          t.date.isBiggerOrEqualValue(selectedDateRange.start) &
          t.date.isSmallerOrEqualValue(selectedDateRange.end) &
          t.isOutcome.equals(true))
      ..get();

    List<TransactionItem> outcomeTransactions =
        await queryOutcomeTransactions.get();
    List<OneDaySpent> oneDaySpent = [];
    DateTime startDate = selectedDateRange.start;
    int index = 0;
    while (startDate.isBefore(selectedDateRange.end)) {
      oneDaySpent.add(OneDaySpent(
          amount: 0,
          date: startDate.copyWith(hour: 0, minute: 0, second: 0),
          index: index));
      startDate = startDate.add(Duration(days: 1));
      index++;
    }
    for (var t in outcomeTransactions) {
      if (isSameDate(t.date,
          oneDaySpent.firstWhere((date) => date.date.day == t.date.day).date)) {
        oneDaySpent.firstWhere((date) => date.date.day == t.date.day).amount +=
            t.amountInCZK;
      }
    }

    spendingOverTimeData.clear();
    spendingOverTimeData =
        oneDaySpent.map((e) => MapEntry(e.date, e.amount)).toList();

    notifyListeners();
  }

  void getAverageDailySpending() async {
    final allTransactions = _db.select(_db.transactionItems)
      ..where((t) =>
          t.date.isBiggerOrEqualValue(selectedDateRange.start) &
          t.date.isSmallerOrEqualValue(selectedDateRange.end) &
          t.isOutcome.equals(true));

    // Only days with at least 1 transaction are used to count the average
    allTransactions.get().then((value) {
      double totalAmount = 0;
      List daysWithTransactions = [];
      for (var transaction in value) {
        totalAmount += transaction.amountInCZK;
        if (!daysWithTransactions.contains(transaction.date.day)) {
          daysWithTransactions.add(transaction.date.day);
        }
      }
      averageDailySpent = totalAmount / daysWithTransactions.length;
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

        savedFromIncome = (totalIncome - totalOutcome) / totalIncome * 100;
        notifyListeners();
      });
    });
  }

  void getPercentageForeignCurrencyTransactions() async {
    String currencyCzkId = await _db.getAllCurrencyItems().then((currencies) =>
        currencies
            .firstWhere((currency) => currency.name == 'Czech Koruna')
            .id);

    final query = _db.select(_db.transactionItems)
      ..where((t) =>
          t.currency.equals(currencyCzkId).not() &
          t.date.isBiggerOrEqualValue(selectedDateRange.start) &
          t.date.isSmallerOrEqualValue(selectedDateRange.end));
    List<TransactionItem> foreignTransactions = await query.get();

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
    transactionsForeignCurrenciesPercent = percentage;
    notifyListeners();
  }

  void getIncomeCategories() {
    final query = _db.selectOnly(_db.transactionItems)
      ..addColumns([
        _db.categoryItems.name,
        _db.categoryItems.colorCode,
        _db.categoryItems.icon,
        _db.categoryItems.id,
        _db.transactionItems.isOutcome,
        _db.transactionItems.amountInCZK.sum()
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
        _db.categoryItems.colorCode,
        _db.categoryItems.icon,
        _db.categoryItems.id
      ]);

    query.get().then((result) {
      incomeCategories = result.map((row) {
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
      notifyListeners();
    });
  }

  void getOutcomeCategories() {
    final query = _db.selectOnly(_db.transactionItems)
      ..addColumns([
        _db.categoryItems.name,
        _db.categoryItems.colorCode,
        _db.categoryItems.icon,
        _db.categoryItems.id,
        _db.transactionItems.isOutcome,
        _db.transactionItems.amountInCZK.sum()
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
        _db.categoryItems.colorCode,
        _db.categoryItems.icon,
        _db.categoryItems.id
      ]);

    query.get().then((result) {
      outcomeCategories = result.map((row) {
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
      notifyListeners();
    });
  }

  void getIncomeAmount() async {
    final query = _db.selectOnly(_db.transactionItems)
      ..addColumns([_db.transactionItems.amountInCZK.sum()])
      ..where(_db.transactionItems.isOutcome.equals(false))
      ..where(_db.transactionItems.date
          .isBiggerOrEqualValue(selectedDateRange.start))
      ..where(_db.transactionItems.date
          .isSmallerOrEqualValue(selectedDateRange.end));

    var result = await query.getSingle();
    totalIncome =
        result.read<double>(_db.transactionItems.amountInCZK.sum()) ?? 0.0;
    notifyListeners();
  }

  void getOutcomeAmount() async {
    final query = _db.selectOnly(_db.transactionItems)
      ..addColumns([_db.transactionItems.amountInCZK.sum()])
      ..where(_db.transactionItems.isOutcome.equals(true))
      ..where(_db.transactionItems.date
          .isBiggerOrEqualValue(selectedDateRange.start))
      ..where(_db.transactionItems.date
          .isSmallerOrEqualValue(selectedDateRange.end));

    var result = await query.getSingle();
    totalOutcome =
        result.read<double>(_db.transactionItems.amountInCZK.sum()) ?? 0.0;
    notifyListeners();
  }

  void getBalance() async {
    final query = _db.select(_db.transactionItems)
      ..where((t) =>
          t.date.isBiggerOrEqualValue(selectedDateRange.start) &
          t.date.isSmallerOrEqualValue(selectedDateRange.end))
      ..get();
    List<TransactionItem> transactions = await query.get();

    accountBalance = transactions.fold<double>(0, (balance, transaction) {
      return balance +
          (transaction.isOutcome
              ? -transaction.amountInCZK
              : transaction.amountInCZK);
    });

    notifyListeners();
  }
}
