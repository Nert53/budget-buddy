import 'package:flutter/material.dart';

class EditCategoriesViewmodel extends ChangeNotifier {
  bool isLoading = true;
  List<String> categories = [];

  EditCategoriesViewmodel() {
    loadCategories();
  }

  void loadCategories() {
    isLoading = true;
    notifyListeners();
    // Simulate a network request
    Future.delayed(Duration(seconds: 1), () {
      categories = ['Food', 'Transport', 'Entertainment', 'Utilities'];
      isLoading = false;
      notifyListeners();
    });
  }
}
