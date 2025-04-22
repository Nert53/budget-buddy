import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:personal_finance/constants.dart';
import 'package:shortuid/shortuid.dart';

part 'database.g.dart';

class TransactionItems extends Table {
  TextColumn get id => text().clientDefault(() => ShortUid.create())();
  RealColumn get amount => real()();
  RealColumn get amountInCZK => real()();
  DateTimeColumn get date => dateTime()();
  TextColumn get note => text()();
  BoolColumn get isOutcome => boolean()();
  TextColumn get category => text().references(CategoryItems, #id)();
  TextColumn get currency => text().references(CurrencyItems, #id)();
}

class CategoryItems extends Table {
  TextColumn get id => text().clientDefault(() => ShortUid.create())();
  TextColumn get name => text().withLength(min: 1, max: 32)();
  IntColumn get colorCode => integer()();
  IntColumn get icon => integer()();
}

class CurrencyItems extends Table {
  TextColumn get id => text().clientDefault(() => ShortUid.create())();
  TextColumn get name => text().withLength(min: 1, max: 32)();
  TextColumn get symbol => text().withLength(min: 1, max: 3)();
  RealColumn get exchangeRate => real()(); // exchange rate to CZK
}

@DriftDatabase(tables: [TransactionItems, CategoryItems, CurrencyItems])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forCustomDatabase(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          await initialCategoriesInsert();
          await initialCurrenciesInsert();
        },
      );

  Stream<List<TransactionItem>> watchTransactions() {
    return select(transactionItems).watch();
  }

  Stream<List<CategoryItem>> watchCategories() {
    return select(categoryItems).watch();
  }

  Stream<List<CurrencyItem>> watchCurrencies() {
    return select(currencyItems).watch();
  }

  // 01 methods for operating with transactions
  Future<int> addTransaction(TransactionItemsCompanion transaction) async {
    return await into(transactionItems).insert(transaction);
  }

  Future<int> deleteTransactionItem(TransactionItem item) async {
    return await delete(transactionItems).delete(item);
  }

  Future<int> deleteTransactionById(String id) async {
    return await (delete(transactionItems)..where((tbl) => tbl.id.equals(id)))
        .go();
  }

  Future<List<TransactionItem>> getAllTransactionItems() async {
    return await select(transactionItems).get();
  }

  Future<int> deleteAllTransactions() async {
    return await delete(transactionItems).go();
  }

  // 02 methods for operating with categories
  Future<List<CategoryItem>> getAllCategoryItems() async {
    return await select(categoryItems).get();
  }

  Future<CategoryItem> getCategoryById(String id) async {
    return await (select(categoryItems)..where((c) => c.id.equals(id)))
        .getSingle();
  }

  Future<int> insertCategory(String name, int colorCode, int iconCode) async {
    return await into(categoryItems).insert(CategoryItemsCompanion(
        name: Value(name), color: Value(colorCode), icon: Value(iconCode)));
  }

  Future<bool> deleteCategoryHard(CategoryItem category) async {
    // delete all transactions with this category and the category
    try {
      transaction(() async {
        await (delete(transactionItems)
              ..where((tbl) => tbl.category.equals(category.id)))
            .go();

        await (delete(categoryItems)
              ..where((tbl) => tbl.id.equals(category.id)))
            .go();
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateCategory(CategoryItem category) async {
    try {
      await (update(categoryItems)..where((tbl) => tbl.id.equals(category.id)))
          .write(category);

      return true;
    } catch (e) {
      return false;
    }
  }

  // 03 methods for operating with currencies
  Future<List<CurrencyItem>> getAllCurrencyItems() async {
    return await select(currencyItems).get();
  }

  Future<CurrencyItem> getCurrencyById(String id) async {
    return await (select(currencyItems)..where((c) => c.id.equals(id)))
        .getSingle();
  }

  Future<int> insertCurrency(
      String name, String symbol, double exchangeRate) async {
    return await into(currencyItems).insert(CurrencyItemsCompanion(
        name: Value(name),
        symbol: Value(symbol),
        exchangeRate: Value(exchangeRate)));
  }

  Future<int> deleteCurrency(String currencyId) async {
    return await (delete(currencyItems)
          ..where((tbl) => tbl.id.equals(currencyId)))
        .go();
  }

  // 04 initial data insert
  Future<Null> initialCategoriesInsert() async {
    return await transaction(() async {
      await into(categoryItems).insert(
        CategoryItemsCompanion.insert(
          name: 'Employment',
          color: 4282339765, // dark blue
          icon: 983750,
        ),
      );
      await into(categoryItems).insert(
        CategoryItemsCompanion.insert(
          name: 'Freelance Job',
          color: 4286141768, // brown
          icon: 984740,
        ),
      );
      await into(categoryItems).insert(
        CategoryItemsCompanion.insert(
          name: 'Groceries',
          color: 4283215696, // dark green
          icon: 62335,
        ),
      );
      await into(categoryItems).insert(
        CategoryItemsCompanion.insert(
          name: 'Dining',
          color: 4288585374, // blue gray
          icon: 62230,
        ),
      );
      await into(categoryItems).insert(
        CategoryItemsCompanion.insert(
          name: 'Transport',
          color: 4294951175, // amber
          icon: 61382,
        ),
      );
      await into(categoryItems).insert(
        CategoryItemsCompanion.insert(
          name: 'Entertainment',
          color: 4293467747, // purple
          icon: 62606,
        ),
      );
      await into(categoryItems).insert(
        CategoryItemsCompanion.insert(
          name: 'Health',
          color: 4294198070, // dark red
          icon: 61887,
        ),
      );
    });
  }

  Future<Null> initialCurrenciesInsert() async {
    return await transaction(() async {
      await into(currencyItems).insert(
        CurrencyItemsCompanion.insert(
          name: 'Czech Koruna',
          symbol: 'CZK',
          exchangeRate: 1.0,
        ),
      );
      await into(currencyItems).insert(
        CurrencyItemsCompanion.insert(
          name: 'Euro',
          symbol: 'EUR',
          exchangeRate: 25.2,
        ),
      );
      await into(currencyItems).insert(
        CurrencyItemsCompanion.insert(
          name: 'Dollar',
          symbol: 'USD',
          exchangeRate: 24.0,
        ),
      );
      await into(currencyItems).insert(
        CurrencyItemsCompanion.insert(
          name: 'Pound',
          symbol: 'GBP',
          exchangeRate: 30.4,
        ),
      );
    });
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(name: databaseName);
  }
}
