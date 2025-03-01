import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:personal_finance/constants.dart';
import 'package:personal_finance/data/database.dart';
import 'package:personal_finance/utils/functions.dart';
import 'package:personal_finance/view_model/add_transaction_viewmodel.dart';
import 'package:personal_finance/view_model/transactions_viewmodel.dart';
import 'package:provider/provider.dart';

class EditTransaction extends StatefulWidget {
  final String transactionId;
  final double amount;
  final String note;
  DateTime date;
  bool isOutcome;
  final List<CategoryItem> categories;
  final List<CurrencyItem> currencies;
  String categoryId;
  String categoryName;
  IconData categoryIcon;
  Color categoryColor;
  String currencyId;
  String currencyName;
  String currencySymbol;

  EditTransaction({
    super.key,
    required this.transactionId,
    required this.amount,
    required this.note,
    required this.date,
    required this.isOutcome,
    required this.categories,
    required this.currencies,
    required this.categoryId,
    required this.categoryName,
    required this.categoryIcon,
    required this.categoryColor,
    required this.currencyId,
    required this.currencyName,
    required this.currencySymbol,
  });

  @override
  State<EditTransaction> createState() => _EditTransactionState();
}

class _EditTransactionState extends State<EditTransaction> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController currencyController = TextEditingController();
  late String selectedCategoryId;
  late String selectedCurrencyId;
  bool categoryModified = false;
  bool currencyModified = false;

  changeIsOutcome(bool newValue) {
    setState(() {
      widget.isOutcome = newValue;
    });
  }

  changeDate(DateTime newDate) {
    setState(() {
      widget.date = newDate;
    });
  }

  changeTime(TimeOfDay newTime) {
    setState(() {
      widget.date =
          widget.date.copyWith(hour: newTime.hour, minute: newTime.minute);
    });
  }

  changeSelectedCategory(String newCategoryId) {
    CategoryItem newCategory = widget.categories.first;
    for (var category in widget.categories) {
      if (category.id == newCategoryId) {
        newCategory = category;
        break;
      }
    }

    setState(() {
      selectedCategoryId = newCategory.id;
      categoryModified = true;
      widget.categoryId = newCategory.id;
      widget.categoryName = newCategory.name;
      widget.categoryIcon = convertIconCodePointToIcon(newCategory.icon);
      widget.categoryColor = convertColorCodeToColor(newCategory.color);
    });
  }

  changeSelectedCurrency(String newCurrencyId) {
    CurrencyItem newCurrency = widget.currencies.first;
    for (var currency in widget.currencies) {
      if (currency.id == newCurrencyId) {
        newCurrency = currency;
        break;
      }
    }

    setState(() {
      selectedCurrencyId = newCurrency.id;
      currencyModified = true;
      widget.currencyId = newCurrency.id;
      widget.currencyName = newCurrency.name;
      widget.currencySymbol = newCurrency.symbol;
    });
  }

  @override
  void initState() {
    super.initState();
    selectedCategoryId = widget.categoryId;
    selectedCurrencyId = widget.currencyId;
    categoryController.text = widget.categoryName;
    currencyController.text = widget.currencyName;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionViewModel>(builder: (context, viewModel, child) {
      return SingleChildScrollView(
        child: Column(
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
                      viewModel.deleteTransactionById(widget.transactionId);
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.delete_outlined),
                    iconSize: 30,
                    style: ButtonStyle(
                        iconColor: WidgetStateProperty.all(Colors.red)),
                  ),
                ],
              ),
              content: viewModel.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      children: [
                        TextField(
                          controller: amountController
                            ..text = widget.amount.toString(),
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: <TextInputFormatter>[
                            // allow only numbers and dot/comma and comma is replaced with dot
                            FilteringTextInputFormatter.allow(
                                RegExp(r'(^\d*[.,]?\d*)')),
                            TextInputFormatter.withFunction(
                              (oldValue, newValue) => newValue.copyWith(
                                text: newValue.text.replaceAll(',', '.'),
                              ),
                            ),
                          ],
                          decoration: InputDecoration(
                            labelText: 'Amount',
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16))),
                            suffixIcon: Icon(Icons.payments_outlined),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        TextField(
                          controller: noteController..text = widget.note,
                          keyboardType: TextInputType.text,
                          minLines: 2,
                          maxLines: 5,
                          maxLength: maxNoteLength,
                          decoration: InputDecoration(
                            labelText: 'Note',
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16))),
                            suffixIcon: Icon(Icons.text_snippet_outlined),
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
                            widget.isOutcome == true
                                ? TransactionType.outcome
                                : TransactionType.income,
                          },
                          onSelectionChanged: (Set<TransactionType> newValue) {
                            changeIsOutcome(!widget.isOutcome);
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
                                      initialDate: widget.date,
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2100),
                                    ).then((newDate) {
                                      // without copy method the hour:minute will be set to 00:00
                                      changeDate(newDate!.copyWith(
                                          hour: widget.date.hour,
                                          minute: widget.date.minute));
                                    });
                                  },
                                  child: Text(
                                    DateFormat('dd. MM. yyyy')
                                        .format(widget.date)
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
                                      initialTime: TimeOfDay.now(),
                                    ).then((newTime) {
                                      changeTime(newTime!);
                                    });
                                  },
                                  child: Text(
                                    DateFormat('HH:mm')
                                        .format(widget.date)
                                        .toString(),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        DropdownMenu<String>(
                            controller: categoryController,
                            label: categoryController.text.isEmpty || categoryModified
                                ? const Text('Category')
                                : Text(categoryController.text,
                                    style:
                                        TextStyle(color: widget.categoryColor)),
                            leadingIcon: Icon(widget.categoryIcon,
                                color: widget.categoryColor),
                            textStyle: TextStyle(color: widget.categoryColor),
                            inputDecorationTheme: const InputDecorationTheme(
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16)))),
                            menuStyle: MenuStyle(
                                shape: WidgetStateProperty.all(
                                    const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(16))))),
                            expandedInsets: EdgeInsets.zero,
                            onSelected: (String? newCategoryId) {
                              changeSelectedCategory(newCategoryId!);
                            },
                            dropdownMenuEntries: widget.categories
                                .map((category) => DropdownMenuEntry<String>(
                                    value: category.id,
                                    label: category.name,
                                    style: ButtonStyle(
                                        foregroundColor: WidgetStateProperty.all(convertColorCodeToColor(category.color))),
                                    trailingIcon: Icon(convertIconCodePointToIcon(category.icon), color: convertColorCodeToColor(category.color))))
                                .toList()),
                        SizedBox(
                          height: 16,
                        ),
                        DropdownMenu<String>(
                            controller: currencyController,
                            label: currencyController.text.isEmpty ||
                                    currencyModified
                                ? const Text('Currency')
                                : Text(
                                    currencyController.text,
                                  ),
                            leadingIcon: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                child: Text(widget.currencySymbol)),
                            inputDecorationTheme: const InputDecorationTheme(
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16)))),
                            expandedInsets: EdgeInsets.zero,
                            onSelected: (String? newCurrencyId) {
                              changeSelectedCurrency(newCurrencyId!);
                            },
                            initialSelection: widget.categories.first.name,
                            dropdownMenuEntries: widget.currencies
                                .map((currency) => DropdownMenuEntry<String>(
                                      value: currency.id,
                                      label: currency.name,
                                      leadingIcon: CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          child: Text(currency.symbol)),
                                    ))
                                .toList()),
                      ],
                    ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Discard'),
                ),
                FilledButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    viewModel.updateTransaction(
                      widget.transactionId,
                      double.parse(amountController.text),
                      noteController.text,
                      widget.isOutcome,
                      widget.date,
                      widget.categoryId,
                      widget.currencyId,
                    );
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
