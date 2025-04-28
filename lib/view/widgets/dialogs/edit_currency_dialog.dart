import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:personal_finance/repository/database.dart';
import 'package:personal_finance/utils/functions.dart';
import 'package:personal_finance/view/widgets/flushbars.dart';
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
              showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                        title: Text('Delete currency'),
                        content: Text(
                            'Are you sure you want to delete currency ${widget.currentCurrency.name}? All transactions assigned to this currency will also be deleted.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancel'),
                          ),
                          FilledButton(
                            onPressed: () {
                              widget.viewModel
                                  .deleteCurrency(widget.currentCurrency);
                              Navigator.pop(
                                  context); // close delete confirm dialog
                              Navigator.pop(
                                  context); // close edit currency dialog
                            },
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                  Theme.of(context).colorScheme.error),
                            ),
                            child: Text('Delete'),
                          )
                        ],
                      )),
            },
            icon: Tooltip(
              message: 'Delete currency and all assigned transactions.',
              child: Icon(
                Icons.delete_outline,
                color: Theme.of(context).colorScheme.error,
                size: 28.0,
              ),
            ),
            tooltip: 'Delete currency with all assigned transactions.',
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
              icon: Icon(Icons.change_circle),
              tooltip: 'Adjust exchange rate from Czech National Bank.',
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                          content: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator.adaptive(),
                              SizedBox(width: 12),
                              Text('Loading exchange rate...')
                            ],
                          ),
                        ));

                var isConnected = await isConnectedToInternet();

                if (context.mounted) {
                  Navigator.pop(context); // close loading dialog
                }

                if (!isConnected) {
                  if (context.mounted) {
                    FlushbarError.show(
                      context: context,
                      message: "No internet connection.",
                    );
                  }
                  return;
                }

                var newRate = await widget.viewModel
                    .getExchangeRateFromInternet(widget.currentCurrency.symbol);

                if (newRate == 0.0) {
                  if (context.mounted) {
                    FlushbarError.show(
                      context: context,
                      message:
                          "Currency is not supported by CNB or the code entered is not correct.",
                    );
                  }
                  return;
                }

                exchangeRateController.text = newRate.toStringAsFixed(2);
                if (context.mounted) {
                  FlushbarSuccess.show(
                    context: context,
                    message: "Exchange rate updated.",
                  );
                }
              },
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
            Navigator.pop(context);
            double newExchangeRate;
            try {
              newExchangeRate = double.parse(exchangeRateController.text);
            } catch (e) {
              FlushbarWarning.show(
                context: context,
                message: "Please enter valid values or tap cancel button.",
              );
              return;
            }

            widget.viewModel.updateCurrency(widget.currentCurrency,
                nameController.text, symbolController.text, newExchangeRate);
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
