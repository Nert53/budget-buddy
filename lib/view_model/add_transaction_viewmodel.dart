import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_finance/data/database.dart';
import 'package:personal_finance/model/category.dart';
import 'package:personal_finance/utils/functions.dart';

enum TransactionType { income, outcome }

class AddTransactionViewModel extends ChangeNotifier {
  bool isLoading = true;
  final AppDatabase _db;

  final amountController = TextEditingController();
  final noteController = TextEditingController();
  final dateController = TextEditingController(
      text: DateFormat('dd.MM.yyyy').format(DateTime.now()).toString());
  final timeController = TextEditingController(
      text: DateFormat('HH:mm').format(DateTime.now()).toString());

  List<TransactionCategory> categories = [];
  List<String> currencies = ['CZK', 'USD', 'EUR'];

  TransactionCategory selectedCategory = TransactionCategory(
      name: 'Groceries',
      color: Colors.green,
      icon: Icons.shopping_cart_outlined);
  String selectedCurrency = 'CZK';
  TransactionType selectedType = TransactionType.outcome;

  AddTransactionViewModel(this._db) {
    _db.watchAllTransactions().listen((event) {
      getCategories();
    });
    getCategories();
    isLoading = false;
  }

  void saveTransaction() async {
    Value<double> amoutValue = amountController.text.isNotEmpty
        ? Value(double.parse(amountController.text))
        : const Value(0.0);
    Value<String> noteValue = noteController.text.isNotEmpty
        ? Value(noteController.text)
        : const Value('');
    /*Value<DateTime> dateValue = dateController.text.isNotEmpty
        ? Value(DateTime.parse(dateController.text))
        : Value(DateTime.now());*/
    //Value<String> category = Value("test");
    //Value<String> currency = Value(selectedCurrency);

    _db.into(_db.transactionItems).insert(
          TransactionItemsCompanion(
            amount: amoutValue,
            date: Value(DateTime.now()),
            note: noteValue,
            category: const Value('Outcome'),
            currency: const Value('CZK'),
          ),
        );
    notifyListeners();
  }

  getCategories() async {
    List<CategoryItem> allCategories =
        await _db.select(_db.categoryItems).get().then((value) {
      return value.map((e) => e).toList();
    });

    for (var category in allCategories) {
      categories.add(TransactionCategory(
          name: category.name,
          color: Color(category.color),
          icon: convertIconNameToIcon(category.icon)));
    }

    notifyListeners();
  }

  changeCurrentCategory(String category) {
    _db.select(_db.categoryItems).get().then((values) {
      for (var item in values) {
        if (item.name.toLowerCase() == category.toLowerCase()) {
          selectedCategory = TransactionCategory(
              name: item.name,
              color: Color(item.color),
              icon: convertIconNameToIcon(item.icon));
          notifyListeners();
          return;
        }
      }
    });
  }

  changeCurrentCurrency(String currency) {
    selectedCurrency = currency;
    notifyListeners();
  }

  changeTransactionType(TransactionType type) {
    selectedType = type;
    notifyListeners();
  }

  clearFields() {
    amountController.clear();
    noteController.clear();
    dateController.text = DateFormat('dd.MM.yyyy').format(DateTime.now());
    timeController.text = DateFormat('HH:mm').format(DateTime.now());
    notifyListeners();
  }
}
