import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:personal_finance/data/database.dart';
import 'package:personal_finance/model/filter_period.dart';
import 'package:personal_finance/model/transaction.dart';
import 'package:personal_finance/utils/functions.dart';

class TransactionViewModel extends ChangeNotifier {
  bool isLoading = true;
  final AppDatabase _db;

  List<Transaction> transactions = [];
  List<CategoryItem> categories = [];
  List<CurrencyItem> currencies = [];

  Map<String, bool> categoriesFilter = {};
  Map<String, bool> currenciesFilter = {};
  Map<String, bool> typesFilter = {};

  List<FilterPeriod> periodChoice = [
    FilterPeriod(
      name: 'All Time',
      selected: true,
      icon: Icons.all_inclusive.codePoint.toString(),
    ),
    FilterPeriod(
      name: 'Year',
      selected: false,
      icon: 'assets/icons/icon_365.svg',
    ),
    FilterPeriod(
        name: 'Month', selected: false, icon: 'assets/icons/icon_30.svg'),
    FilterPeriod(
        name: 'Week', selected: false, icon: 'assets/icons/icon_7.svg'),
    FilterPeriod(name: 'Day', selected: false, icon: 'assets/icons/icon_1.svg'),
    FilterPeriod(
        name: 'Custom',
        selected: false,
        icon: Icons.date_range.codePoint.toString()),
  ];

  DateTime currentDate = DateTime.now();
  String currentMonthString = convertMontNumToMonthName(DateTime.now().month);
  bool currentDisplayedOlder = false;
  bool currentDisplayedNewer = false;
  int categoryFilterCount = 0;
  int currencyFilterCount = 0;
  int typeFilterCount = 0;
  bool amountFilterActive = false;

  double amountMin = 0.0;
  double amountLow = 0.0;
  double amountMax = 0.0;
  double amountHigh = 0.0;

  TransactionViewModel(this._db) {
    _db.watchAllTransactions().listen((event) {
      getAllData();
    });

    _db.watchAllCategories().listen((event) {
      getAllData();
    });

    _db.watchAllCurrencies().listen((event) {
      getAllData();
    });

    getFilterSettings();
    setDateValues();
    notifyListeners();
  }

  void getAllData() async {
    isLoading = true;
    notifyListeners();

    setDateValues();
    getTransactions();
    getAllCategories();
    getAllCurrencies();
    isLoading = false;
  }

  void refresh() {
    setDateValues();
    getTransactions();
    notifyListeners();
  }

  void setDateValues() {
    var upToDateDate = DateTime.now();

    if (upToDateDate.year == currentDate.year &&
        upToDateDate.month == currentDate.month) {
      currentDisplayedOlder = false;
      currentDisplayedNewer = false;
      return;
    }

    if (upToDateDate.year > currentDate.year) {
      currentDisplayedNewer = false;
      currentDisplayedOlder = true;
      return;
    } else if (upToDateDate.year < currentDate.year) {
      currentDisplayedNewer = true;
      currentDisplayedOlder = false;
      return;
    }

    if (upToDateDate.year == currentDate.year) {
      if (upToDateDate.month > currentDate.month) {
        currentDisplayedNewer = false;
        currentDisplayedOlder = true;
        return;
      } else if (upToDateDate.month < currentDate.month) {
        currentDisplayedNewer = true;
        currentDisplayedOlder = false;
        return;
      }
    }
  }

  void upToDate() {
    currentDate = DateTime.now();
    currentMonthString = convertMontNumToMonthName(currentDate.month);
    refresh();
  }

  void previousMonth() {
    if (currentDate.month == 1) {
      currentDate = DateTime(currentDate.year - 1, 12);
    } else {
      currentDate = DateTime(currentDate.year, currentDate.month - 1);
    }
    currentMonthString = convertMontNumToMonthName(currentDate.month);
    refresh();
  }

  void nextMonth() {
    if (currentDate.month == 12) {
      currentDate = DateTime(currentDate.year + 1, 1);
    } else {
      currentDate = DateTime(currentDate.year, currentDate.month + 1);
    }
    currentMonthString = convertMontNumToMonthName(currentDate.month);
    refresh();
  }

  void getTransactions() async {
    List<TransactionItem> transactionItems =
        await (_db.select(_db.transactionItems)
              ..where((t) => t.date.month.equals(currentDate.month))
              ..where((t) => t.date.year.equals(currentDate.year))
              ..orderBy([
                (t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)
              ])) // Sort by date in descending order
            .get();
    List<TransactionItem> transactionItemsEdit = List.from(transactionItems);

    if ((categoryFilterCount + currencyFilterCount + typeFilterCount) == 0 &&
        !amountFilterActive) {
      // no filter used, display all transactions
    } else {
      for (var tItem in transactionItems) {
        // filter used, display only filtered ones
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
      CategoryItem category = await getCategoryById(t.category);
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

    transactions.sort((a, b) => b.date.compareTo(a.date));
    isLoading = false;

    notifyListeners();
  }

  Future<void> refreshTransactions() async {
    getAllData();

    return Future<void>.delayed(Duration(seconds: 2));
  }

  void updateTransaction(
      String transactionId,
      double amount,
      String note,
      bool isOutcome,
      DateTime date,
      String categoryId,
      String currencyId) async {
    var currencyExchangeRate = await (_db.select(_db.currencyItems)
          ..where((c) => c.id.equals(currencyId)))
        .getSingle()
        .then((value) => value.exchangeRate);

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

  void deleteTransaction(TransactionItem transaction) async {
    await _db.deleteTransactionItem(transaction);
    notifyListeners();
  }

  void deleteTransactionById(String id) async {
    await (_db.delete(_db.transactionItems)..where((t) => t.id.equals(id)))
        .go();

    notifyListeners();
  }

  void getAllCategories() async {
    categories.clear();
    categories = await _db.getAllCategoryItems();
  }

  Future<CategoryItem> getCategoryById(String id) async {
    return await (_db.select(_db.categoryItems)..where((c) => c.id.equals(id)))
        .getSingle();
  }

  void getAllCurrencies() async {
    currencies.clear();
    currencies = await _db.getAllCurrencyItems();
  }

  Future<CurrencyItem> getCurrencyById(String id) async {
    return await (_db.select(_db.currencyItems)..where((c) => c.id.equals(id)))
        .getSingle();
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

  void getAmountFilters() {
    amountMax = transactions.isNotEmpty
        ? transactions.map((t) => t.amount).reduce((a, b) => a > b ? a : b)
        : 0.0;
    amountHigh = amountMax;
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
    notifyListeners();
  }
}
