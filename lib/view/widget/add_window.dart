import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:personal_finance/model/category.dart';
import 'package:personal_finance/model/currency.dart';
import 'package:personal_finance/view_model/add_transaction_viewmodel.dart';
import 'package:provider/provider.dart';

class AddWindow extends StatelessWidget {
  const AddWindow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    var viewModel = context.watch<AddTransactionViewModel>();

    return Dialog(
      insetPadding: EdgeInsets.only(
          top: screenHeight * 0.1,
          bottom: screenHeight * 0.1,
          left: screenWidth * 0.1,
          right: screenWidth * 0.1),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 52,
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
              controller: viewModel.amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: <TextInputFormatter>[
                // allow only numbers and dot/comma and comma is replaced with dot
                FilteringTextInputFormatter.allow(RegExp(r'(^-?\d*[.,]?\d*)')),
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
              controller: viewModel.noteController,
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
            selected: <TransactionType>{viewModel.selectedType},
            onSelectionChanged: (Set<TransactionType> newValue) {
              viewModel.changeTransactionType(newValue.first);
            },
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: DropdownMenu(
                      label: const Text('Category'),
                      leadingIcon: viewModel.selectedCategory.name == 'General'
                          ? null
                          : Icon(Icons.category_outlined),
                      textStyle: TextStyle(color: viewModel.selectedCategory.color),
                      inputDecorationTheme: const InputDecorationTheme(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)))),
                      menuStyle: MenuStyle(
                          shape: WidgetStateProperty.all(
                              const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16))))),
                      expandedInsets: EdgeInsets.zero,
                      initialSelection: viewModel.categories.isEmpty
                          ? 'General'
                          : viewModel.selectedCategory.name,
                      onSelected: (Object? newValue) {
                        viewModel.changeCurrentCategory(newValue as String);
                      },
                      dropdownMenuEntries:
                          viewModel.categories.map<DropdownMenuEntry<String>>(
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
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: DropdownMenu(
                      label: const Text('Currency'),
                      inputDecorationTheme: const InputDecorationTheme(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)))),
                      expandedInsets: EdgeInsets.zero,
                      onSelected: (Object? newValue) {
                        viewModel.changeCurrentCurrency(newValue as String);
                      },
                      initialSelection: viewModel.currencies.isEmpty
                          ? 'CZK'
                          : viewModel.currencies.first.symbol,
                      dropdownMenuEntries: viewModel.currencies
                          .map<DropdownMenuEntry<String>>((Currency cur) {
                        return DropdownMenuEntry<String>(
                            value: cur.id,
                            label: cur.name,
                            trailingIcon: Text(cur.symbol));
                      }).toList()),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    controller: viewModel.dateController,
                    readOnly: true,
                    onTap: () async {
                      DateTime? date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100));
                      if (date != null) {
                        viewModel.dateController.text =
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
                    controller: viewModel.timeController,
                    readOnly: true,
                    onTap: () async {
                      TimeOfDay? time = await showTimePicker(
                          context: context, initialTime: TimeOfDay.now());
                      if (time != null) {
                        viewModel.timeController.text = time.format(context);
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
                    side:
                        BorderSide(color: Theme.of(context).colorScheme.error)),
                onPressed: () => {Navigator.pop(context), viewModel.clearFields()},
                child: const Text('Discard'),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  onPressed: () {
                    if (viewModel.amountController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          behavior: SnackBarBehavior.floating,
                          content: Text('Amount is required!')));
                      return;
                    }
                    viewModel.saveTransaction();
                    viewModel.clearFields();
                    Navigator.pop(context);
                  },
                  child: const Text('Save Transaction')),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
