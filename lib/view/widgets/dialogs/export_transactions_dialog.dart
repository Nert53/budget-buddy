import 'package:flutter/material.dart';
import 'package:personal_finance/view/widgets/flushbars.dart';
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
            title: const Text('JSON'),
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
          ListTile(
            title: const Text('CSV'),
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
            title: Text(
              'SQLite file (only for backup)',
            ),
            contentPadding: EdgeInsets.zero,
            leading: Radio(
              value: 'sqlite',
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
          onPressed: () async {
            bool succesExport =
                await widget.viewModel.exportData(_selectedFormat);
            if (context.mounted) {
              Navigator.of(context).pop();
              succesExport
                  ? FlushbarSuccess.show(
                      context: context,
                      message: 'Transactions exported successfully',
                    )
                  : FlushbarError.show(
                      context: context,
                      message: 'Error during export. Please try again later.',
                    );
            }
          },
          child: Text('Export'),
        ),
      ],
    );
  }
}
