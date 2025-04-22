import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:personal_finance/repository/database.dart';
import 'package:personal_finance/model/time_period.dart';
import 'package:personal_finance/model/transaction.dart';
import 'package:personal_finance/utils/functions.dart';
import 'package:personal_finance/view/constants/sort_order.dart';

class TransactionViewModel extends ChangeNotifier {
  bool isLoading = true;
  final AppDatabase _db;

  List<Transaction> transactions = [];
  List<CategoryItem> categories = [];
  List<CurrencyItem> currencies = [];

  // Posible time periods for displaying transactions
  List<TimePeriod> periodChoice = [
    TimePeriod(
      name: 'All Time',
      selected: false,
      icon: Icons.all_inclusive.codePoint.toString(),
    ),
    TimePeriod(
      name: 'Year',
      selected: false,
      icon: 'assets/icons/icon_365.svg',
    ),
    TimePeriod(name: 'Month', selected: true, icon: 'assets/icons/icon_30.svg'),
    TimePeriod(name: 'Week', selected: false, icon: 'assets/icons/icon_7.svg'),
    TimePeriod(name: 'Day', selected: false, icon: 'assets/icons/icon_1.svg'),
    TimePeriod(
        name: 'Range',
        selected: false,
        icon: Icons.date_range.codePoint.toString()),
  ];
  SortOrder sortOrder = SortOrder.newest;

  // Pair of name of filter and if it is active
  Map<String, bool> categoriesFilter = {};
  Map<String, bool> currenciesFilter = {};
  Map<String, bool> typesFilter = {};
  int categoryFilterCount = 0;
  int currencyFilterCount = 0;
  int typeFilterCount = 0;
  bool amountFilterActive = false;
  double amountMin = 0.0;
  double amountLow = 0.0;
  double amountMax = 0.0;
  double amountHigh = 0.0;
  bool filtersApplied = true;

  // DateTime for setting right time period
  DateTime currentDate = DateTime.now();
  String currentPeriod = 'Month';
  bool isRangePeriod = false;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  TransactionViewModel(this._db) {
    _db.watchTransactions().listen((event) {
      getAllData();
      getFilterSettings();
    });

    _db.watchCategories().listen((event) {
      getAllData();
      getFilterSettings();
    });

    _db.watchCurrencies().listen((event) {
      getAllData();
      getFilterSettings();
    });

    notifyListeners();
  }

  void getAllData() async {
    isLoading = true;
    getTransactions();
    getAllCategories();
    getAllCurrencies();
    notifyListeners();
    isLoading = false;
  }

  void refresh() {
    getTransactions();
    notifyListeners();
  }

  Future<void> refreshTransactions() async {
    getAllData();
  }

  int getFilterCount() {
    return categoryFilterCount +
        currencyFilterCount +
        typeFilterCount +
        (amountFilterActive ? 1 : 0);
  }

  void upToDate() {
    currentDate = DateTime.now();
    refresh();
  }

  void updateSelectedPeriod(String selectedPeriodName) {
    currentPeriod = selectedPeriodName;
    for (var period in periodChoice) {
      period.selected = period.name == selectedPeriodName;
    }

    refresh();
    notifyListeners();
  }

  void previousTimePeriod() {
    if (currentPeriod == 'Year') {
      currentDate = DateTime(currentDate.year - 1);
    } else if (currentPeriod == 'Month') {
      currentDate = DateTime(currentDate.year, currentDate.month - 1);
    } else if (currentPeriod == 'Week') {
      currentDate = currentDate.subtract(Duration(days: 7));
    } else if (currentPeriod == 'Day') {
      currentDate = currentDate.subtract(Duration(days: 1));
    }
    refresh();
  }

  void nextTimePeriod() {
    if (currentPeriod == 'Year') {
      currentDate = DateTime(currentDate.year + 1);
    } else if (currentPeriod == 'Month') {
      currentDate = DateTime(currentDate.year, currentDate.month + 1);
    } else if (currentPeriod == 'Week') {
      currentDate = currentDate.add(Duration(days: 7));
    } else if (currentPeriod == 'Day') {
      currentDate = currentDate.add(Duration(days: 1));
    }
    refresh();
  }

