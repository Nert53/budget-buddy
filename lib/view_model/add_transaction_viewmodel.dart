import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:personal_finance/data/database.dart';

class AddTransactionViewModel extends ChangeNotifier {
  bool isLoading = true;
  final amountController = TextEditingController();
  final noteController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final appDB = AppDatabase();

  List<List<Object>> categories = [];
  List<String> currencies = ['CZK', 'USD', 'EUR'];

  String selectedCategory = 'General';
  String selectedCurrency = 'CZK';

  AddTransactionViewModel() {
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
    Value<DateTime> dateValue = dateController.text.isNotEmpty
        ? Value(DateTime.parse(dateController.text))
        : Value(DateTime.now());
    Value<String> category = Value(selectedCategory);
    Value<String> currency = Value(selectedCurrency);

    await appDB.into(appDB.transactionItems).insert(
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
        await appDB.select(appDB.categoryItems).get().then((value) {
      return value.map((e) => e).toList();
    });

    for (var category in allCategories) {
      categories.add([
        category.name,
        Color(category.color),
        convertIconNameToIcon(category.icon)
      ]);
    }

    notifyListeners();
  }

  convertIconNameToIcon(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'grocery':
        return Icons.local_grocery_store_outlined;
      case 'restaurant':
        return Icons.restaurant;
      case 'directions_car':
        return Icons.directions_car_outlined;
      case 'celebration':
        return Icons.celebration_outlined;
      case 'health':
        return Icons.health_and_safety_outlined;
      default:
        return Icons.attach_money;
    }
  }

  changeCurrentCategory(String category) {
    selectedCategory = category;
    notifyListeners();
  }

  changeCurrentCurrency(String currency) {
    selectedCurrency = currency;
    notifyListeners();
  }
}
