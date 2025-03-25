import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:personal_finance/data/database.dart';
import 'package:personal_finance/utils/functions.dart';
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
    TextEditingController nameController = TextEditingController();
    TextEditingController symbolController = TextEditingController();
    TextEditingController exchangeRateController = TextEditingController();
    symbolController.text = widget.currentCurrency.symbol;
    nameController.text = widget.currentCurrency.name;
    exchangeRateController.text =
        widget.currentCurrency.exchangeRate.toString();

    return AlertDialog(
      title: Row(
        children: [
          Expanded(child: Text('Edit currency')),
          IconButton(
            onPressed: () => {
              widget.viewModel.deleteCurrency(widget.currentCurrency),
              Navigator.pop(context),
            },
            icon: Tooltip(
              message: 'Delete currency and all transactions with it.',
              child: Icon(
                Icons.delete_outline,
                color: Theme.of(context).colorScheme.error,
                size: 28.0,
              ),
            ),
            tooltip: 'Delete currency.',
          )
        ],
      ),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(
          controller: nameController,
          keyboardType: TextInputType.text,
          inputFormatters: [
            LengthLimitingTextInputFormatter(20),
            FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-ZÀ-ÿ\s]+$')),
          ],
          decoration: InputDecoration(
              label: Text('Name'),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)))),
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: symbolController,
                keyboardType: TextInputType.text,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(3),
                  FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z]+$')),
                ], // Skrytí ukazatele počtu znaků
                decoration: InputDecoration(
                    label: Text('Symbol (ideally ISO4217)'),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)))),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: exchangeRateController,
                onTapOutside: (_) {
                  FocusScope.of(context).unfocus();
                },
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10),
                  FilteringTextInputFormatter.allow(RegExp(r'^[0-9.]+$')),
                  TextInputFormatter.withFunction(
                    (oldValue, newValue) => newValue.copyWith(
                      text: newValue.text.replaceAll(',', '.'),
                    ),
                  ),
                ],
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
              onPressed: () async {
                var isConnected = await isConnectedToInternet();

                if (!isConnected) {
                  if (context.mounted) {
                    Flushbar(
                      icon: Icon(Icons.signal_wifi_off_rounded,
                          color: Theme.of(context).colorScheme.surface),
                      message:
                          "Device is not connected to the internet. Please check the connection.",
                      shouldIconPulse: false,
                      messageColor: Theme.of(context).colorScheme.surface,
                      backgroundColor: Theme.of(context).colorScheme.error,
                      borderRadius: BorderRadius.circular(16),
                      margin: const EdgeInsets.all(12),
                      duration: Duration(seconds: 4),
                    ).show(context);
                  }
                  return;
                }

                var newRate = await widget.viewModel
                    .getExchangeRateFromInternet(widget.currentCurrency.symbol);

                if (newRate == 0.0) {
                  if (context.mounted) {
                    Flushbar(
                      icon: Icon(Icons.warning_amber_rounded,
                          color: Theme.of(context).colorScheme.surface),
                      message:
                          "Currency is not supported by CNB or the code entered is not correct.",
                      shouldIconPulse: false,
                      messageColor: Theme.of(context).colorScheme.surface,
                      backgroundColor: Colors.amber[700]!,
                      borderRadius: BorderRadius.circular(16),
                      margin: const EdgeInsets.all(12),
                      duration: Duration(seconds: 4),
                    ).show(context);
                  }
                  return;
                }

                exchangeRateController.text = newRate.toStringAsFixed(3);
                if (context.mounted) {
                  Flushbar(
                    icon: Icon(Icons.check_circle_outline_rounded,
                        color: Theme.of(context).colorScheme.surface),
                    message: "Exchange rate updated.",
                    shouldIconPulse: false,
                    messageColor: Theme.of(context).colorScheme.surface,
                    backgroundColor: Colors.green[700]!,
                    borderRadius: BorderRadius.circular(16),
                    margin: const EdgeInsets.all(12),
                    duration: Duration(seconds: 3),
                  ).show(context);
                }
              },
              icon: Icon(Icons.change_circle),
              tooltip: 'Adjust exchange rate from Czech National Bank.',
            ),
          ],
        ),
      ]),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            // empty when saving will keep the old value

            double newExchangeRate;
            try {
              newExchangeRate = double.parse(exchangeRateController.text);
            } catch (e) {
              Flushbar(
                icon: Icon(Icons.warning_amber_rounded,
                    color: Theme.of(context).colorScheme.surface),
                message: "Please enter valid values or tap `cancel` button.",
                shouldIconPulse: false,
                messageColor: Theme.of(context).colorScheme.surface,
                backgroundColor: Colors.amber[700]!,
                borderRadius: BorderRadius.circular(16),
                margin: const EdgeInsets.all(12),
                duration: Duration(seconds: 3),
              ).show(context);
              return;
            }

            widget.viewModel.updateCurrency(widget.currentCurrency,
                nameController.text, symbolController.text, newExchangeRate);
            Navigator.pop(context);
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
