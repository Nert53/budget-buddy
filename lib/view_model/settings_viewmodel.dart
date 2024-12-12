import 'package:flutter/material.dart';
import 'package:personal_finance/data/database.dart';

class SettingsViewmodel extends ChangeNotifier {
  bool isLoading = true;
  final AppDatabase _db;

  List<CurrencyItem> currencies = [];

  SettingsViewmodel(this._db) {
    _db.watchAllTransactions().listen((event) {
      getAllData();
    });
    isLoading = false;
    notifyListeners();
  }

  getAllData() {
    getCurrencies();
  }

  getCurrencies() async {
    currencies = await _db.select(_db.currencyItems).get();
  }
}
