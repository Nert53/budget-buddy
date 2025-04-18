import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_finance/repository/database.dart';
import 'package:personal_finance/model/category_simple.dart';
import 'package:personal_finance/model/currency.dart';
import 'package:personal_finance/utils/functions.dart';

enum TransactionType { income, outcome }

class AddTransactionViewModel extends ChangeNotifier {
  bool isLoading = true;
  final AppDatabase _db;

  DateFormat dateFormatter = DateFormat('dd.MM.yyyy');
  DateFormat timeFormatter = DateFormat('HH:mm');
  final amountController = TextEditingController();
  final noteController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();

  List<CategorySimple> categories = [];
  List<Currency> currencies = [];

  CategorySimple? selectedCategory;
  Currency? selectedCurrency;
  TransactionType selectedType = TransactionType.outcome;

  AddTransactionViewModel(this._db) {
    _db.watchCategories().listen((event) {
      getCategories();
    });
    _db.watchCurrencies().listen((event) {
      getCurrencies();
    });

    dateController.text = dateFormatter.format(DateTime.now()).toString();
    timeController.text = timeFormatter.format(DateTime.now()).toString();
    isLoading = false;
  }

  void saveTransaction() async {
    Value<double> amountToSave = amountController.text.isNotEmpty
        ? Value(double.parse(amountController.text))
        : const Value(0.0);
    Value<double> amountInCzkToSave =
        selectedCurrency!.symbol.toLowerCase() == 'czk'
            ? amountToSave
            : Value(amountToSave.value * selectedCurrency!.exchangeRate);
    Value<String> noteToSave = noteController.text.isNotEmpty
        ? Value(noteController.text)
        : const Value('');
    Value<bool> isOutcomeToSave = selectedType == TransactionType.outcome
        ? const Value(true)
        : const Value(false);
    Value<DateTime> date = dateController.text.isNotEmpty
        ? Value(dateFormatter.parse(dateController.text))
        : Value(DateTime.now());
    Value<DateTime> time = timeController.text.isNotEmpty
        ? Value(timeFormatter.parse(timeController.text))
        : Value(DateTime.now());
    Value<String> categoryToSaveId = Value(selectedCategory!.id);
    Value<String> currencyToSave = Value(selectedCurrency!.id);

    Value<DateTime> dateToSave = Value(DateTime(date.value.year,
        date.value.month, date.value.day, time.value.hour, time.value.minute));

    
    await _db.addTransaction(
          TransactionItemsCompanion(
            amount: amountToSave,
            amountInCZK: amountInCzkToSave,
            date: dateToSave,
            note: noteToSave,
            isOutcome: isOutcomeToSave,
            category: categoryToSaveId,
            currency: currencyToSave,
          ),
        );
    notifyListeners();
  }

  void getCategories() async {
    categories.clear();

    categories = await _db.getAllCategoryItems().then((value) {
      return value.map((e) => CategorySimple(
          id: e.id,
          name: e.name,
          color: Color(e.color),
          icon: convertIconCodePointToIcon(e.icon))).toList();
    });
    notifyListeners();
  }

  void changeCurrentCategory(String categoryId) {
    _db.select(_db.categoryItems).get().then((categories) {
      for (var c in categories) {
        if (c.id == categoryId) {
          selectedCategory = CategorySimple(
              id: c.id,
              name: c.name,
              color: Color(c.color),
              icon: convertIconCodePointToIcon(c.icon));
          notifyListeners();
          return;
        }
      }
    });
  }

  void getCurrencies() async {
    currencies.clear();
    currencies = await _db.getAllCurrencyItems().then((value) {
      return value.map((e) => Currency(
          id: e.id,
          name: e.name,
          symbol: e.symbol,
          exchangeRate: e.exchangeRate)).toList();
    });
  }

  void changeCurrentCurrency(String currency) {
    for (var c in currencies) {
      if (c.id == currency) {
        selectedCurrency = c;
        notifyListeners();
        return;
      }
    }
  }

  void changeTransactionType(TransactionType type) {
    selectedType = type;
    notifyListeners();
  }

  void clearFields() {
    amountController.clear();
    noteController.clear();
    dateController.text = DateFormat('dd.MM.yyyy').format(DateTime.now());
    timeController.text = DateFormat('HH:mm').format(DateTime.now());
    selectedCategory = null;
    selectedCurrency = null;
    selectedType = TransactionType.outcome;
    notifyListeners();
  }
}
