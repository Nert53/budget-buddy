import 'package:flutter/material.dart';

class Destination {
  const Destination(this.icon, this.selectedIcon, this.label);
  final IconData icon;
  final IconData selectedIcon;
  final String label;
}

const List<Destination> destinations = <Destination>[
  Destination(
      Icons.space_dashboard_outlined, Icons.space_dashboard, 'Dashboard'),
  Destination(Icons.receipt_outlined, Icons.receipt, 'Transactions'),
  Destination(Icons.pie_chart_outline, Icons.pie_chart, 'Graphs'),
  Destination(Icons.settings_outlined, Icons.settings, 'Settings'),
];
