import 'package:flutter/material.dart';

class TestModel extends ChangeNotifier {
  List<String> data = ["Initial Home Data"];

  void refresh() {
    data.add("Updated Home Data at ${DateTime.now()}");
    notifyListeners();
  }
}