  void getTransactions() async {
    List<TransactionItem> transactionItems =
        await (_db.select(_db.transactionItems)
              ..where((t) {
                if (currentPeriod == 'Day') {
                  return t.date.day.equals(currentDate.day) &
                      t.date.month.equals(currentDate.month) &
                      t.date.year.equals(currentDate.year);
                } else if (currentPeriod == 'Month') {
                  return t.date.month.equals(currentDate.month) &
                      t.date.year.equals(currentDate.year);
                } else if (currentPeriod == 'Week') {
                  int weekday = currentDate.weekday;
                  return t.date.isSmallerOrEqualValue(
                          currentDate.add(Duration(days: 7 - weekday))) &
                      t.date.isBiggerOrEqualValue(
                          currentDate.subtract(Duration(days: weekday)));
                } else if (currentPeriod == 'Year') {
                  return t.date.year.equals(currentDate.year);
                } else if (currentPeriod == 'Range') {
                  return t.date.isBiggerOrEqualValue(startDate) &
                      t.date.isSmallerOrEqualValue(endDate);
                } else {
                  // for 'All Time' and 'Custom' periods
                  return Constant(true);
                }
              }))
            .get();
    List<TransactionItem> transactionItemsEdit = List.from(transactionItems);

    // filter used -> display only filtered ones
    if ((categoryFilterCount + currencyFilterCount + typeFilterCount) != 0 ||
        amountFilterActive) {
      for (var tItem in transactionItems) {
        bool matchesCategory =
            categoryFilterCount > 0 && categoriesFilter[tItem.category] == true;
        bool matchesCurrency =
            currencyFilterCount > 0 && currenciesFilter[tItem.currency] == true;
        bool matchesType = typeFilterCount > 0 &&
                (typesFilter['income'] == true && !tItem.isOutcome) ||
            (typesFilter['outcome'] == true && tItem.isOutcome);
        bool matchesAmount = amountFilterActive &&
            (tItem.amount >= amountLow && tItem.amount <= amountHigh);

        if ([matchesCategory, matchesCurrency, matchesType, matchesAmount]
            .every((element) => element == false)) {
          transactionItemsEdit.remove(tItem);
        }
      }
    }

    transactions.clear();
    for (var t in transactionItemsEdit) {
      CategoryItem category = await _db.getCategoryById(t.category);
      CurrencyItem selectedCurrency = await _db.getCurrencyById(t.currency);

      Transaction newTransaction = Transaction(
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
        currencyName: selectedCurrency.name,
        currencySymbol: selectedCurrency.symbol,
      );

      if (!transactions.any((element) => element.id == newTransaction.id)) {
        transactions.add(newTransaction);
      }
    }

    switch (sortOrder) {
      case SortOrder.oldest:
        transactions.sort((a, b) => a.date.compareTo(b.date));
        break;
      case SortOrder.newest:
        transactions.sort((a, b) => b.date.compareTo(a.date));
        break;
      case SortOrder.alphabetical:
        transactions.sort((a, b) => a.note.compareTo(b.note));
        break;
      case SortOrder.reverseAlphabetical:
        transactions.sort((a, b) => b.note.compareTo(a.note));
        break;
      case SortOrder.lowest:
        transactions.sort((a, b) => a.amount.compareTo(b.amount));
        break;
      case SortOrder.highest:
        transactions.sort((a, b) => b.amount.compareTo(a.amount));
        break;
    }

    isLoading = false;
    notifyListeners();
  }

  void updateTransaction(
      String transactionId,
      double amount,
      String note,
      bool isOutcome,
      DateTime date,
      String categoryId,
      String currencyId) async {
    double currencyExchangeRate = await _db.getCurrencyById(currencyId).then((value) => value.exchangeRate);  

    await (_db.update(_db.transactionItems)
          ..where((t) => t.id.equals(transactionId)))
        .write(
      TransactionItemsCompanion(
        amount: Value(amount),
        note: Value(note),
        isOutcome: Value(isOutcome),
        date: Value(date),
        category: Value(categoryId),
        currency: Value(currencyId),
        amountInCZK: Value(amount * currencyExchangeRate),
      ),
    );

    notifyListeners();
  }

  void deleteTransactionById(String id) async {
    await _db.deleteTransactionById(id);
    notifyListeners();
  }

  void getAllCategories() async {
    categories.clear();
    categories = await _db.getAllCategoryItems();
  }

  void getAllCurrencies() async {
    currencies.clear();
    currencies = await _db.getAllCurrencyItems();
  }

  void getFilterSettings() {
    getCategoriesFilters();
    getCurrenciesFilters();
    getTypesFilters();
    getAmountFilters();

    notifyListeners();
  }

  void resetFilters() {
    categoryFilterCount = 0;
    currencyFilterCount = 0;
    typeFilterCount = 0;
    amountFilterActive = false;
    filtersApplied = true;

    categoriesFilter.clear();
    currenciesFilter.clear();
    typesFilter = {
      'income': false,
      'outcome': false,
    };
    amountLow = 0.0;
    amountHigh = amountMax;

    getAllData();
    notifyListeners();
  }

  void getCategoriesFilters() {
    var oldFilter = Map.from(categoriesFilter);
    categoriesFilter.clear();
    for (var c in categories) {
      if (oldFilter.containsKey(c.id)) {
        categoriesFilter.addEntries(
            [MapEntry<String, bool>(c.id, oldFilter[c.id] ?? false)]);
      }
    }
  }

  void getCurrenciesFilters() {
    var oldFilter = Map.from(currenciesFilter);
    currenciesFilter.clear();
    for (var c in currencies) {
      if (oldFilter.containsKey(c.id)) {
        currenciesFilter.addEntries(
            [MapEntry<String, bool>(c.id, oldFilter[c.id] ?? false)]);
      }
    }
  }

  void getTypesFilters() {
    typesFilter = {
      'income': false,
      'outcome': false,
    };
  }

  void getAmountFilters() async {
    List<TransactionItem> transactionItems =
        await _db.select(_db.transactionItems).get();
    amountMax =
        transactionItems.map((t) => t.amount).reduce((a, b) => a > b ? a : b);
    amountHigh = amountMax;
    notifyListeners();
  }

  void updateFilterCount(bool value, int caseNumber) {
    switch (caseNumber) {
      case 1:
        value ? categoryFilterCount++ : categoryFilterCount--;
        break;
      case 2:
        value ? currencyFilterCount++ : currencyFilterCount--;
        break;
      case 3:
        value ? typeFilterCount++ : typeFilterCount--;
        break;
      case 4:
        amountFilterActive = value;
        break;
      default:
        break;
    }
    if (getFilterCount() == 0) {
      filtersApplied = true;
    } else {
      filtersApplied = false;
    }
    notifyListeners();
  }
}
