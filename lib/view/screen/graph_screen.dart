import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_finance/constants.dart';
import 'package:personal_finance/model/category_spent_graph.dart';
import 'package:personal_finance/view/widget/dialogs/select_graph_dialog.dart';
import 'package:personal_finance/view/widget/graph/interesting_number_card.dart';
import 'package:personal_finance/view/widget/nothing_to_display.dart';
import 'package:personal_finance/view_model/graph_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GraphScreen extends StatelessWidget {
  const GraphScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool mediumScreen = MediaQuery.of(context).size.width > mediumScreenWidth;
    bool largeScreen = MediaQuery.of(context).size.width > largeScreenWidth;

    final DateFormat dateRangeFormat = DateFormat('dd. MM. yyyy');

    return Consumer<GraphViewModel>(builder: (context, viewModel, child) {
      if (viewModel.isLoading) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                        helpText: 'Select date range',
                        confirmText: 'Save',
                        switchToInputEntryModeIcon:
                            Icon(Icons.keyboard_alt_outlined),
                        builder: (BuildContext context, Widget? child) {
                          return Dialog(
                            child: child,
                          );
                        },
                      ).then((pickedDateRange) {
                        if (pickedDateRange != null) {
                          viewModel.changeSelectedDateRange(pickedDateRange);
                        } else {
                          if (context.mounted) {
                            Flushbar(
                              message: 'No date range selected',
                              duration: Duration(seconds: 3),
                            ).show(context);
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
              children: [
                viewModel.allGraphs[0].selected
                    ? Card(
                        elevation: 4,
                        margin: EdgeInsets.symmetric(vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: SizedBox(
                            height: 340,
                            child: viewModel.topCategoriesGraphData.isEmpty
                                ? Column(
                                    children: [
                                      SizedBox(height: 16.0),
                                      Text(
                                        'Categories with most spendings',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                      ),
                                      NothingToDisplay(),
                                    ],
                                  )
                                : SfCartesianChart(
                                    title: ChartTitle(
                                        text: 'Categories with most spendings'),
                                    plotAreaBorderWidth: 0,
                                    primaryXAxis: CategoryAxis(),
                                    primaryYAxis: NumericAxis(
                                      minimum: 0,
                                      maximum: viewModel.topCategoriesGraphData
                                              .first.amount *
                                          1.2,
                                      interval: viewModel.topCategoriesGraphData
                                              .first.amount *
                                          0.3,
                                    ),
                                    series: <ColumnSeries>[
                                      ColumnSeries(
                                        dataSource:
                                            viewModel.topCategoriesGraphData,
                                        xValueMapper: (data, _) => data.name,
                                        yValueMapper: (data, _) => data.amount,
                                        pointColorMapper: (data, _) =>
                                            data.color,
                                        dataLabelSettings: DataLabelSettings(
                                          isVisible: true,
                                          labelAlignment:
                                              ChartDataLabelAlignment.top,
                                        ),
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(12),
                                        ),
                                      ),
                                    ],
                                  )),
                      )
                    : SizedBox(),
                viewModel.allGraphs[1].selected
                    ? Card(
                        elevation: 4,
                        margin: EdgeInsets.symmetric(vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: SizedBox(
                            height: 340,
                            child: viewModel.dailySpentInMonthGraphData.isEmpty
                                ? Column(
                                    children: [
                                      SizedBox(height: 16.0),
                                      Text(
                                        'Spent during month',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                      ),
                                      NothingToDisplay(),
                                    ],
                                  )
                                : SfCartesianChart(
                                    plotAreaBorderWidth: 0,
                                    title: ChartTitle(
                                      text: 'Spent during month',
                                    ),
                                    primaryXAxis: NumericAxis(
                                      edgeLabelPlacement:
                                          EdgeLabelPlacement.shift,
                                      minimum: 1,
                                      maximum: 31,
                                      interval: mediumScreen ? 1 : 3,
                                      majorGridLines: MajorGridLines(width: 0),
                                    ),
                                    primaryYAxis: const NumericAxis(
                                      labelFormat: '{value}',
                                      axisLine: AxisLine(width: 0),
                                      majorTickLines: MajorTickLines(
                                          color: Colors.transparent),
                                    ),
                                    series: <LineSeries<MapEntry<int, double>,
                                        int>>[
                                      LineSeries<MapEntry<int, double>, int>(
                                        dataSource: viewModel
                                            .dailySpentInMonthGraphData,
                                        xValueMapper: (data, _) => data.key,
                                        yValueMapper: (data, _) => data.value,
                                        name: 'Spent',
                                        markerSettings: MarkerSettings(
                                          isVisible: true,
                                        ),
                                      ),
                                    ],
                                  )),
                      )
                    : SizedBox(),
                viewModel.allGraphs[2].selected
                    ? mediumScreen
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: InterestingNumberCardHorizontal(
                                    valueName: 'Saved from income',
                                    largeScreen: mediumScreen,
                                    noData: viewModel.savingFromIncome.isNaN,
                                    numberValue: viewModel.savingFromIncome
                                        .toStringAsFixed(0),
                                    numberSymbol: '%'),
                              ),
                              SizedBox(
                                width: 12.0,
                              ),
                              Expanded(
                                child: InterestingNumberCardHorizontal(
                                    valueName: 'Average daily spent',
                                    largeScreen: mediumScreen,
                                    noData:
                                        viewModel.averageDailySpending.isNaN,
                                    numberValue: viewModel.averageDailySpending
                                        .toStringAsFixed(0),
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
                                    numberValue: viewModel
                                        .percentageForeignCurrencyTransactions
                                        .toStringAsFixed(0),
                                    numberSymbol: '%'),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              SizedBox(
                                height: 160,
                                child: Expanded(
                                  child: InterestingNumberCardVertical(
                                      valueName: 'Saved from income',
                                      largeScreen: mediumScreen,
                                      noData: viewModel.savingFromIncome.isNaN,
                                      numberValue: viewModel.savingFromIncome
                                          .toStringAsFixed(0),
                                      numberSymbol: '%'),
                                ),
                              ),
                              SizedBox(
                                height: 160,
                                child: Expanded(
                                  child: InterestingNumberCardVertical(
                                      valueName: 'Average daily spent',
                                      largeScreen: mediumScreen,
                                      noData:
                                          viewModel.averageDailySpending.isNaN,
                                      numberValue: viewModel
                                          .averageDailySpending
                                          .toStringAsFixed(0),
                                      numberSymbol: 'CZK'),
                                ),
                              ),
                              SizedBox(
                                height: 160,
                                child: Expanded(
                                  child: InterestingNumberCardVertical(
                                      valueName:
                                          'Transactions in foreign currencies',
                                      largeScreen: mediumScreen,
                                      numberValue: viewModel
                                          .percentageForeignCurrencyTransactions
                                          .toStringAsFixed(0),
                                      numberSymbol: '%'),
                                ),
                              )
                            ],
                          )
                    : SizedBox(),
                Expanded(
                  child: viewModel.allGraphs[3].selected
                      ? GridView(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: mediumScreen ? 2 : 1,
                            childAspectRatio: 1.3,
                            crossAxisSpacing: mediumScreen ? 16.0 : 0,
                            mainAxisSpacing: mediumScreen ? 10.0 : 0,
                          ),
                          shrinkWrap: true,
                          physics:
                              NeverScrollableScrollPhysics(), // to disable GridView's scrolling
                          children: [
                            Card(
                              elevation: 4,
                              margin: EdgeInsets.symmetric(vertical: 12.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: viewModel.incomeCategories.isEmpty
                                  ? Column(
                                      children: [
                                        SizedBox(height: 16.0),
                                        Text(
                                          'Income types',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge,
                                        ),
                                        NothingToDisplay(),
                                      ],
                                    )
                                  : SfCircularChart(
                                      title: ChartTitle(text: 'Income types'),
                                      legend: Legend(
                                        isVisible: largeScreen,
                                        overflowMode:
                                            LegendItemOverflowMode.wrap,
                                      ),
                                      series: <PieSeries>[
                                        PieSeries<CategorySpentGraph, String>(
                                            dataSource: viewModel
                                                .incomeCategories,
                                            pointColorMapper:
                                                (CategorySpentGraph data, _) =>
                                                    data.color,
                                            dataLabelMapper: (CategorySpentGraph
                                                        data,
                                                    index) =>
                                                data.name,
                                            dataLabelSettings:
                                                DataLabelSettings(
                                                    labelPosition:
                                                        ChartDataLabelPosition
                                                            .inside,
                                                    useSeriesColor: true,
                                                    isVisible: true),
                                            xValueMapper:
                                                (CategorySpentGraph data, _) =>
                                                    data.name,
                                            yValueMapper:
                                                (CategorySpentGraph data, _) =>
                                                    data.amount)
                                      ],
                                    ),
                            ),
                            Card(
                              elevation: 4,
                              margin: EdgeInsets.symmetric(vertical: 12.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: viewModel.outcomeCategories.isEmpty
                                  ? Column(
                                      children: [
                                        SizedBox(height: 16.0),
                                        Text(
                                          'Outcome types',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge,
                                        ),
                                        NothingToDisplay(),
                                      ],
                                    )
                                  : SfCircularChart(
                                      title: ChartTitle(text: 'Outcome types'),
                                      legend: Legend(
                                        isVisible: largeScreen,
                                        overflowMode:
                                            LegendItemOverflowMode.wrap,
                                      ),
                                      series: <PieSeries>[
                                        PieSeries<CategorySpentGraph, String>(
                                            dataSource: viewModel
                                                .outcomeCategories,
                                            pointColorMapper:
                                                (CategorySpentGraph data, _) =>
                                                    data.color,
                                            dataLabelMapper: (CategorySpentGraph
                                                        data,
                                                    index) =>
                                                data.name,
                                            dataLabelSettings:
                                                DataLabelSettings(
                                                    labelPosition:
                                                        ChartDataLabelPosition
                                                            .inside,
                                                    useSeriesColor: true,
                                                    isVisible: true),
                                            xValueMapper:
                                                (CategorySpentGraph data, _) =>
                                                    data.name,
                                            yValueMapper:
                                                (CategorySpentGraph data, _) =>
                                                    data.amount)
                                      ],
                                    ),
                            ),
                          ],
                        )
                      : SizedBox(),
                ),
                viewModel.allGraphs[4].selected
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: InterestingNumberCardHorizontal(
                                valueName: 'Sum of all incomes',
                                largeScreen: mediumScreen,
                                noData: viewModel.totalIncome.isNaN,
                                numberValue:
                                    viewModel.totalIncome.toStringAsFixed(0),
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
                                numberValue:
                                    viewModel.totalOutcome.toStringAsFixed(0),
                                numberSymbol: 'CZK'),
                          ),
                          SizedBox(
                            width: 16.0,
                          ),
                          Expanded(
                            child: InterestingNumberCardHorizontal(
                                valueName: 'Overall balance',
                                largeScreen: mediumScreen,
                                noData: viewModel.balance.isNaN,
                                numberValue:
                                    viewModel.balance.toStringAsFixed(0),
                                numberSymbol: 'CZK'),
                          ),
                        ],
                      )
                    : SizedBox(),
                SizedBox(height: 8.0),
                Column(
                  children: [
                    SizedBox(height: 8.0),
                    FilledButton.icon(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return GraphSelectDialog(viewModel: viewModel);
                            });
                      },
                      label: Text('Manage graphs'),
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
