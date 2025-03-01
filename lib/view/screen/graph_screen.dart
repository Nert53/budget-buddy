import 'package:flutter/material.dart';
import 'package:personal_finance/constants.dart';
import 'package:personal_finance/model/category_spent_graph.dart';
import 'package:personal_finance/view/widget/dialogs/select_graph_dialog.dart';
import 'package:personal_finance/view/widget/graph/interesting_number_card.dart';
import 'package:personal_finance/view_model/graph_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GraphScreen extends StatelessWidget {
  const GraphScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool mediumScreen = MediaQuery.of(context).size.width > mediumScreenWidth;
    bool largeScreen = MediaQuery.of(context).size.width > largeScreenWidth;

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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
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
                                ? Center(
                                    child: Text(
                                        'No data to display (Categories with most spendings)'),
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
                            child: SfCartesianChart(
                              plotAreaBorderWidth: 0,
                              title: ChartTitle(
                                text: 'Spent during month',
                              ),
                              primaryXAxis: NumericAxis(
                                edgeLabelPlacement: EdgeLabelPlacement.shift,
                                minimum: 1,
                                maximum: 31,
                                interval: mediumScreen ? 1 : 3,
                                majorGridLines: MajorGridLines(width: 0),
                              ),
                              primaryYAxis: const NumericAxis(
                                labelFormat: '{value}',
                                axisLine: AxisLine(width: 0),
                                majorTickLines:
                                    MajorTickLines(color: Colors.transparent),
                              ),
                              series: <LineSeries<MapEntry<int, double>, int>>[
                                LineSeries<MapEntry<int, double>, int>(
                                  dataSource:
                                      viewModel.dailySpentInMonthGraphData,
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
                    ? SizedBox(
                        height: mediumScreen ? 340 : 480,
                        child: mediumScreen
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: InterestingNumberCardHorizontal(
                                        valueName: 'Saving from income',
                                        largeScreen: mediumScreen,
                                        numberValue: viewModel.savingFromIncome
                                            .toStringAsFixed(0),
                                        numberSymbol: '%'),
                                  ),
                                  SizedBox(
                                    width: 16.0,
                                  ),
                                  Expanded(
                                    child: InterestingNumberCardHorizontal(
                                        valueName: 'Average daily spending',
                                        largeScreen: mediumScreen,
                                        numberValue: viewModel
                                            .averageDailySpending
                                            .toStringAsFixed(0),
                                        numberSymbol: 'CZK'),
                                  ),
                                  SizedBox(
                                    width: 16.0,
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
                                          valueName: 'Saving from income',
                                          largeScreen: mediumScreen,
                                          numberValue: viewModel
                                              .savingFromIncome
                                              .toStringAsFixed(0),
                                          numberSymbol: '%'),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 160,
                                    child: Expanded(
                                      child: InterestingNumberCardVertical(
                                          valueName: 'Average daily spending',
                                          largeScreen: mediumScreen,
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
                              ))
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
                              child: SfCircularChart(
                                title: ChartTitle(text: 'Income types'),
                                legend: Legend(
                                  isVisible: largeScreen,
                                  overflowMode: LegendItemOverflowMode.wrap,
                                ),
                                series: <PieSeries>[
                                  PieSeries<CategorySpentGraph, String>(
                                      dataSource: viewModel.incomeCategories,
                                      pointColorMapper:
                                          (CategorySpentGraph data, _) =>
                                              data.color,
                                      dataLabelMapper:
                                          (CategorySpentGraph data, index) =>
                                              data.name,
                                      dataLabelSettings: DataLabelSettings(
                                          labelPosition:
                                              ChartDataLabelPosition.inside,
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
                              child: SfCircularChart(
                                title: ChartTitle(text: 'Outcome types'),
                                legend: Legend(
                                  isVisible: largeScreen,
                                  overflowMode: LegendItemOverflowMode.wrap,
                                ),
                                series: <PieSeries>[
                                  PieSeries<CategorySpentGraph, String>(
                                      dataSource: viewModel.outcomeCategories,
                                      pointColorMapper:
                                          (CategorySpentGraph data, _) =>
                                              data.color,
                                      dataLabelMapper:
                                          (CategorySpentGraph data, index) =>
                                              data.name,
                                      dataLabelSettings: DataLabelSettings(
                                          labelPosition:
                                              ChartDataLabelPosition.inside,
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
                Column(
                  children: [
                    SizedBox(height: 16.0),
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
                        Icons.add,
                      ),
                    ),
                    SizedBox(height: 16.0),
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
