import 'package:personal_finance/model/transaction.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TransactionDatabase {
  static final TransactionDatabase _instance = TransactionDatabase._init();
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
          CREATE TABLE ${TransactionFields.tableName} (
            ${TransactionFields.id} ${TransactionFields.idType},
            ${TransactionFields.amount} ${TransactionFields.amountType},
            ${TransactionFields.date} ${TransactionFields.dateType},
            ${TransactionFields.note} ${TransactionFields.noteType},
            ${TransactionFields.category} ${TransactionFields.categoryType},
            ${TransactionFields.currency} ${TransactionFields.currencyType})''');
  }

  Future close() async {
    final db = await _instance.database;
    db.close();
  }

  
}
