import 'package:flutter/material.dart';

class CategoryFields {
  static const String tableName = 'categories';

  static const String idType = 'TEXT PRIMARY KEY';
  static const String nameType = 'TEXT NOT NULL';
  static const String colorType = 'TEXT NOT NULL';
  static const String iconType = 'TEXT NOT NULL';
  static const String descriptionType = 'TEXT';

  static const String id = 'id';
  static const String name = 'name';
  static const String color = 'color';
  static const String icon = 'icon';
  static const String description = 'description';
}

class Category {
  String name;
  Color color;
  IconData icon;
  String description;

  Category({
    required this.name,
    required this.color,
    required this.icon,
    required this.description,
  });
}
