import 'package:flutter/material.dart';
import 'package:personal_finance/data/database.dart';
import 'package:personal_finance/model/graph.dart';

class GraphViewModel extends ChangeNotifier {
  final AppDatabase _db;

  List<Graph> allGraphs = [
    Graph(id: 1, name: 'Top Categories', icon: Icons.sort, selected: false),
    Graph(
        id: 2,
        name: 'Spendings in time',
        icon: Icons.bar_chart,
        selected: true),
    Graph(
        id: 3,
        name: 'Account balance in time',
        icon: Icons.show_chart,
        selected: false),
    Graph(
        id: 4,
        name: 'Interesting numbers',
        icon: Icons.pin_outlined,
        selected: false),
    Graph(
        id: 5,
        name: 'Income type ratio',
        icon: Icons.pie_chart_outline,
        selected: true),
    Graph(
        id: 6,
        name: 'Spending type ratio',
        icon: Icons.donut_large_outlined,
        selected: false),
  ];

  GraphViewModel(this._db);
}
