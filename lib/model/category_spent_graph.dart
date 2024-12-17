import 'package:flutter/material.dart';

class CategorySpentGraph {
  final String id;
  final String name;
  final Color color;
  final IconData icon;
  final double amount;

  CategorySpentGraph({
    required this.name,
    required this.color,
    required this.icon,
    required this.id,
    required this.amount,
  });
}
