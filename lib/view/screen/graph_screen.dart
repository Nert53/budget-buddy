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

      return Column(
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
                      elevation: 2,
                      margin:
                          EdgeInsets.symmetric(vertical: 6.0, horizontal: 12),
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
                                      'Most spent categories',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                    NothingToDisplay(),
                                  ],
                                )
                              : SfCartesianChart(
                                  title:
                                      ChartTitle(text: 'Most spent categories'),
                                  plotAreaBorderWidth: 0,
                                  primaryXAxis: CategoryAxis(),
                                  primaryYAxis: NumericAxis(
                                    labelFormat: mediumScreen
                                        ? '{value} CZK'
                                        : '{value}',
                                  ),
                                  series: <ColumnSeries>[
                                    ColumnSeries(
                                      dataSource:
                                          viewModel.topCategoriesGraphData,
                                      xValueMapper: (data, _) => data.name,
                                      yValueMapper: (data, _) => data.amount,
                                      pointColorMapper: (data, _) => data.color,
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
                      elevation: 2,
                      margin:
                          EdgeInsets.symmetric(vertical: 6.0, horizontal: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: SizedBox(
                          height: 400,
                          child: viewModel.dailySpentInMonthGraphData.isEmpty
                              ? Column(
                                  children: [
                                    SizedBox(height: 16.0),
                                    Text(
                                      'Spent during time',
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
                                    text: 'Spent during time',
                                  ),
                                  primaryXAxis: DateTimeAxis(
                                    dateFormat: DateFormat('dd. MM.'),
                                    interval: mediumScreen ? 1 : 3,
                                    intervalType: DateTimeIntervalType.days,
                                    majorGridLines: MajorGridLines(width: 0),
                                    edgeLabelPlacement:
                                        EdgeLabelPlacement.shift,
                                  ),
                                  primaryYAxis: const NumericAxis(
                                    labelFormat: '{value} CZK',
                                    axisLine: AxisLine(width: 0),
                                    majorTickLines: MajorTickLines(size: 0),
                                  ),
                                  trackballBehavior: TrackballBehavior(
                                    enable: true,
                                    activationMode: ActivationMode.singleTap,
                                    tooltipSettings: const InteractiveTooltip(
                                        format: 'point.x point.y'),
                                  ),
                                  series: <AreaSeries<
                                      MapEntry<DateTime, double>, DateTime>>[
                                    AreaSeries<MapEntry<DateTime, double>,
                                        DateTime>(
                                      dataSource:
                                          viewModel.dailySpentInMonthGraphData,
                                      xValueMapper: (data, _) => data.key,
                                      yValueMapper: (data, _) => data.value,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withAlpha((0.9 * 255)
                                              .toInt()), // makes the color bit transparent
                                    ),
                                  ],
                                )),
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
                                    noData: viewModel.savedFromIncome.isNaN,
                                    numberValue: viewModel.savedFromIncome,
                                    numberSymbol: '%'),
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
                                  noData: viewModel.savedFromIncome.isNaN,
                                  numberValue: viewModel.savedFromIncome
                                      .toStringAsFixed(0),
                                  numberSymbol: '%'),
                            ),
                            SizedBox(
                              height: 160,
                              child: InterestingNumberCardVertical(
                                  valueName: 'Average daily spent',
                                  largeScreen: mediumScreen,
                                  noData: viewModel.averageDailySpent.isNaN,
                                  numberValue: viewModel.averageDailySpent
                                      .toStringAsFixed(0),
                                  numberSymbol: 'CZK'),
                            ),
                            SizedBox(
                              height: 160,
                              child: InterestingNumberCardVertical(
                                  valueName:
                                      'Transactions in foreign currencies',
                                  largeScreen: mediumScreen,
                                  numberValue: viewModel
                                      .transactionsForeignCurrenciesPercent
                                      .toStringAsFixed(0),
                                  numberSymbol: '%'),
                            )
                          ],
                        )
                  : SizedBox(),
              viewModel.allGraphs[3].selected
                  ? Column(
                      children: [
                        GridView(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: mediumScreen ? 2 : 1,
                            childAspectRatio: 1.3,
                            crossAxisSpacing: mediumScreen ? 16.0 : 0,
                            mainAxisSpacing: mediumScreen ? 10.0 : 0,
                          ),
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                          physics:
                              NeverScrollableScrollPhysics(), // to disable GridView's scrolling
                          children: [
                            Card(
                              elevation: 2,
                              margin: EdgeInsets.symmetric(vertical: 6.0),
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
                              elevation: 2,
                              margin: EdgeInsets.symmetric(vertical: 6.0),
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
                        ),
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
                                  noData: viewModel.balance.isNaN,
                                  numberValue: viewModel.balance,
                                  numberSymbol: 'CZK',
                                  coloredStyle: 1,
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
                                  numberValue:
                                      viewModel.totalIncome.toStringAsFixed(0),
                                  numberSymbol: 'CZK'),
                            ),
                            SizedBox(
                              height: 160,
                              child: InterestingNumberCardVertical(
                                  valueName: 'Sum of all outcomes',
                                  largeScreen: mediumScreen,
                                  noData: viewModel.totalOutcome.isNaN,
                                  numberValue:
                                      viewModel.totalOutcome.toStringAsFixed(0),
                                  numberSymbol: 'CZK'),
                            ),
                            SizedBox(
                              height: 160,
                              child: InterestingNumberCardVertical(
                                  valueName: 'Overall balance',
                                  largeScreen: mediumScreen,
                                  numberValue:
                                      viewModel.balance.toStringAsFixed(0),
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
      );
    });
  }
}
