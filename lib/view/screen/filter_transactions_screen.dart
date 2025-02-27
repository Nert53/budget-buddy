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
  double _lowAmount = 0;
  double _highAmount = 2500;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool largeScreen = screenWidth > largeScreenWidth;

    return Consumer<TransactionViewModel>(builder: (context, viewModel, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Filter Transactions'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              viewModel.getFilterSettings();
              context.pop();
            },
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            viewModel.getAllData();
            context.pop();
          },
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          label: Text('Apply'),
          icon: Icon(Icons.check),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: BottomAppBar(
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  // todo
                },
                icon: Tooltip(
                    message: 'Reset all filters.',
                    child: Icon(Icons.filter_alt_off_outlined)),
              ),
            ],
          ),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Categories',
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.titleLarge!.fontSize,
                        )),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: viewModel.categories
                          .map((category) => FilterChip(
                                label: Text(
                                  category.name,
                                ),
                                avatar: viewModel.categoriesFilter[category.id]!
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
                                    viewModel.updateFilterCount(selected);
                                  });
                                },
                              ))
                          .toList(),
                    ),
                    Divider(),
                    Text('Currencies',
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.titleLarge!.fontSize,
                        )),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: viewModel.currencies
                          .map((currency) => FilterChip(
                                avatar: viewModel.currenciesFilter[currency.id]!
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
                                    viewModel.updateFilterCount(selected);
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
                      children: [
                        FilterChip(
                          avatar: viewModel.typesFilter['income']!
                              ? null
                              : Icon(Icons.arrow_drop_up, color: Colors.green),
                          label: Text(
                            'Income',
                          ),
                          selected: viewModel.typesFilter['income'] ?? false,
                          onSelected: (bool selected) {
                            setState(() {
                              viewModel.typesFilter['income'] = selected;
                              viewModel.updateFilterCount(selected);
                            });
                          },
                        ),
                        FilterChip(
                          avatar: viewModel.typesFilter['outcome']!
                              ? null
                              : Icon(Icons.arrow_drop_down, color: Colors.red),
                          label: Text(
                            'Outcome',
                          ),
                          selected: viewModel.typesFilter['outcome'] ?? false,
                          onSelected: (bool selected) {
                            setState(() {
                              viewModel.typesFilter['outcome'] = selected;
                              viewModel.updateFilterCount(selected);
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
                        values: RangeValues(_lowAmount, _highAmount),
                        labels: RangeLabels('400', '1500'),
                        min: 0,
                        max: 2500,
                        inactiveColor: Colors.white,
                        onChanged: (value) {
                          setState(() {
                            _lowAmount = value.start;
                            _highAmount = value.end;
                          });
                        }),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DecoratedBox(
                              decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer,
                                  borderRadius: BorderRadius.circular(12),
                                  shape: BoxShape.rectangle),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                child:
                                    Text('${_lowAmount.toStringAsFixed(1)} CZK',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSecondaryContainer,
                                        )),
                              )),
                          DecoratedBox(
                              decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer,
                                  borderRadius: BorderRadius.circular(12),
                                  shape: BoxShape.rectangle),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                child: Text(
                                    '${_highAmount.toStringAsFixed(1)} CZK',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondaryContainer,
                                    )),
                              )),
                        ],
                      ),
                    ),
                    Divider(),
                    Text(
                      '*Filters need to be applied to see the changes.',
                      style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.labelSmall!.fontSize,
                          color: Theme.of(context).colorScheme.tertiary),
                    ),
                  ],
                ),
              ),
      );
    });
  }
}
