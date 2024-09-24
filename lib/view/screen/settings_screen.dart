import 'package:drift_db_viewer/drift_db_viewer.dart';
import 'package:flutter/material.dart';
import 'package:personal_finance/data/database.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  final appDB = AppDatabase();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: DriftDbViewer(appDB));
  }
}
