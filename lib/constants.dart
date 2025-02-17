import 'package:flutter/material.dart';
import 'package:personal_finance/model/graph.dart';

// based on material design guidelines
// https://m3.material.io/foundations/layout/applying-layout/window-size-classes#2b82eea6-5d69-4a73-a7ab-8d9296f5a26d
const compactScreenWidth = 600.0;
const mediumScreenWidth = 840.0;
const largeScreenWidth = 1200.0;
const navigationRailWidth = 111.0;

// UI customisation
const tealColor = Color(0x007fb9ae);

const maxNoteLength = 1000;

// database name
const databaseName = 'personal_finance_db';

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
