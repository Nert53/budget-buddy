import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_finance/constants.dart';
import 'package:personal_finance/utils/functions.dart';
import 'package:personal_finance/view/constants/sort_order.dart';
import 'package:personal_finance/view/widgets/dialogs/set_range_dialog.dart';
import 'package:personal_finance/view_model/transactions_viewmodel.dart';
import 'package:provider/provider.dart';

class FilterTransactionsScreen extends StatefulWidget {
  const FilterTransactionsScreen({super.key});

  @override
  State<FilterTransactionsScreen> createState() =>
      _FilterTransactionsScreenState();
}

class _FilterTransactionsScreenState extends State<FilterTransactionsScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool smallScreen = screenWidth < compactScreenWidth;
    bool largeScreen = screenWidth > largeScreenWidth;

    return Consumer<TransactionViewModel>(builder: (context, viewModel, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Filter Transactions'),
          leading: IconButton(
            icon: Icon(Icons.adaptive.arrow_back),
            onPressed: () {
              viewModel.getFilterSettings();
              context.pop();
            },
          ),
          actions: [
            Tooltip(
              message: 'Reset all filters.',
              child: IconButton(
                icon: Icon(Icons.filter_alt_off_outlined),
                onPressed: () {
                  setState(() {
                    viewModel.resetFilters();
                  });
                },
              ),
            ),
          ],
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: smallScreen
            ? FloatingActionButton.extended(
                onPressed: () {
                  viewModel.getAllData();
                  viewModel.filtersApplied = true;
                  context.pop();
                },
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                label: Text('Apply filters'),
              )
            : null,
        body: viewModel.isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator.adaptive(),
                    SizedBox(height: 16),
                    Text('Loading filters...'),
                  ],
                ),
              )
            : Padding(
                padding: largeScreen
                    ? EdgeInsets.symmetric(
                        vertical: 12, horizontal: (screenWidth - 940) / 2)
                    : const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Sort by',
                          style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .fontSize)),
                      SizedBox(width: 8),
                      Wrap(
                        spacing: 4,
                        runSpacing: largeScreen ? 4 : 3,
                        children: [
                          for (var order in SortOrder.values)
                            ChoiceChip(
                              label: Text(
                                order.name.capitalize(),
                              ),
                              selected: viewModel.sortOrder == order,
                              onSelected: (bool selected) {
                                setState(() {
                                  viewModel.sortOrder = order;
                                });
                              },
                            ),
                        ],
                      ),
                      Divider(),
                      Text('Categories',
                          style: TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .fontSize,
                          )),
                      Wrap(
                        spacing: 4,
                        runSpacing: largeScreen ? 4 : 3,
                        children: viewModel.categories
                            .map((category) => FilterChip(
                                  label: Text(
                                    category.name,
                                  ),
                                  avatar: viewModel.categoriesFilter
                                              .containsKey(category.id) &&
                                          viewModel
                                              .categoriesFilter[category.id]!
                                      ? null
                                      : Icon(
                                          convertIconCodePointToIcon(
                                              category.icon),
                                          color: convertColorCodeToColor(
                                              category.color),
                                        ),
                                  selected:
                                      viewModel.categoriesFilter[category.id] ??
                                          false,
                                  onSelected: (bool selected) {
                                    setState(() {
                                      viewModel.categoriesFilter[category.id] =
                                          selected;
                                      viewModel.updateFilterCount(selected, 1);
                                    });
                                  },
                                ))
                            .toList(),
                      ),
                      Divider(),
                      Text('Currencies',
                          style: TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .fontSize,
                          )),
                      Wrap(
                        spacing: 4,
                        runSpacing: largeScreen ? 4 : 3,
                        children: viewModel.currencies
                            .map((currency) => FilterChip(
                                  avatar: viewModel.currenciesFilter
                                              .containsKey(currency.id) &&
                                          viewModel
                                              .currenciesFilter[currency.id]!
                                      ? null
                                      : Text(currency.symbol,
                                          style: TextStyle(fontSize: 9)),
                                  label: Text(currency.name),
                                  selected:
                                      viewModel.currenciesFilter[currency.id] ??
                                          false,
                                  onSelected: (bool selected) {
                                    setState(() {
                                      viewModel.currenciesFilter[currency.id] =
                                          selected;
                                      viewModel.updateFilterCount(selected, 2);
                                    });
                                  },
                                ))
                            .toList(),
                      ),
                      Divider(),
                      Text('Type',
                          style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .fontSize)),
                      Wrap(
                        spacing: 4,
                        runSpacing: largeScreen ? 4 : 2,
                        children: [
                          FilterChip(
                            avatar: viewModel.typesFilter['income']!
                                ? null
                                : Icon(Icons.arrow_drop_up,
                                    color: Colors.green),
                            label: Text(
                              'Income',
                            ),
                            selected: viewModel.typesFilter['income'] ?? false,
                            onSelected: (bool selected) {
                              setState(() {
                                viewModel.typesFilter['income'] = selected;
                                viewModel.updateFilterCount(selected, 3);
                              });
                            },
                          ),
                          FilterChip(
                            avatar: viewModel.typesFilter['outcome']!
                                ? null
                                : Icon(Icons.arrow_drop_down,
                                    color: Colors.red),
                            label: Text(
                              'Outcome',
                            ),
                            selected: viewModel.typesFilter['outcome'] ?? false,
                            onSelected: (bool selected) {
                              setState(() {
                                viewModel.typesFilter['outcome'] = selected;
                                viewModel.updateFilterCount(selected, 3);
                              });
                            },
                          ),
                        ],
                      ),
                      Divider(),
                      Text('Amount range',
                          style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .fontSize)),
                      RangeSlider(
                          values: RangeValues(
                              viewModel.amountLow, viewModel.amountHigh),
                          min: viewModel.amountMin,
                          max: viewModel.amountMax,
                          inactiveColor: Colors.white,
                          onChanged: (value) {
                            setState(() {
                              viewModel.amountLow = value.start.ceilToDouble();
                              viewModel.amountHigh = value.end.ceilToDouble();
                              if (viewModel.amountLow != viewModel.amountMin ||
                                  viewModel.amountHigh != viewModel.amountMax) {
                                viewModel.amountFilterActive = true;
                              } else {
                                viewModel.amountFilterActive = false;
                              }
                            });
                          }),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FilledButton.tonal(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return SetRangeDialog(
                                          viewModel: viewModel,
                                          name: 'Set lower amount',
                                          amount: viewModel.amountLow,
                                          maxAmount: viewModel.amountMax,
                                          isLowRange: true,
                                        );
                                      });
                                },
                                child: Text(
                                  '${amountPretty(viewModel.amountLow, decimalDigits: 0)} CZK',
                                )),
                            FilledButton.tonal(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return SetRangeDialog(
                                          viewModel: viewModel,
                                          name: 'Set upper amount',
                                          amount: viewModel.amountHigh,
                                          maxAmount: viewModel.amountMax,
                                          isLowRange: false,
                                        );
                                      });
                                },
                                child: Text(
                                  '${amountPretty(viewModel.amountHigh, decimalDigits: 0)} CZK',
                                )),
                          ],
                        ),
                      ),
                      Divider(),
                      smallScreen
                          ? SizedBox()
                          : Center(
                              child: FilledButton(
                                  onPressed: () {
                                    viewModel.getAllData();
                                    viewModel.filtersApplied = true;
                                    context.pop();
                                  },
                                  child: Text('Apply filters')),
                            ),
                      // enable FAB button to not overlap with range slider
                      SizedBox(height: 64),
                    ],
                  ),
                ),
              ),
      );
    });
  }
}
