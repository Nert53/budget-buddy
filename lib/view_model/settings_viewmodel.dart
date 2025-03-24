import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:personal_finance/data/database.dart';
import 'package:personal_finance/model/exchange_rate.dart';
import 'package:personal_finance/model/transaction.dart';

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

  void updateCurrency(CurrencyItem currencyItem, String newName,
      String newSymbol, double newExchangeRate) async {
    await (_db.update(_db.currencyItems)
          ..where((tbl) => tbl.id.equals(currencyItem.id)))
        .write(CurrencyItemsCompanion(
      name: Value(newName),
      symbol: Value(newSymbol),
      exchangeRate: Value(newExchangeRate),
    ));

    notifyListeners();
  }

  Future<double> getExchangeRateFromInternet(String wantedCurrencyCode) async {
    http.Response response = await http.get(Uri.parse(
        'https://www.cnb.cz/cs/financni-trhy/devizovy-trh/kurzy-devizoveho-trhu/kurzy-devizoveho-trhu/denni_kurz.txt'));

    if (response.statusCode == 200) {
      String data = response.body;
      List<String> lines = data.split("\n");
      List<ExchangeRate> rates = [];

      for (int i = 2; i < lines.length; i++) {
        // skip metadata
        List<String> parts = lines[i].split("|");
        if (parts.length < 5) continue; // skip empty or invalid lines

        int amount = int.parse(parts[2]);
        rates.add(ExchangeRate(
          country: parts[0],
          currency: parts[1],
          code: parts[3],
          rate: double.parse(parts[4].replaceAll(",", ".")) / amount,
        ));
      }

      double wantedRate;
      try {
        wantedRate = rates
            .firstWhere(
                (element) => element.code == wantedCurrencyCode.toUpperCase())
            .rate;
      } catch (e) {
        // currency code not found
        return 0.0;
      }

      return wantedRate;
    } else {
      // failed to get data from internet
      return 0.0;
    }
  }

  void addCurrency(String name, String symbol, double exchangeRate) async {
    await _db.into(_db.currencyItems).insert(CurrencyItemsCompanion(
        name: Value(name),
        symbol: Value(symbol),
        exchangeRate: Value(exchangeRate)));

    notifyListeners();
  }

  void deleteCurrency(CurrencyItem currencyItem) async {
    await _db.transaction(() async {
      await _db.deleteCurrencyItem(currencyItem);
      await (_db.delete(_db.transactionItems)
            ..where((t) => t.currency.equals(currencyItem.id)))
          .go();
    });

    notifyListeners();
  }

  Future<bool> exportDataJson() async {
    return true;
  }

  Future<bool> exportData(String selectedFormat) async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory == null) return false;

    if (selectedFormat != 'json' && selectedFormat != 'csv') return false;

    final transactions = await _db.select(_db.transactionItems).get();
    final categories = await _db.select(_db.categoryItems).get();
    final currencies = await _db.select(_db.currencyItems).get();

    List<Transaction> transactionsToExport = [];

    for (final t in transactions) {
      final category = categories.firstWhere(
          (element) => element.id == t.category,
          orElse: () => CategoryItem(
              id: '0',
              name: 'Unknown',
              icon: Icons.error.codePoint,
              color: Colors.grey.value));

      final currency = currencies.firstWhere(
          (element) => element.id == t.currency,
          orElse: () => CurrencyItem(
              id: '0', name: 'Unknown', symbol: '??', exchangeRate: 1.0));

      transactionsToExport.add(Transaction(
        id: t.id,
        amount: t.amount,
        date: t.date,
        note: t.note,
        isOutcome: t.isOutcome,
        categoryId: category.id,
        categoryName: category.name,
        categoryIcon: IconData(category.icon),
        categoryColor: Color(category.color),
        currencyId: currency.id,
        currencyName: currency.name,
        currencySymbol: currency.symbol,
      ));
    } 

    String currentDate = DateFormat('yy-MM-dd').format(DateTime.now());
    File file = File('$selectedDirectory/budget-buddy-export-$currentDate.$selectedFormat');
    if (selectedFormat == 'json') {
      saveJsonFile(transactionsToExport, file);
    } else if (selectedFormat == 'csv') {
      saveCsvFile(transactionsToExport, file);
    }

    return true;
  }

  void saveJsonFile(List<Transaction> transactionsToExport, File file) async {
    List<Map<String, dynamic>> jsonData = transactionsToExport.map((t) {
      return {
        'id': t.id,
        'amount': t.amount,
        'date': t.date.toIso8601String(),
        'note': t.note,
        'isOutcome': t.isOutcome,
        'categoryId': t.categoryId,
        'categoryName': t.categoryName,
        'categoryIcon': t.categoryIcon.codePoint,
        'categoryColor': t.categoryColor.value,
        'currencyId': t.currencyId,
        'currencyName': t.currencyName,
        'currencySymbol': t.currencySymbol,
      };
    }).toList();

    await file.writeAsString(jsonEncode(jsonData));
  }

  void saveCsvFile(List<Transaction> transactionsToExport, File file) {
    String header =
        'id,amount,date,note,isOutcome,categoryId,categoryName,categoryIcon,categoryColor,currencyId,currencyName,currencySymbol\n';
    for (final t in transactionsToExport) {
      header +=
          '${t.id},${t.amount},${t.date.toIso8601String()},${t.note},${t.isOutcome},${t.categoryId},${t.categoryName},${t.categoryIcon.codePoint},${t.categoryColor.value},${t.currencyId},${t.currencyName},${t.currencySymbol}\n';
    }
    file.writeAsStringSync(header);
  }
}
