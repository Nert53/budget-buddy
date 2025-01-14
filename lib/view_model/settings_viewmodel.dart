import 'package:flutter/material.dart';
import 'package:personal_finance/data/database.dart';

class SettingsViewmodel extends ChangeNotifier {
  bool isLoading = true;
  final AppDatabase _db;

  List<CurrencyItem> currencies = [];

  SettingsViewmodel(this._db) {
    isLoading = true;
    _db.watchAllCurrencies().listen((event) {
      getAllData();
    });
    _db.watchAllCategories().listen((event) {
      getAllData();
    });

    getAllData();
    notifyListeners();
  }

  getAllData() {
    isLoading = true;
    getCurrencies();
    isLoading = false;
  }

  getCurrencies() async {
    currencies = await _db.select(_db.currencyItems).get();
    
    notifyListeners();
  }
}
