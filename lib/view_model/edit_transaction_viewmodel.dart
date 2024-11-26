import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_finance/data/database.dart';
import 'package:personal_finance/model/category.dart';
import 'package:personal_finance/model/currency.dart';
import 'package:personal_finance/utils/functions.dart';

enum TransactionType { income, outcome }

class EditTransactionViewmodel extends ChangeNotifier {
  bool isLoading = true;
  final AppDatabase _db;

  final amountController = TextEditingController();
  final noteController = TextEditingController();
  final date = DateTime.now();
  final dateFormated =
      DateFormat('dd. MM. yyyy').format(DateTime.now()).toString();
  final timeFormated = DateFormat('HH:mm').format(DateTime.now()).toString();

  List<TransactionCategory> categories = [];
  List<Currency> currencies = [];

  TransactionCategory selectedCategory = TransactionCategory(
      id: '1',
      name: 'Groceries',
      color: Colors.green,
      icon: Icons.shopping_cart_outlined);
  String selectedCurrency = 'CZK';
  TransactionType selectedType = TransactionType.outcome;

  EditTransactionViewmodel(this._db) {
    _db.watchAllTransactions().listen((event) {
      getCategories();
    });
    getCurrencies();
    isLoading = false;
  }

  void saveTransaction() async {
    DateFormat dateFormat = DateFormat('dd.MM.yyyy');
    DateFormat timeFormat = DateFormat('HH:mm');

    Value<double> amountToSave = amountController.text.isNotEmpty
        ? Value(double.parse(amountController.text))
        : const Value(0.0);
    Value<String> noteToSave = noteController.text.isNotEmpty
        ? Value(noteController.text)
        : const Value('');
    Value<bool> isOutcomeToSave = selectedType == TransactionType.outcome
        ? const Value(true)
        : const Value(false);

    Value<String> categoryToSaveId = Value(selectedCategory.id);
    Value<String> currencyToSave = Value(selectedCurrency);

    await _db.into(_db.transactionItems).insert(
          TransactionItemsCompanion(
            amount: amountToSave,
            date: Value(DateTime.now()),
            note: noteToSave,
            isOutcome: isOutcomeToSave,
            category: categoryToSaveId,
            currency: currencyToSave,
          ),
        );
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

  changeCurrentCurrency(String currency) {
    selectedCurrency = currency;
    notifyListeners();
  }

  changeTransactionType(TransactionType type) {
    selectedType = type;
    notifyListeners();
  }
}
