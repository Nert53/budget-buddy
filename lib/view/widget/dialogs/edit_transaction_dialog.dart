import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:personal_finance/constants.dart';
import 'package:personal_finance/repository/database.dart';
import 'package:personal_finance/utils/functions.dart';
import 'package:personal_finance/view_model/add_transaction_viewmodel.dart';
import 'package:personal_finance/view_model/transactions_viewmodel.dart';
import 'package:provider/provider.dart';

class EditTransaction extends StatefulWidget {
  final String transactionId;
  final double amount;
  final String note;
  final DateTime date;
  final bool isOutcome;
  final List<CategoryItem> categories;
  final List<CurrencyItem> currencies;
  final String categoryId;
  final String categoryName;
  final IconData categoryIcon;
  final Color categoryColor;
  final String currencyId;
  final String currencyName;
  final String currencySymbol;

  const EditTransaction({
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
  final TextEditingController categoryNameController = TextEditingController();
  final TextEditingController currencyNameController = TextEditingController();
  late String selectedCategoryId;
  late String selectedCurrencyId;

  late String _transactionId;
  late DateTime _date;
  late bool _isOutcome;
  late String _categoryId;
  late IconData _categoryIcon;
  late Color _categoryColor;
  late String _currencyId;
  late String _currencySymbol;

  late CategoryItem selectedCategory;
  late CurrencyItem selectedCurrency;

  bool categoryModified = false;
  bool currencyModified = false;

  changeIsOutcome(bool newValue) {
    setState(() {
      _isOutcome = newValue;
    });
  }

  changeDate(DateTime newDate) {
    setState(() {
      _date = newDate;
    });
  }

  changeTime(TimeOfDay newTime) {
    setState(() {
      _date = _date.copyWith(hour: newTime.hour, minute: newTime.minute);
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
      _categoryId = newCategory.id;
      _categoryIcon = convertIconCodePointToIcon(newCategory.icon);
      _categoryColor = convertColorCodeToColor(newCategory.color);
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
      _currencyId = newCurrency.id;
      _currencySymbol = newCurrency.symbol;
    });
  }

  @override
  void initState() {
    super.initState();
    amountController.text = widget.amount.toString();
    noteController.text = widget.note;
    categoryNameController.text = widget.categoryName;
    currencyNameController.text = widget.currencyName;

    _transactionId = widget.transactionId;
    _date = widget.date;
    _isOutcome = widget.isOutcome;
    _categoryId = widget.categoryId;
    _categoryIcon = widget.categoryIcon;
    _categoryColor = widget.categoryColor;
    _currencyId = widget.currencyId;
    _currencySymbol = widget.currencySymbol;

    selectedCategoryId = widget.categoryId;
    selectedCurrencyId = widget.currencyId;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionViewModel>(builder: (context, viewModel, child) {
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
                    viewModel.deleteTransactionById(_transactionId);
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
                        controller: amountController,
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
                        controller: noteController,
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
                          _isOutcome == true
                              ? TransactionType.outcome
                              : TransactionType.income,
                        },
                        onSelectionChanged: (Set<TransactionType> newValue) {
                          changeIsOutcome(!_isOutcome);
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
                                    initialDate: _date,
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                  ).then((newDate) {
                                    // without copy method the hour:minute will be set to 00:00
                                    changeDate(newDate!.copyWith(
                                        hour: _date.hour,
                                        minute: _date.minute));
                                  });
                                },
                                child: Text(
                                  DateFormat('dd. MM. yyyy')
                                      .format(_date)
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
                                  DateFormat('HH:mm').format(_date).toString(),
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
                          controller: categoryNameController,
                          label: const Text('Category'),
                          leadingIcon:
                              Icon(_categoryIcon, color: _categoryColor),
                          textStyle: TextStyle(color: _categoryColor),
                          inputDecorationTheme: const InputDecorationTheme(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16)))),
                          menuStyle: MenuStyle(
                              shape: WidgetStateProperty.all(const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16))))),
                          expandedInsets: EdgeInsets.zero,
                          onSelected: (String? newCategoryId) {
                            changeSelectedCategory(newCategoryId!);
                          },
                          dropdownMenuEntries: widget.categories
                              .map((category) => DropdownMenuEntry<String>(
                                  value: category.id,
                                  label: category.name,
                                  style: ButtonStyle(
                                      foregroundColor: WidgetStateProperty.all(
                                          convertColorCodeToColor(
                                              category.color))),
                                  trailingIcon:
                                      Icon(convertIconCodePointToIcon(category.icon), color: convertColorCodeToColor(category.color))))
                              .toList()),
                      SizedBox(
                        height: 16,
                      ),
                      DropdownMenu<String>(
                          controller: currencyNameController,
                          label: const Text('Currency'),
                          leadingIcon: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: Text(_currencySymbol)),
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
                          onSelected: (String? newCurrencyId) {
                            changeSelectedCurrency(newCurrencyId!);
                          },
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
                    _transactionId,
                    double.parse(amountController.text),
                    noteController.text,
                    _isOutcome,
                    _date,
                    _categoryId,
                    _currencyId,
                  );
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ],
      );
    });
  }
}
