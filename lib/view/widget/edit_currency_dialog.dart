import 'package:flutter/material.dart';
import 'package:personal_finance/data/database.dart';
import 'package:personal_finance/view_model/settings_viewmodel.dart';

class EditCurrencyDialog extends StatefulWidget {
  final SettingsViewmodel viewModel;
  final CurrencyItem currentCurrency;
  const EditCurrencyDialog(
      {super.key, required this.viewModel, required this.currentCurrency});

  @override
  State<EditCurrencyDialog> createState() => _EditCurrencyDialogState();
}

class _EditCurrencyDialogState extends State<EditCurrencyDialog> {
  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    controller.text = widget.currentCurrency.exchangeRate.toString();

    return AlertDialog(
      title: Text('Change exchange rate'),
      content: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  label: Text(
                      '1 ${widget.currentCurrency.name} (${widget.currentCurrency.symbol}) = '),
                  suffixText: 'CZK',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)))),
            ),
          ),
          SizedBox(width: 8),
          IconButton.filled(
            onPressed: () {},
            icon: Icon(Icons.change_circle),
            tooltip: 'Adjust exchange rate from internet.',
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            widget.viewModel.updateExchangeRate(
                widget.currentCurrency, double.parse(controller.text));
            Navigator.pop(context);
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
