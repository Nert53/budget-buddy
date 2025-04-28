import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:personal_finance/view/widgets/flushbars.dart';
import 'package:personal_finance/view_model/transactions_viewmodel.dart';

class SetRangeDialog extends StatefulWidget {
  final TransactionViewModel viewModel;
  final String name;
  final double amount;
  final double maxAmount;
  final bool isLowRange;
  const SetRangeDialog(
      {super.key,
      required this.viewModel,
      required this.name,
      required this.amount,
      required this.maxAmount,
      required this.isLowRange});

  @override
  State<SetRangeDialog> createState() => _EditCurrencyDialogState();
}

class _EditCurrencyDialogState extends State<SetRangeDialog> {
  @override
  Widget build(BuildContext context) {
    TextEditingController rangeController = TextEditingController();
    rangeController.text = widget.amount.toStringAsFixed(0);

    return AlertDialog(
        title: Row(
          children: [
            Expanded(child: Text(widget.name)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              double newAmount = double.tryParse(rangeController.text) ?? 0;
              if (rangeController.text.isEmpty ||
                  newAmount > widget.maxAmount) {
                FlushbarError.show(
                  context: context,
                  message:
                      "Amount can't be empty or greater than ${widget.maxAmount.toStringAsFixed(0)} CZK.",
                );
                return;
              }
              widget.isLowRange
                  ? widget.viewModel.updateLowRange(newAmount)
                  : widget.viewModel.updateHighRange(newAmount);
              Navigator.of(context).pop();
            },
            child: const Text('Set'),
          ),
        ],
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: rangeController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^[0-9.]+$')),
                TextInputFormatter.withFunction(
                  (oldValue, newValue) => newValue.copyWith(
                    text: newValue.text.replaceAll(',', '.'),
                  ),
                ),
              ],
              decoration: InputDecoration(
                  label: Text('Amount'),
                  suffixText: 'CZK',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)))),
            ),
          ],
        ));
  }
}
