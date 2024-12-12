import 'package:flutter/material.dart';
import 'package:personal_finance/data/database.dart';

class EditCategoriesViewmodel extends ChangeNotifier {
  final AppDatabase _db;
  bool isLoading = true;
  List<CategoryItem> categories = [];

  EditCategoriesViewmodel(this._db) {
    _db.watchAllTransactions().listen((event) {
      getAllData();
    });
    isLoading = false;
    notifyListeners();
  }

  getAllData() {
    isLoading = true;
    loadCategories();
    isLoading = false;
    notifyListeners();
  }

  void loadCategories() async {
    categories = await _db.select(_db.categoryItems).get();
  }

  void deleteCategory(CategoryItem category) async {
    // will also delete all transactions with this category
    await _db.deleteCategoryHard(category);
    getAllData();
  }
}
