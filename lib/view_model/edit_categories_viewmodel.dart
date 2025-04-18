// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:personal_finance/repository/database.dart';

class EditCategoriesViewmodel extends ChangeNotifier {
  final AppDatabase _db;
  bool isLoading = true;
  List<CategoryItem> categories = [];

  EditCategoriesViewmodel(this._db) {
    _db.watchCategories().listen((event) {
      getAllData();
    });

    isLoading = false;
    notifyListeners();
  }

  void getAllData() {
    isLoading = true;
    loadCategories();
    isLoading = false;
    notifyListeners();
  }

  void loadCategories() async {
    categories = await _db.getAllCategoryItems();
  }

  void addCategory(String name, Color color, IconData icon) async {
    _db.insertCategory(name, color.value, icon.codePoint);
    getAllData();
  }

  void deleteCategory(CategoryItem category) async {
    // also delete all transactions with this category
    await _db.deleteCategoryHard(category);
    getAllData();
  }

  Future<bool> updateCategory(CategoryItem newCategory) async {
    Future<bool> success = _db.updateCategory(newCategory);
    getAllData();
    return success;
  }
}
