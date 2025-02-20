import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:personal_finance/data/database.dart';
import 'package:personal_finance/model/exchange_rate.dart';

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

  void getAllData() {
    isLoading = true;
    getCurrencies();
    isLoading = false;
  }

  void getCurrencies() async {
    currencies = await _db.select(_db.currencyItems).get();

    notifyListeners();
  }

  void updateExchangeRate(CurrencyItem currencyItem, double newExchangeRate) async {
    await (_db.update(_db.currencyItems)
          ..where((tbl) => tbl.id.equals(currencyItem.id)))
        .write(CurrencyItemsCompanion(
      exchangeRate: Value(newExchangeRate),
    ));

    notifyListeners();
  }

  void getExchangeRateFromInternet() async {
    http.Response response = await http.get(Uri.parse(
        'https://www.cnb.cz/cs/financni-trhy/devizovy-trh/kurzy-devizoveho-trhu/kurzy-devizoveho-trhu/denni_kurz.txt'));

    if (response.statusCode == 200) {
      String data = response.body;
      List<String> lines = data.split("\n");
      List<ExchangeRate> rates = [];

      for (int i = 2; i < lines.length; i++) {
        // skip metadata
        List<String> parts = lines[i].split("|");
        if (parts.length < 5) continue; // Skip empty or invalid lines

        rates.add(ExchangeRate(
          country: parts[0],
          currency: parts[1],
          code: parts[3],
          rate: double.parse(parts[4].replaceAll(",", ".")),
        ));
      }
    } else {
      print('Failed to get exchange rate from internet');
    }
  }

  void addCurrency(String name, String symbol, double exchangeRate) async {
    await _db.into(_db.currencyItems).insert(CurrencyItemsCompanion(
        name: Value(name),
        symbol: Value(symbol),
        exchangeRate: Value(exchangeRate)));

    notifyListeners();
  }

  void exportData() async {
    List<TransactionItem> allTransactions =
        await _db.select(_db.transactionItems).get();
  }
}
