import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_finance/constants.dart';
import 'package:personal_finance/view/widget/dialogs/reports_manager_dialog.dart';
import 'package:personal_finance/view/widget/graphs/income_outcome_ratio_graph.dart';
import 'package:personal_finance/view/widget/graphs/interesting_number_card.dart';
import 'package:personal_finance/view/widget/graphs/nothing_to_display.dart';
import 'package:personal_finance/view/widget/flushbars.dart';
import 'package:personal_finance/view/widget/graphs/speding_over_time_graph.dart';
import 'package:personal_finance/view/widget/graphs/high_spending_categories_graph.dart';
import 'package:personal_finance/view_model/reports_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool mediumScreen = MediaQuery.of(context).size.width > mediumScreenWidth;
    bool largeScreen = MediaQuery.of(context).size.width > largeScreenWidth;
    final DateFormat dateRangeFormat = DateFormat('dd. MM. yyyy');

    return Consumer<ReportsViewModel>(builder: (context, viewModel, child) {
      return Skeletonizer(
        enabled: viewModel.isLoading,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 6,
              children: [
                Text(
                  'Date range: ',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                FilledButton.tonal(
                    onPressed: () {
                      showDateRangePicker(
                        context: context,
                        firstDate: DateTime(1970),
                        lastDate: DateTime(2042),
                        switchToInputEntryModeIcon:
                            Icon(Icons.keyboard_alt_outlined),
                        builder: (BuildContext context, Widget? child) {
                          return SafeArea(
                            child: mediumScreen
                                ? Dialog(
                                    child: child,
                                  )
                                : Dialog.fullscreen(
                                    child: child,
                                  ),
                          );
                        },
                      ).then((pickedDateRange) {
                        if (pickedDateRange != null) {
                          viewModel.changeSelectedDateRange(pickedDateRange);
                        } else {
                          if (context.mounted) {
                            FlushbarError.show(
                              context: context,
                              message: 'Date range not selected.',
                            );
                          }
                        }
                      });
                    },
                    child: Text(
                      '${dateRangeFormat.format(viewModel.selectedDateRange.start)} - ${dateRangeFormat.format(viewModel.selectedDateRange.end)}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
              ],
            ),
            Divider(),
            Expanded(
                child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 0),
              children: [
                viewModel.allGraphs[0].selected
                    ? Card(
                        elevation: 2,
                        margin:
                            EdgeInsets.symmetric(vertical: 6.0, horizontal: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: SizedBox(
                            height: largeScreen ? 480 : 340,
                            child: viewModel
                                    .highestSpendingCategoriesData.isEmpty
                                ? Column(
                                    children: [
                                      SizedBox(height: 16.0),
                                      Text(
                                        'Highest speding categories',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                      ),
                                      NothingToDisplay(),
                                    ],
                                  )
                                : HighSpendingCategoriesGraph(
                                    data:
                                        viewModel.highestSpendingCategoriesData,
                                    mediumScreen: mediumScreen)),
                      )
                    : SizedBox(),
                viewModel.allGraphs[1].selected
                    ? Card(
                        elevation: 2,
                        margin:
                            EdgeInsets.symmetric(vertical: 6.0, horizontal: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: SizedBox(
                            height: largeScreen ? 500 : 400,
                            child: viewModel.outcomeCategories.isEmpty
                                ? Column(
                                    children: [
                                      SizedBox(height: 16.0),
                                      Text(
                                        'Spending over time',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                      ),
                                      NothingToDisplay(),
                                    ],
                                  )
                                : SpendingOverTimeGraph(
                                    data: viewModel.spendingOverTimeData,
                                    mediumScreen: mediumScreen)),
                      )
                    : SizedBox(),
                viewModel.allGraphs[2].selected
                    ? mediumScreen
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: InterestingNumberCardHorizontal(
                                    valueName: 'Saved from income',
                                    largeScreen: mediumScreen,
                                    noData: viewModel.savedFromIncome.isNaN ||
                                        viewModel.savedFromIncome.isInfinite,
                                    numberValue: viewModel.savedFromIncome,
                                    numberSymbol: '%',
                                    coloredStyle: (viewModel.savedFromIncome >=
                                            20)
                                        ? 1
                                        : (viewModel.savedFromIncome >= 10)
                                            ? 2
                                            : (viewModel.savedFromIncome <= 10)
                                                ? 3
                                                : 0,
                                  ),
                                ),
                                SizedBox(
                                  width: 12.0,
                                ),
                                Expanded(
                                  child: InterestingNumberCardHorizontal(
                                      valueName: 'Average daily spent',
                                      largeScreen: mediumScreen,
                                      noData: viewModel.averageDailySpent.isNaN,
                                      numberValue: viewModel.averageDailySpent,
                                      numberSymbol: 'CZK'),
                                ),
                                SizedBox(
                                  width: 12.0,
                                ),
                                Expanded(
                                  child: InterestingNumberCardHorizontal(
                                      valueName:
                                          'Transactions in foreign currencies',
                                      largeScreen: mediumScreen,
                                      noData: viewModel
                                              .incomeCategories.isEmpty &&
                                          viewModel.outcomeCategories.isEmpty,
                                      numberValue: viewModel
                                          .transactionsForeignCurrenciesPercent,
                                      numberSymbol: '%'),
                                ),
                              ],
                            ),
                          )
                        : Column(
                            children: [
                              SizedBox(
                                height: 160,
                                child: InterestingNumberCardVertical(
                                  valueName: 'Saved from income',
                                  largeScreen: mediumScreen,
                                  noData: viewModel.savedFromIncome.isNaN ||
                                      viewModel.savedFromIncome.isInfinite,
                                  numberValue: viewModel.savedFromIncome,
                                  numberSymbol: '%',
                                  coloredStyle: (viewModel.savedFromIncome >=
                                          20)
                                      ? 1
                                      : (viewModel.savedFromIncome >= 10)
                                          ? 2
                                          : (viewModel.savedFromIncome <= 10)
                                              ? 3
                                              : 0,
                                ),
                              ),
                              SizedBox(
                                height: 160,
                                child: InterestingNumberCardVertical(
                                    valueName: 'Average daily spent',
                                    largeScreen: mediumScreen,
                                    noData: viewModel.averageDailySpent.isNaN,
                                    numberValue: viewModel.averageDailySpent,
                                    numberSymbol: 'CZK'),
                              ),
                              SizedBox(
                                height: 160,
                                child: InterestingNumberCardVertical(
                                    valueName:
                                        'Transactions in foreign currencies',
                                    largeScreen: mediumScreen,
                                    noData:
                                        viewModel.incomeCategories.isEmpty &&
                                            viewModel.outcomeCategories.isEmpty,
                                    numberValue: viewModel
                                        .transactionsForeignCurrenciesPercent,
                                    numberSymbol: '%'),
                              )
                            ],
                          )
                    : SizedBox(),
                viewModel.allGraphs[3].selected
                    ? Column(
                        children: [
                          IncomeOutcomeRatioGraph(
                              mediumScreen: mediumScreen,
                              largeScreen: largeScreen,
                              incomeCategories: viewModel.incomeCategories,
                              outcomeCategories: viewModel.outcomeCategories)
                        ],
                      )
                    : SizedBox(),
                viewModel.allGraphs[4].selected
                    ? mediumScreen
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: InterestingNumberCardHorizontal(
                                      valueName: 'Sum of all incomes',
                                      largeScreen: mediumScreen,
                                      noData: viewModel.totalIncome.isNaN,
                                      numberValue: viewModel.totalIncome,
                                      numberSymbol: 'CZK'),
                                ),
                                SizedBox(
                                  width: 16.0,
                                ),
                                Expanded(
                                  child: InterestingNumberCardHorizontal(
                                      valueName: 'Sum of all outcomes',
                                      largeScreen: mediumScreen,
                                      noData: viewModel.totalOutcome.isNaN,
                                      numberValue: viewModel.totalOutcome,
                                      numberSymbol: 'CZK'),
                                ),
                                SizedBox(
                                  width: 16.0,
                                ),
                                Expanded(
                                  child: InterestingNumberCardHorizontal(
                                    valueName: 'Overall balance',
                                    largeScreen: mediumScreen,
                                    noData: viewModel.accountBalance.isNaN,
                                    numberValue: viewModel.accountBalance,
                                    numberSymbol: 'CZK',
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Column(
                            children: [
                              SizedBox(
                                height: 160,
                                child: InterestingNumberCardVertical(
                                    valueName: 'Sum of all incomes',
                                    largeScreen: mediumScreen,
                                    noData: viewModel.totalIncome.isNaN,
                                    numberValue: viewModel.totalIncome,
                                    numberSymbol: 'CZK'),
                              ),
                              SizedBox(
                                height: 160,
                                child: InterestingNumberCardVertical(
                                    valueName: 'Sum of all outcomes',
                                    largeScreen: mediumScreen,
                                    noData: viewModel.totalOutcome.isNaN,
                                    numberValue: viewModel.totalOutcome,
                                    numberSymbol: 'CZK'),
                              ),
                              SizedBox(
                                height: 160,
                                child: InterestingNumberCardVertical(
                                    valueName: 'Overall balance',
                                    largeScreen: mediumScreen,
                                    numberValue: viewModel.accountBalance,
                                    noData: viewModel.accountBalance.isNaN,
                                    numberSymbol: 'CZK'),
                              )
                            ],
                          )
                    : SizedBox(),
                Column(
                  children: [
                    SizedBox(height: 8.0),
                    FilledButton.icon(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return ReportManagerDialog(viewModel: viewModel);
                            });
                      },
                      label: Text('Manage reports'),
                      icon: Icon(
                        Icons.edit,
                      ),
                    ),
                    SizedBox(height: 12.0),
                  ],
                ),
              ],
            )),
          ],
        ),
      );
    });
  }
}
