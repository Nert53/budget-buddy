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
  IntColumn get color => integer()();
  TextColumn get icon => text().withLength(min: 1, max: 32)();
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

  Stream<List<TransactionItem>> watchAllTransactions() {
    return select(transactionItems).watch();
  }

  Stream<List<CategoryItem>> watchAllCategories() {
    return select(categoryItems).watch();
  }

  Stream<List<CurrencyItem>> watchAllCurrencies() {
    return select(currencyItems).watch();
  }

  addItem(TransactionItem item) {
    transaction(() async {
      await into(transactionItems).insert(item);
    });
  }

  Future<Null> initialCategoriesInsert() async {
    return await transaction(() async {
      await into(categoryItems).insert(
        CategoryItemsCompanion.insert(
          name: 'Employment',
          color: 0xFF0014a1, // dark blue
          icon: 'work',
        ),
      );
      await into(categoryItems).insert(
        CategoryItemsCompanion.insert(
          name: 'Freelance Job',
          color: 0xFF795548, // brown
          icon: 'handshake',
        ),
      );
      await into(categoryItems).insert(
        CategoryItemsCompanion.insert(
          name: 'Home',
          color: 0xFFf18117, // orange
          icon: 'home',
        ),
      );
      await into(categoryItems).insert(
        CategoryItemsCompanion.insert(
          name: 'Groceries',
          color: 0xFF558B2F, // dark green
          icon: 'grocery',
        ),
      );
      await into(categoryItems).insert(
        CategoryItemsCompanion.insert(
          name: 'Dining',
          color: 0xFF546E7A, // blue gray
          icon: 'restaurant',
        ),
      );
      await into(categoryItems).insert(
        CategoryItemsCompanion.insert(
          name: 'Transport',
          color: 0xFFFFCA28, // amber
          icon: 'directions_car',
        ),
      );
      await into(categoryItems).insert(
        CategoryItemsCompanion.insert(
          name: 'Entertainment',
          color: 0xFF9C27B0, // purple
          icon: 'celebration',
        ),
      );
      await into(categoryItems).insert(
        CategoryItemsCompanion.insert(
          name: 'Health',
          color: 0xFFD50000, // dark red
          icon: 'health',
        ),
      );
    });
  }

  Future<Null> initialCurrenciesInsert() async {
    return await transaction(() async {
      await into(currencyItems).insert(
        CurrencyItemsCompanion.insert(
          name: 'Euro',
          symbol: '€',
          exchangeRate: 25.2,
        ),
      );
      await into(currencyItems).insert(
        CurrencyItemsCompanion.insert(
          name: 'Dollar',
          symbol: "\$",
          exchangeRate: 24.0,
        ),
      );
      await into(currencyItems).insert(
        CurrencyItemsCompanion.insert(
          name: 'Czech Koruna',
          symbol: 'Kč',
          exchangeRate: 1.0,
        ),
      );
      await into(currencyItems).insert(
        CurrencyItemsCompanion.insert(
          name: 'Pound',
          symbol: '£',
          exchangeRate: 30.4,
        ),
      );
    });
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(name: databaseName);
  }
}
