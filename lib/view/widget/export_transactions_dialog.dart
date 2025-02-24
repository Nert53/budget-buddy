import 'package:flutter/material.dart';
import 'package:personal_finance/view_model/settings_viewmodel.dart';

class ExportTransactionsDialog extends StatefulWidget {
  final SettingsViewmodel viewModel;
  const ExportTransactionsDialog({super.key, required this.viewModel});

  @override
  State<ExportTransactionsDialog> createState() =>
      _ExportTransactionsDialogState();
}

class _ExportTransactionsDialogState extends State<ExportTransactionsDialog> {
  String _selectedFormat = 'json';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Export Transactions'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('All transactions will be exported into selected format.'),
          ListTile(
            title: const Text('.json'),
            contentPadding: EdgeInsets.zero,
            leading: Radio(
              value: 'csv',
              groupValue: _selectedFormat,
              onChanged: (String? value) {
                setState(() {
                  if (value != null) _selectedFormat = value;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('.csv'),
            contentPadding: EdgeInsets.zero,
            leading: Radio(
              value: 'json',
              groupValue: _selectedFormat,
              onChanged: (String? value) {
                setState(() {
                  if (value != null) _selectedFormat = value;
                });
              },
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            widget.viewModel.exportData();
            Navigator.of(context).pop();
          },
          child: Text('Export'),
        ),
      ],
    );
  }
}
