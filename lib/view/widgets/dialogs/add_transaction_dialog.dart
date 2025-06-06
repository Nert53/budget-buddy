import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:personal_finance/constants.dart';
import 'package:personal_finance/model/category_simple.dart';
import 'package:personal_finance/model/currency.dart';
import 'package:personal_finance/view/widgets/flushbars.dart';
import 'package:personal_finance/view_model/add_transaction_viewmodel.dart';
import 'package:provider/provider.dart';

class AddWindowFullScreen extends StatelessWidget {
  const AddWindowFullScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    const double horizontalPadding = 24;

    return Consumer<AddTransactionViewModel>(
      builder: (context, viewModel, child) => Dialog.fullscreen(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 56,
                width: screenWidth,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Center(
                  child: ListTile(
                    leading: IconButton(
                      icon: Icon(Icons.close),
                      color: Theme.of(context).colorScheme.onPrimary,
                      onPressed: () {
                        Navigator.pop(context);
                        viewModel.clearFields();
                      },
                    ),
                    title: Text(
                      'Add Transaction',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: TextField(
                        controller: viewModel.amountController,
                        onTapOutside: (_) {
                          FocusScope.of(context)
                              .unfocus(); // hide number keyboard by tapping outside it
                        },
                        keyboardType:
                            const TextInputType.numberWithOptions(decimal: true),
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
                        decoration: const InputDecoration(
                            labelText: 'Amount',
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16))),
                            suffixIcon: Icon(Icons.payments_outlined)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: TextField(
                  controller: viewModel.noteController,
                  minLines: 3,
                  maxLines: 5,
                  keyboardType: TextInputType.text,
                  maxLength: maxNoteLength,
                  decoration: const InputDecoration(
                      labelText: 'Note',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                      suffixIcon: Icon(Icons.text_snippet_outlined)),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // row because of expanding segmented button to the width
                children: [
                  SizedBox(
                    width: 24,
                  ),
                  Expanded(
                    child: SegmentedButton<TransactionType>(
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
                  ),
                  SizedBox(
                    width: 24,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: DropdownMenu(
                    label: const Text('Category'),
                    leadingIcon: viewModel.selectedCategory == null
                        ? Icon(Icons.category_outlined)
                        : Icon(
                            viewModel.selectedCategory!.icon,
                            color: viewModel.selectedCategory!.color,
                          ),
                    textStyle: TextStyle(
                        color: viewModel.selectedCategory == null
                            ? Theme.of(context).colorScheme.onSurface
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
                    onSelected: (Object? newValue) {
                      viewModel.changeCurrentCategory(newValue as String);
                    },
                    dropdownMenuEntries:
                        viewModel.categories.map<DropdownMenuEntry<String>>(
                      (CategorySimple cat) {
                        return DropdownMenuEntry<String>(
                            value: cat.id,
                            label: cat.name,
                            style: ButtonStyle(
                                foregroundColor:
                                    WidgetStateProperty.all(cat.color)),
                            trailingIcon: Icon(
                              cat.icon,
                              color: cat.color,
                            ));
                      },
                    ).toList()),
              ),
              const SizedBox(height: 20),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: DropdownMenu(
                    label: const Text('Currency'),
                    leadingIcon: viewModel.selectedCurrency == null
                        ? Icon(Icons.currency_exchange_outlined)
                        : CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: Text(
                              viewModel.selectedCurrency!.symbol,
                            ),
                          ),
                    inputDecorationTheme: const InputDecorationTheme(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)))),
                    menuStyle: MenuStyle(
                        shape: WidgetStateProperty.all(
                            const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16))))),
                    expandedInsets: EdgeInsets.zero,
                    onSelected: (Object? newValue) {
                      viewModel.changeCurrentCurrency(newValue as String);
                    },
                    dropdownMenuEntries: viewModel.currencies
                        .map<DropdownMenuEntry<String>>((Currency cur) {
                      return DropdownMenuEntry<String>(
                        value: cur.id,
                        label: cur.name,
                        leadingIcon: Text(cur.symbol),
                      );
                    }).toList()),
              ),
              const SizedBox(height: 20),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: TextField(
                  controller: viewModel.dateController,
                  readOnly: true,
                  onTap: () async {
                    DateTime? date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (date != null) {
                      viewModel.dateController.text =
                          DateFormat('dd.MM.yyyy').format(date).toString();
                    }
                  },
                  decoration: const InputDecoration(
                      labelText: 'Date',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                      suffixIcon: Icon(Icons.calendar_month_outlined)),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: TextField(
                  controller: viewModel.timeController,
                  readOnly: true,
                  onTap: () async {
                    TimeOfDay? time = await showTimePicker(
                        context: context, initialTime: TimeOfDay.now());
                    if (time != null && context.mounted) {
                      viewModel.timeController.text = time.format(context);
                    }
                  },
                  decoration: const InputDecoration(
                      labelText: 'Time',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                      suffixIcon: Icon(Icons.access_time_outlined)),
                ),
              ),
              const SizedBox(height: 20),
              FilledButton(
                  onPressed: () {
                    if (viewModel.amountController.text.isEmpty ||
                        viewModel.selectedCategory == null ||
                        viewModel.selectedCurrency == null) {
                      FlushbarWarning.show(
                        context: context,
                        message:
                            "Amount, category and currency can't be empty. Please enter a valid values.",
                      );
      
                      return;
                    }
      
                    Navigator.pop(context);
                    viewModel.saveTransaction();
                    viewModel.clearFields();
                  },
                  child: Text('Save Transaction')),
            ],
          ),
        ),
      ),
    );
  }
}

