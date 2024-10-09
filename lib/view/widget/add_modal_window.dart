import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:personal_finance/model/category.dart';
import 'package:personal_finance/model/currency.dart';
import 'package:personal_finance/view_model/add_transaction_viewmodel.dart';
import 'package:provider/provider.dart';

class AddModalWindow extends StatelessWidget {
  const AddModalWindow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    var model = context.watch<AddTransactionViewModel>();

    return SizedBox(
      height: screenHeight * 0.75,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 48,
              width: screenWidth,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(28.0),
                  topRight: Radius.circular(28.0),
                ),
              ),
              child: Center(
                  child: Text(
                'Add Transaction',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              )),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: model.amountController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: <TextInputFormatter>[
                  // allow only numbers and dot/comma and comma is replaced with dot
                  FilteringTextInputFormatter.allow(
                      RegExp(r'(^-?\d*[.,]?\d*)')),
                  TextInputFormatter.withFunction(
                    (oldValue, newValue) => newValue.copyWith(
                      text: newValue.text.replaceAll(',', '.'),
                    ),
                  ),
                ],
                decoration: const InputDecoration(
                    labelText: 'Amount',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16))),
                    suffixIcon: Icon(Icons.paid_outlined)),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: model.noteController,
                minLines: 3,
                maxLines: 5,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16))),
                    suffixIcon: Icon(Icons.text_snippet_outlined)),
              ),
            ),
            const SizedBox(height: 12),
            SegmentedButton<TransactionType>(
              showSelectedIcon: false,
              segments: const <ButtonSegment<TransactionType>>[
                ButtonSegment(
                    value: TransactionType.income,
                    label: Text('Income'),
                    icon: Icon(
                      Icons.arrow_drop_up,
                      color: Colors.green,
                      size: 24,
                    )),
                ButtonSegment(
                    value: TransactionType.outcome,
                    label: Text('Outcome'),
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.red,
                      size: 24,
                    )),
              ],
              selected: <TransactionType>{model.selectedType},
              onSelectionChanged: (Set<TransactionType> newValue) {
                model.changeTransactionType(newValue.first);
              },
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DropdownMenu(
                    width: (screenWidth - 32 - 16) / 3 * 2,
                    leadingIcon: Icon(
                      model.selectedCategory.icon,
                      color: model.selectedCategory.color,
                    ),
                    textStyle: TextStyle(color: model.selectedCategory.color),
                    label: const Text('Category'),
                    inputDecorationTheme: const InputDecorationTheme(
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(16)))),
                    onSelected: (Object? newValue) {
                      model.changeCurrentCategory(newValue as String);
                    },
                    initialSelection: model.categories.isEmpty
                        ? 'General'
                        : model.categories.first.name,
                    menuStyle: MenuStyle(
                        shape: WidgetStateProperty.all(
                            const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16))))),
                    dropdownMenuEntries:
                        model.categories.map<DropdownMenuEntry<String>>(
                      (TransactionCategory c) {
                        return DropdownMenuEntry<String>(
                            value: c.id,
                            label: c.name,
                            style: ButtonStyle(
                                foregroundColor:
                                    WidgetStateProperty.all(c.color)),
                            trailingIcon: Icon(
                              c.icon,
                              color: c.color,
                            ));
                      },
                    ).toList()),
                DropdownMenu(
                    width: (screenWidth - 32 - 16) / 3,
                    label: const Text('Currency'),
                    inputDecorationTheme: const InputDecorationTheme(
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(16)))),
                    onSelected: (Object? newValue) {
                      model.changeCurrentCurrency(newValue as String);
                    },
                    initialSelection: model.currencies.isEmpty
                        ? 'CZK'
                        : model.currencies.first.symbol,
                    dropdownMenuEntries: model.currencies
                        .map<DropdownMenuEntry<String>>((Currency cur) {
                      return DropdownMenuEntry<String>(
                          value: cur.id,
                          label: cur.name,
                          trailingIcon: Text(cur.symbol));
                    }).toList()),
              ],
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      controller: model.dateController,
                      readOnly: true,
                      onTap: () async {
                        DateTime? date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100));
                        if (date != null) {
                          model.dateController.text =
                              DateFormat('dd.MM.yyyy').format(date).toString();
                        }
                      },
                      decoration: const InputDecoration(
                          labelText: 'Date',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16))),
                          suffixIcon: Icon(Icons.calendar_month_outlined)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: model.timeController,
                      readOnly: true,
                      onTap: () async {
                        TimeOfDay? time = await showTimePicker(
                            context: context, initialTime: TimeOfDay.now());
                        if (time != null) {
                          model.timeController.text = time.format(context);
                        }
                      },
                      decoration: const InputDecoration(
                          labelText: 'Time',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16))),
                          suffixIcon: Icon(Icons.access_time_outlined)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.error,
                      side: BorderSide(
                          color: Theme.of(context).colorScheme.error)),
                  onPressed: () =>
                      {Navigator.pop(context), model.clearFields()},
                  child: const Text('Discard'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                    onPressed: () {
                      if (model.amountController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                behavior: SnackBarBehavior.floating,
                                content: Text('Amount is required!')));
                        return;
                      }
                      model.saveTransaction();
                      model.clearFields();
                      Navigator.pop(context);
                    },
                    child: const Text('Save Transaction')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
