import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:personal_finance/view/constants/colors_categories.dart';
import 'package:personal_finance/view/constants/icons_categories.dart';
import 'package:personal_finance/view_model/settings_viewmodel.dart';

class AddCurrencyDialog extends StatefulWidget {
  final SettingsViewmodel viewModel;
  const AddCurrencyDialog({super.key, required this.viewModel});

  @override
  State<AddCurrencyDialog> createState() => AddCurrencyDialogState();
}

class AddCurrencyDialogState extends State<AddCurrencyDialog> {
  TextEditingController categoryNameController = TextEditingController();
  late Color newCategoryColor;
  late IconData newCategoryIcon;

  @override
  void initState() {
    newCategoryColor = allCategoryColors.first;
    newCategoryIcon = allCategoryIcons.first;
    super.initState();
  }

  void changeNewCategoryColor(Color newColor) {
    setState(() {
      newCategoryColor = newColor;
    });
  }

  void changeNewCategoryIcon(IconData newIcon) {
    setState(() {
      newCategoryIcon = newIcon;
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController symbolController = TextEditingController();
    TextEditingController exchangeRateController = TextEditingController();

    return AlertDialog(
      title: Text('Add new currency'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(
                labelText: 'Currency name',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)))),
          ),
          SizedBox(
            height: 12,
          ),
          TextField(
            controller: symbolController,
            maxLength: 5,
            decoration: InputDecoration(
                labelText: 'Currency symbol',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)))),
          ),
          SizedBox(
            height: 12,
          ),
          TextField(
            controller: exchangeRateController,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              // allow only numbers and dot/comma and comma is replaced with dot
              FilteringTextInputFormatter.allow(RegExp(r'(^\d*[.,]?\d*)')),
              TextInputFormatter.withFunction(
                (oldValue, newValue) => newValue.copyWith(
                  text: newValue.text.replaceAll(',', '.'),
                ),
              ),
            ],
            decoration: InputDecoration(
                labelText: 'Exchange rate to CZK',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)))),
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
            widget.viewModel.addCurrency(
                nameController.text,
                symbolController.text,
                double.parse(exchangeRateController.text));
            Navigator.pop(context);
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}
