import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:personal_finance/data/database.dart';
import 'package:personal_finance/model/category.dart';
import 'package:personal_finance/model/currency.dart';
import 'package:personal_finance/utils/functions.dart';

enum TransactionType { income, outcome }

class EditTransactionViewmodel extends ChangeNotifier {
  bool isLoading = true;
  final AppDatabase _db;
  String transactionId = '';

  final amountController = TextEditingController();
  final noteController = TextEditingController();
  DateTime date = DateTime.now();
  TimeOfDay time = TimeOfDay.now();
  String originalCategoryId = '1';
  String originalCurrencyId = '1';

  List<TransactionCategory> categories = [];
  List<Currency> currencies = [];

  TransactionCategory? selectedCategory;
  Currency? selectedCurrency;
  TransactionType? selectedType;

  EditTransactionViewmodel(this._db) {
    _db.watchAllTransactions().listen((event) {
      getCategories();
    });
    getCurrencies();
    isLoading = false;
  }

  void saveTransaction() async {
    Value<double> amountToSave = amountController.text.isNotEmpty
        ? Value(double.parse(amountController.text))
        : const Value(0.0);
    Value<DateTime> dateToSave = Value(
        DateTime(date.year, date.month, date.day, time.hour, time.minute));
    Value<String> noteToSave = noteController.text.isNotEmpty
        ? Value(noteController.text)
        : const Value('');
    Value<bool> isOutcomeToSave = selectedType == TransactionType.outcome
        ? const Value(true)
        : const Value(false);
    Value<String> categoryIdToSave = selectedCategory == null
        ? Value(originalCategoryId)
        : Value(selectedCategory!.id);
    Value<String> currencyIdToSave = selectedCurrency == null
        ? Value(originalCurrencyId)
        : Value(selectedCurrency!.id);

    var result = await (_db.update(_db.transactionItems)
          ..where((t) => t.id.equals(transactionId)))
        .write(
      TransactionItemsCompanion(
        amount: amountToSave,
        date: dateToSave,
        note: noteToSave,
        isOutcome: isOutcomeToSave,
        category: categoryIdToSave,
        currency: currencyIdToSave,
      ),
    );

    print(result);
    notifyListeners();
  }

  void deleteTransactionById(String id) async {
    await (_db.delete(_db.transactionItems)..where((tbl) => tbl.id.equals(id)))
        .go();

    notifyListeners();
  }

  getCategories() async {
    categories.clear();
    List<CategoryItem> allCategories =
        await _db.select(_db.categoryItems).get().then((value) {
      return value.map((e) => e).toList();
    });

    for (var category in allCategories) {
      categories.add(TransactionCategory(
          id: category.id,
          name: category.name,
          color: Color(category.color),
          icon: convertIconNameToIcon(category.icon)));
    }

    notifyListeners();
  }

  changeCurrentCategory(String categoryId) {
    _db.select(_db.categoryItems).get().then((categories) {
      for (var c in categories) {
        if (c.id == categoryId) {
          selectedCategory = TransactionCategory(
              id: c.id,
              name: c.name,
              color: Color(c.color),
              icon: convertIconNameToIcon(c.icon));
          notifyListeners();
          return;
        }
      }
    });
  }

  getCurrencies() async {
    List<CurrencyItem> allCurrencies =
        await _db.select(_db.currencyItems).get().then((value) {
      return value.map((e) => e).toList();
    });

    for (var currency in allCurrencies) {
      currencies.add(Currency(
          id: currency.id, name: currency.name, symbol: currency.symbol));
    }
  }

  changeCurrentCurrency(String newCurrencyId) {
    _db.select(_db.currencyItems).get().then((currencies) {
      for (var c in currencies) {
        if (c.id == newCurrencyId) {
          selectedCurrency = Currency(id: c.id, name: c.name, symbol: c.symbol);
          notifyListeners();
          return;
        }
      }
    });
  }

  changeTransactionType(TransactionType type) {
    selectedType = type;
    notifyListeners();
  }
}
