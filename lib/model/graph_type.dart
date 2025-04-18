import 'package:flutter/material.dart';

class GraphType {
  final int id;
  final String name;
  final String namePretty;
  final IconData icon;
  bool selected;

  GraphType(
      {required this.id,
      required this.name,
      required this.namePretty,
      required this.icon,
      required this.selected});
}
