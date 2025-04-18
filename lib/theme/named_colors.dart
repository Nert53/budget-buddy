import 'package:flutter/material.dart';

enum NamedColor {
  teal('teal', Colors.teal),
  blue('blue', Colors.blue),
  green('green', Colors.green),
  orange('orange', Colors.deepOrange),
  purple('purple', Colors.purple),
  red('red', Colors.red),
  yellow('yellow', Colors.yellow);

  final String name;
  final Color color;

  const NamedColor(this.name, this.color);
}
