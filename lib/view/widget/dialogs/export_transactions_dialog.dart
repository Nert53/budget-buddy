import 'package:another_flushbar/flushbar.dart';
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
            title: const Text('.csv'),
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
              'sqlite file (only for backup)',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
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
              Flushbar(
                icon: succesExport
                    ? Icon(
                        Icons.check_circle_outline_rounded,
                        color: Colors.white,
                      )
                    : Icon(
                        Icons.error_outline_rounded,
                        color: Theme.of(context).colorScheme.onError,
                      ),
                message: succesExport
                    ? 'Transactions exported successfully.'
                    : 'Failed to export transactions.',
                shouldIconPulse: false,
                messageColor: succesExport
                    ? Colors.white
                    : Theme.of(context).colorScheme.onError,
                backgroundColor: succesExport
                    ? Colors.green
                    : Theme.of(context).colorScheme.error,
                borderRadius: BorderRadius.circular(16),
                margin: const EdgeInsets.all(12),
                duration: Duration(seconds: 4),
              ).show(context);
            }
          },
          child: Text('Export'),
        ),
      ],
    );
  }
}
