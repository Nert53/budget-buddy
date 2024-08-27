import 'package:flutter/material.dart';

class Destination {
  const Destination(this.icon, this.label);
  final IconData icon;
  final String label;
}

const List<Destination> destinations = <Destination>[
  Destination(Icons.home_outlined, 'Dashboard'),
  Destination(Icons.receipt_long_outlined, 'History'),
  Destination(Icons.query_stats_rounded, 'Graphs'),
];