class AddWindow extends StatelessWidget {
  const AddWindow({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Consumer<AddTransactionViewModel>(
        builder: (context, viewModel, child) => Dialog(
              child: SizedBox(
                width: screenWidth > largeScreenWidth ? 860 : 740,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 56,
                      width: screenWidth,
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(28.0),
                          topRight: Radius.circular(28.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Add Transaction',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: TextField(
                              controller: viewModel.amountController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              inputFormatters: <TextInputFormatter>[
                                // allow only decimal numbers (comma is automatically replaced with dot)
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'(^\d*[.,]?\d*)')),
                                TextInputFormatter.withFunction(
                                  (oldValue, newValue) => newValue.copyWith(
                                    text: newValue.text.replaceAll(',', '.'),
                                  ),
                                ),
                              ],
                              decoration: const InputDecoration(
                                  labelText: 'Amount',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(16))),
                                  suffixIcon: Icon(Icons.payments_outlined)),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            flex: 3,
                            child: SegmentedButton<TransactionType>(
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
                              selected: <TransactionType>{
                                viewModel.selectedType
                              },
                              onSelectionChanged:
                                  (Set<TransactionType> newValue) {
                                viewModel.changeTransactionType(newValue.first);
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        controller: viewModel.noteController,
                        minLines: 3,
                        maxLines: 5,
                        maxLength: maxNoteLength,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            labelText: 'Note',
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16))),
                            suffixIcon: Icon(Icons.text_snippet_outlined)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 2,
                            child: DropdownMenu(
                                label: const Text('Category'),
                                leadingIcon: viewModel.selectedCategory == null
                                    ? Icon(Icons.category_outlined)
                                    : Icon(
                                        viewModel.selectedCategory!.icon,
                                        color:
                                            viewModel.selectedCategory!.color,
                                      ),
                                textStyle: TextStyle(
                                    color: viewModel.selectedCategory == null
                                        ? Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                        : viewModel.selectedCategory!.color),
                                inputDecorationTheme:
                                    const InputDecorationTheme(
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(16)))),
                                menuStyle: MenuStyle(
                                    shape: WidgetStateProperty.all(
                                        const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(16))))),
                                expandedInsets: EdgeInsets.zero,
                                onSelected: (Object? newValue) {
                                  viewModel.changeCurrentCategory(
                                      newValue as String);
                                },
                                dropdownMenuEntries: viewModel.categories
                                    .map<DropdownMenuEntry<String>>(
                                  (CategorySimple cat) {
                                    return DropdownMenuEntry<String>(
                                        value: cat.id,
                                        label: cat.name,
                                        style: ButtonStyle(
                                            foregroundColor:
                                                WidgetStateProperty.all(
                                                    cat.color)),
                                        trailingIcon: Icon(
                                          cat.icon,
                                          color: cat.color,
                                        ));
                                  },
                                ).toList()),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            flex: 1,
                            child: DropdownMenu(
                                label: const Text('Currency'),
                                leadingIcon: viewModel.selectedCurrency == null
                                    ? Icon(Icons.currency_exchange_outlined)
                                    : CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        child: Text(
                                          viewModel.selectedCurrency!.symbol,
                                        ),
                                      ),
                                inputDecorationTheme:
                                    const InputDecorationTheme(
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(16)))),
                                expandedInsets: EdgeInsets.zero,
                                onSelected: (Object? newValue) {
                                  viewModel.changeCurrentCurrency(
                                      newValue as String);
                                },
                                menuStyle: MenuStyle(
                                    shape: WidgetStateProperty.all(
                                        const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(16))))),
                                dropdownMenuEntries: viewModel.currencies
                                    .map<DropdownMenuEntry<String>>(
                                        (Currency cur) {
                                  return DropdownMenuEntry<String>(
                                      value: cur.id,
                                      label: cur.name,
                                      leadingIcon: Text(cur.symbol));
                                }).toList()),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
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
                                  lastDate: DateTime(2100),
                                );
                                if (date != null) {
                                  viewModel.dateController.text =
                                      DateFormat('dd.MM.yyyy')
                                          .format(date)
                                          .toString();
                                }
                              },
                              decoration: const InputDecoration(
                                  labelText: 'Date',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(16))),
                                  suffixIcon:
                                      Icon(Icons.calendar_month_outlined)),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: TextField(
                              controller: viewModel.timeController,
                              readOnly: true,
                              onTap: () async {
                                TimeOfDay? time = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now());
                                if (time != null && context.mounted) {
                                  viewModel.timeController.text =
                                      time.format(context);
                                }
                              },
                              decoration: const InputDecoration(
                                  labelText: 'Time',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(16))),
                                  suffixIcon: Icon(Icons.access_time_outlined)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor:
                                Theme.of(context).colorScheme.error,
                          ),
                          onPressed: () =>
                              {Navigator.pop(context), viewModel.clearFields()},
                          child: const Text('Discard'),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              foregroundColor:
                                  Theme.of(context).colorScheme.onPrimary,
                            ),
                            onPressed: () {
                              if (viewModel.amountController.text.isEmpty ||
                                  viewModel.selectedCategory == null ||
                                  viewModel.selectedCurrency == null) {
                                FlushbarWarning.show(
                                  context: context,
                                  message:
                                      "Amount, category and currency can't be empty. Please enter a valid values.",
                                );

                                return;
                              }

                              Navigator.pop(context);
                              viewModel.saveTransaction();
                              viewModel.clearFields();
                            },
                            child: const Text('Save Transaction')),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ));
  }
}
