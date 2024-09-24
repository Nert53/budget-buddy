import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:personal_finance/model/transaction.dart';
import 'package:shortuid/shortuid.dart';

part 'database.g.dart';

class TransactionItems extends Table {
  TextColumn get id => text().clientDefault(() => ShortUid.create())();
  RealColumn get amount => real()();
  DateTimeColumn get date => dateTime()();
  TextColumn get note => text()();
  TextColumn get category => text().withLength(min: 1, max: 32)();
  TextColumn get currency => text().withLength(min: 2, max: 3)();
}

class CategoryItems extends Table {
  TextColumn get id => text().clientDefault(() => ShortUid.create())();
  TextColumn get name => text().withLength(min: 1, max: 32)();
  IntColumn get color => integer()();
  TextColumn get icon => text().withLength(min: 1, max: 32)();
}

class CurrencyItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 32)();
  TextColumn get symbol => text().withLength(min: 1, max: 3)();
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
          await transaction(() async {
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
        },
      );

  static QueryExecutor _openConnection() {
    return driftDatabase(name: TransactionFields.tableName);
  }
}
