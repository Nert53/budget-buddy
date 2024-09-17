import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:personal_finance/model/transaction.dart';

part 'database.g.dart';

class TransactionItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get amount => real()();
  DateTimeColumn get date => dateTime()();
  TextColumn get note => text()();
  TextColumn get category => text().withLength(min: 1, max: 32)();
  TextColumn get currency => text().withLength(min: 2, max: 3)();
}


@DriftDatabase(tables: [TransactionItems])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: TransactionFields.tableName);
  }
}
