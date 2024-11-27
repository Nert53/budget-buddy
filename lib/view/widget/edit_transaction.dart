import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_finance/model/category.dart';
import 'package:personal_finance/model/currency.dart';
import 'package:personal_finance/view_model/edit_transaction_viewmodel.dart';
import 'package:provider/provider.dart';

class EditTransaction extends StatelessWidget {
  final String transactionId;
  final double amount;
  final String note;
  final DateTime date;
  final bool isOutcome;
  final String categoryId;
  final String currencyId;

  const EditTransaction({
    super.key,
    required this.transactionId,
    required this.amount,
    required this.note,
    required this.date,
    required this.isOutcome,
    required this.categoryId,
    required this.currencyId,
  });

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<EditTransactionViewmodel>();

    viewModel.amountController.text = amount.toString();
    viewModel.noteController.text = note;
    viewModel.date = date;
    viewModel.time = TimeOfDay.fromDateTime(date);
    viewModel.selectedType =
        isOutcome ? TransactionType.outcome : TransactionType.income;
    viewModel.transactionId = transactionId;
    viewModel.originalCategoryId = categoryId;
    viewModel.originalCurrencyId = currencyId;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Edit Transaction'),
              IconButton(
                onPressed: () {
                  viewModel.deleteTransactionById(transactionId);
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.delete_outlined),
                iconSize: 30,
                style:
                    ButtonStyle(iconColor: WidgetStateProperty.all(Colors.red)),
              ),
            ],
          ),
          content: Column(
            children: [
              TextField(
                controller: viewModel.amountController,
                decoration: InputDecoration(
                  labelText: 'Amount',
                ),
              ),
              TextField(
                controller: viewModel.noteController,
                decoration: InputDecoration(
                  labelText: 'Note',
                ),
              ),
              SizedBox(
                height: 16,
              ),
              SegmentedButton<TransactionType>(
                showSelectedIcon: false,
                segments: const <ButtonSegment<TransactionType>>[
                  ButtonSegment(
                      value: TransactionType.income,
                      label: Text('Income'),
                      icon: Icon(
                        Icons.arrow_drop_up,
                        color: Colors.green,
                        size: 30,
                      )),
                  ButtonSegment(
                      value: TransactionType.outcome,
                      label: Text('Outcome'),
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.red,
                        size: 30,
                      )),
                ],
                selected: <TransactionType>{
                  viewModel.selectedType ?? TransactionType.outcome
                },
                onSelectionChanged: (Set<TransactionType> newValue) {
                  viewModel.changeTransactionType(newValue.first);
                },
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Icon(Icons.calendar_month_outlined),
                      TextButton(
                        onPressed: () {
                          showDatePicker(
                            context: context,
                            initialDate: viewModel.date,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          ).then((newDate) {
                            if (newDate != null) {
                              viewModel.date = newDate;
                            }
                          });
                        },
                        child: Text(
                          DateFormat('dd. MM. yyyy')
                              .format(viewModel.date)
                              .toString(),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.schedule_outlined),
                      TextButton(
                        onPressed: () {
                          showTimePicker(
                            context: context,
                            initialTime: viewModel.time,
                          ).then((newTime) {
                            if (newTime != null) {
                              viewModel.time = newTime;
                              viewModel.date = DateTime(
                                  viewModel.date.year,
                                  viewModel.date.month,
                                  viewModel.date.day,
                                  newTime.hour,
                                  newTime.minute);
                            }
                          });
                        },
                        child: Text(
                          DateFormat('HH:mm').format(viewModel.date).toString(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              DropdownMenu(
                  label: const Text('Category'),
                  leadingIcon: viewModel.selectedCategory == null
                      ? Icon(Icons.category_outlined)
                      : Icon(viewModel.selectedCategory!.icon),
                  textStyle: TextStyle(
                      color: viewModel.selectedCategory == null
                          ? Colors.black
                          : viewModel.selectedCategory!.color),
                  inputDecorationTheme: const InputDecorationTheme(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16)))),
                  menuStyle: MenuStyle(
                      shape: WidgetStateProperty.all(
                          const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16))))),
                  expandedInsets: EdgeInsets.zero,
                  initialSelection: "General",
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
              SizedBox(
                height: 16,
              ),
              DropdownMenu(
                  label: const Text('Currency'),
                  leadingIcon: Icon(Icons.currency_exchange_outlined),
                  inputDecorationTheme: const InputDecorationTheme(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16)))),
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
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Discard changes'),
            ),
            FilledButton(
              onPressed: () {
                viewModel.saveTransaction();
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ],
    );
  }
}
