import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:personal_finance/data/database.dart';
import 'package:personal_finance/model/transaction.dart';
import 'package:personal_finance/utils/functions.dart';

class TransactionViewModel extends ChangeNotifier {
  bool isLoading = true;
  final AppDatabase _db;

  List<Transaction> transactions = [];
  List<CategoryItem> categories = [];
  List<CurrencyItem> currencies = [];

  DateTime currentDate = DateTime.now();
  String currentMonthString = convertMontNumToMonthName(DateTime.now().month);
  bool currentDisplayedOlder = false;
  bool currentDisplayedNewer = false;

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

    setDateValues();
    notifyListeners();
  }

  getAllData() async {
    isLoading = true;
    notifyListeners();

    setDateValues();
    getTransactions();
    getAllCategories();
    getAllCurrencies();
    isLoading = false;
  }

  refresh() {
    setDateValues();
    getTransactions();
    notifyListeners();
  }

  setDateValues() {
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

  upToDate() {
    currentDate = DateTime.now();
    currentMonthString = convertMontNumToMonthName(currentDate.month);
    refresh();
  }

  previousMonth() {
    if (currentDate.month == 1) {
      currentDate = DateTime(currentDate.year - 1, 12);
    } else {
      currentDate = DateTime(currentDate.year, currentDate.month - 1);
    }
    currentMonthString = convertMontNumToMonthName(currentDate.month);
    refresh();
  }

  nextMonth() {
    if (currentDate.month == 12) {
      currentDate = DateTime(currentDate.year + 1, 1);
    } else {
      currentDate = DateTime(currentDate.year, currentDate.month + 1);
    }
    currentMonthString = convertMontNumToMonthName(currentDate.month);
    refresh();
  }

  getTransactions() async {
    var transactionItems = await (_db.select(_db.transactionItems)
          ..where((t) => t.date.month.equals(currentDate.month))
          ..where((t) => t.date.year.equals(currentDate.year))
          ..orderBy([
            (t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)
          ])) // Sort by date in descending order
        .get();

    transactions.clear();
    for (var t in transactionItems) {
      var category = await (_db.select(_db.categoryItems)
            ..where((c) => c.id.equals(t.category)))
          .getSingle();

      var selectedCurrency = _db.select(_db.currencyItems)
        ..where((c) => c.id.equals(t.currency));
      var currencySymbol =
          await selectedCurrency.getSingle().then((value) => value.symbol);
      var currencyName =
          await selectedCurrency.getSingle().then((value) => value.name);

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
        currencyName: currencyName,
        currencySymbol: currencySymbol,
      );

      if (!transactions.any((element) => element.id == newTransaction.id)) {
        transactions.add(newTransaction);
      }
    }

    transactions.sort((a, b) => b.date.compareTo(a.date));
    isLoading = false;

    notifyListeners();
  }

  refreshTransactions() async {
    await getAllData();

    return Future<void>.delayed(Duration(seconds: 2));
  }

  updateTransaction(
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

  deleteTransaction(TransactionItem transaction) async {
    await _db.delete(_db.transactionItems).delete(transaction);
    notifyListeners();
  }

  deleteTransactionById(String id) async {
    await (_db.delete(_db.transactionItems)..where((t) => t.id.equals(id)))
        .go();

    notifyListeners();
  }

  getAllCategories() async {
    categories.clear();
    categories = await _db.select(_db.categoryItems).get();
  }

  getCategoryById(String id) async {
    return await (_db.select(_db.categoryItems)..where((c) => c.id.equals(id)))
        .getSingle();
  }

  getAllCurrencies() async {
    currencies.clear();
    currencies = await _db.select(_db.currencyItems).get();
  }

  getCurrencyById(String id) async {
    return await (_db.select(_db.currencyItems)..where((c) => c.id.equals(id)))
        .getSingle();
  }
}
