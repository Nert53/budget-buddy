import 'package:personal_finance/model/transaction.dart' as t;
import 'package:shortuid/shortuid.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TransactionDatabase {
  static final TransactionDatabase instance = TransactionDatabase._init();
  static Database? _database;

  TransactionDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase('transaction.db');
    return _database!;
  }

  Future<Database> _initDatabase(String filePath) async {
    final databasePath = join(await getDatabasesPath(), filePath);

    return await openDatabase(databasePath,
        version: 1, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
          CREATE TABLE ${t.TransactionFields.tableName} (
            ${t.TransactionFields.id} ${t.TransactionFields.idType},
            ${t.TransactionFields.amount} ${t.TransactionFields.amountType},
            ${t.TransactionFields.date} ${t.TransactionFields.dateType},
            ${t.TransactionFields.note} ${t.TransactionFields.noteType},
            ${t.TransactionFields.category} ${t.TransactionFields.categoryType},
            ${t.TransactionFields.currency} ${t.TransactionFields.currencyType})''');

    addValue(t.Transaction(
      id: ShortUid.create(),
      amount: 100.0,
      date: DateTime.now(),
      note: 'Nakup Albert',
      category: 'supermarket',
      currency: 'USD',
    ));

    addValue(t.Transaction(
      id: ShortUid.create(),
      amount: 200.0,
      date: DateTime.now().subtract(const Duration(days: 1)),
      note: 'Alza elektro',
      category: 'elektornika',
      currency: 'CZK',
    ));

    addValue(t.Transaction(
      id: ShortUid.create(),
      amount: 300.0,
      date: DateTime.now().add(const Duration(days: 2)),
      note: 'Nakup Albert',
      category: 'supermarket',
      currency: 'CZK',
    ));
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  Future<bool> addValue(t.Transaction transaction) async {
    final db = await instance.database;

    if (await db.insert(t.TransactionFields.tableName, transaction.toJson()) ==
        0) {
      return false;
    }
    return true;
  }

  Future<List<t.Transaction>> getValues() async {
    final db = await instance.database;
    final List<Map<String, Object?>> result =
        await db.query(t.TransactionFields.tableName);
    return result.map((json) => t.Transaction.fromJson(json)).toList();
  }
}
