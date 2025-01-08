import 'package:flutter/material.dart';

class Graph {
  final int id;
  final String name;
  final IconData icon;
  bool selected;

  Graph(
      {required this.id,
      required this.name,
      required this.icon,
      required this.selected});
}
