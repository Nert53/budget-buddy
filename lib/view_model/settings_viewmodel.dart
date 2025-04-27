import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:personal_finance/constants.dart';
import 'package:personal_finance/repository/database.dart';
import 'package:personal_finance/model/exchange_rate.dart';
import 'package:personal_finance/model/transaction.dart';
import 'package:sqlite3/sqlite3.dart';

class SettingsViewmodel extends ChangeNotifier {
  bool isLoading = true;
  final AppDatabase _db;

  List<CurrencyItem> currencies = [];

  SettingsViewmodel(this._db) {
    isLoading = true;
    _db.watchCurrencies().listen((event) {
      getAllData();
    });
    _db.watchCategories().listen((event) {
      getAllData();
    });

    getAllData();
    notifyListeners();
  }

  void getAllData() {
    isLoading = true;
    getCurrencies();
    isLoading = false;
    notifyListeners();
  }

  void getCurrencies() async {
    currencies = await _db.getAllCurrencyItems();
    notifyListeners();
  }

  void updateCurrency(CurrencyItem currencyItem, String newName,
      String newSymbol, double newExchangeRate) async {
    await _db.updateCurrency(
        currencyItem.id, newName, newSymbol, newExchangeRate);

    notifyListeners();
  }

  Future<double> getExchangeRateFromInternet(String wantedCurrencyCode) async {
    http.Response response = await http.get(Uri.parse(exchangeRateUrl));

    // OK response
    if (response.statusCode == 200) {
      String data = response.body;
      List<String> lines = data.split("\n");
      List<ExchangeRate> rates = [];

      for (int i = 2; i < lines.length; i++) {
        // skip metadata
        List<String> parts = lines[i].split("|");
        // skip empty or invalid lines
        if (parts.length < 5) continue;

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
        wantedRate = 0.0;
      }

      return wantedRate;
    } else {
      // failed to get data from internet
      return 0.0;
    }
  }

  void addCurrency(String name, String symbol, double exchangeRate) async {
    await _db.insertCurrency(name, symbol, exchangeRate);

    notifyListeners();
  }

  void deleteCurrency(CurrencyItem currencyItem) async {
    await _db.deleteCurrencyHard(currencyItem.id);

    notifyListeners();
  }

  Future<int> deleteAllTransactions() async {
    return await _db.deleteAllTransactions();
  }

  Future<bool> exportData(String selectedFormat) async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory == null) return false;

    // exporting whole sqlite file have different process
    if (selectedFormat == 'sqlite') {
      return exportDatabase(selectedDirectory);
    }

    if (selectedFormat != 'json' && selectedFormat != 'csv') return false;

    final transactions = await _db.getAllTransactionItems();
    final categories = await _db.getAllCategoryItems();
    final currencies = await _db.getAllCurrencyItems();

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
    File file = File(
        '$selectedDirectory/budget-buddy-export-$currentDate.$selectedFormat');
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

  Future<bool> exportDatabase(String selectedDirectory) async {
    final appDirecrtory = await getApplicationDocumentsDirectory();
    final dbDirectory = path.join(appDirecrtory.path, '$databaseName.db');
    String now = DateFormat('yy_MM_dd-HH_mm').format(DateTime.now());

    final backupDb = sqlite3.open(dbDirectory);
    final tempDb =
        path.join(selectedDirectory, 'budget-buddy-export-$now.sqlite');
    backupDb
      ..execute('VACUUM INTO ?', [tempDb])
      ..dispose();

    return true;
  }
}
