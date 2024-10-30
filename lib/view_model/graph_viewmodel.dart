import 'package:flutter/material.dart';
import 'package:personal_finance/data/database.dart';

class GraphViewModel extends ChangeNotifier {
  final AppDatabase _db;

  GraphViewModel(this._db);
}
