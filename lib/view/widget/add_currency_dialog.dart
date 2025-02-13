import 'package:flutter/material.dart';
import 'package:personal_finance/constants.dart';
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
            Navigator.pop(context);
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}
