import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_finance/constants.dart';
import 'package:personal_finance/utils/functions.dart';
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
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool largeScreen = screenWidth > largeScreenWidth;

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
                    // todo
                    viewModel.resetFilters();
                  });
                },
              ),
            ),
          ],
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
        ),
        body: viewModel.isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
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
                        runSpacing: 4,
                        children: [
                          ChoiceChip(
                            label: Text(
                              'Oldest',
                            ),
                            selected: viewModel.sortOrder == SortOrder.oldest,
                            onSelected: (bool selected) {
                              setState(() {
                                viewModel.sortOrder = SortOrder.oldest;
                              });
                            },
                          ),
                          ChoiceChip(
                            label: Text(
                              'Newest',
                            ),
                            selected: viewModel.sortOrder == SortOrder.newest,
                            onSelected: (bool selected) {
                              setState(() {
                                viewModel.sortOrder = SortOrder.newest;
                              });
                            },
                          ),
                          ChoiceChip(
                            label: Text(
                              'A - Z',
                            ),
                            selected:
                                viewModel.sortOrder == SortOrder.alphabetical,
                            onSelected: (bool selected) {
                              setState(() {
                                viewModel.sortOrder = SortOrder.alphabetical;
                              });
                            },
                          ),
                          ChoiceChip(
                            label: Text(
                              'Z - A',
                            ),
                            selected: viewModel.sortOrder ==
                                SortOrder.reverseAlphabetical,
                            onSelected: (bool selected) {
                              setState(() {
                                viewModel.sortOrder =
                                    SortOrder.reverseAlphabetical;
                              });
                            },
                          ),
                          ChoiceChip(
                            label: Text(
                              'Lowest',
                            ),
                            selected: viewModel.sortOrder == SortOrder.lowest,
                            onSelected: (bool selected) {
                              setState(() {
                                viewModel.sortOrder = SortOrder.lowest;
                              });
                            },
                          ),
                          ChoiceChip(
                            label: Text(
                              'Highest',
                            ),
                            selected: viewModel.sortOrder == SortOrder.highest,
                            onSelected: (bool selected) {
                              setState(() {
                                viewModel.sortOrder = SortOrder.highest;
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
                        runSpacing: 4,
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
                        runSpacing: 4,
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
                        runSpacing: 4,
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
                              viewModel.amountLow = value.start;
                              viewModel.amountHigh = value.end;
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
                                onPressed: () {},
                                child: Text(
                                  '${amountPretty(viewModel.amountLow, decimalDigits: 0)} CZK',
                                )),
                            FilledButton.tonal(
                                onPressed: () {},
                                child: Text(
                                  '${amountPretty(viewModel.amountHigh, decimalDigits: 0)} CZK',
                                )),
                          ],
                        ),
                      ),
                      Divider(),
                      Center(
                        child: FilledButton(
                            onPressed: () {
                              viewModel.getAllData();
                              context.pop();
                            },
                            child: Text('Apply filters')),
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
      );
    });
  }
}
