import 'package:flutter/material.dart';
import 'package:personal_finance/constants.dart';
import 'package:personal_finance/model/category_spent_graph.dart';
import 'package:personal_finance/view/widget/graph_select_dialog.dart';
import 'package:personal_finance/view_model/graph_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GraphScreen extends StatelessWidget {
  const GraphScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool largeScreen = MediaQuery.of(context).size.width > mediumScreenWidth;

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
                Card(
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
                                maximum: viewModel
                                        .topCategoriesGraphData.first.amount *
                                    1.2,
                                interval: viewModel
                                        .topCategoriesGraphData.first.amount *
                                    0.3,
                              ),
                              series: <ColumnSeries>[
                                ColumnSeries(
                                  dataSource: viewModel.topCategoriesGraphData,
                                  xValueMapper: (data, _) => data.name,
                                  yValueMapper: (data, _) => data.amount,
                                  pointColorMapper: (data, _) => data.color,
                                  dataLabelSettings: DataLabelSettings(
                                    isVisible: true,
                                    labelAlignment: ChartDataLabelAlignment.top,
                                  ),
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(12),
                                  ),
                                ),
                              ],
                            )),
                ),
                Card(
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
                          interval: largeScreen ? 1 : 3,
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
                            dataSource: viewModel.dailySpentInMonthGraphData,
                            xValueMapper: (data, _) => data.key,
                            yValueMapper: (data, _) => data.value,
                            name: 'Spent',
                            markerSettings: MarkerSettings(
                              isVisible: true,
                            ),
                          ),
                        ],
                      )),
                ),
                SizedBox(
                    height: 340,
                    child: largeScreen
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Card(
                                  elevation: 4,
                                  margin: EdgeInsets.symmetric(vertical: 12.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Container(
                                    height: 316,
                                    padding: EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Tooltip(
                                          message:
                                              'Percentage is meauser from last 6 months.',
                                          child: Text('Savings from income',
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight:
                                                      FontWeight.normal)),
                                        ),
                                        Expanded(
                                          child: Center(
                                            child: Text(
                                              '${viewModel.savingFromIncome.toStringAsFixed(1)} %',
                                              style: TextStyle(
                                                fontSize: largeScreen ? 48 : 32,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 16.0,
                              ),
                              Expanded(
                                child: Card(
                                  elevation: 4,
                                  margin: EdgeInsets.symmetric(vertical: 12.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Container(
                                    height: 320,
                                    padding: EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Average daily spending',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.normal)),
                                        Expanded(
                                          child: Center(
                                            child: Text(
                                              '${viewModel.averageDailySpending.toStringAsFixed(1)} CZK',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: largeScreen ? 48 : 32,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 16.0,
                              ),
                              Expanded(
                                child: Card(
                                  elevation: 4,
                                  margin: EdgeInsets.symmetric(vertical: 12.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Container(
                                    height: 320,
                                    padding: EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Tooltip(
                                          message: '',
                                          child: Text(
                                              'Transactions in foreign currencies',
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight:
                                                      FontWeight.normal)),
                                        ),
                                        Expanded(
                                          child: Center(
                                            child: Text(
                                              '${viewModel.percentageForeignCurrencyTransactions.toStringAsFixed(0)} %',
                                              style: TextStyle(
                                                fontSize: largeScreen ? 48 : 32,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              SizedBox(
                                height: 160,
                                child: Expanded(
                                  child: Card(
                                    elevation: 4,
                                    margin: EdgeInsets.symmetric(vertical: 6.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: Container(
                                      height: 200,
                                      padding: EdgeInsets.all(16.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Tooltip(
                                            message:
                                                'Percentage is meauser from last 6 months.',
                                            child: Text('Savings from income',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.normal)),
                                          ),
                                          Expanded(
                                            child: Center(
                                              child: Text(
                                                '18.5 %',
                                                style: TextStyle(
                                                  fontSize:
                                                      largeScreen ? 48 : 32,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Card(
                                  elevation: 4,
                                  margin: EdgeInsets.symmetric(vertical: 6.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Container(
                                    height: 320,
                                    padding: EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Average daily spending',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.normal)),
                                        Expanded(
                                          child: Center(
                                            child: Text(
                                              '${viewModel.averageDailySpending.toStringAsFixed(1)} CZK',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: largeScreen ? 48 : 32,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Card(
                                  elevation: 4,
                                  margin: EdgeInsets.symmetric(vertical: 6.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Container(
                                    height: 320,
                                    padding: EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Tooltip(
                                          message: '',
                                          child: Text(
                                              'Transactions in foreign currencies',
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight:
                                                      FontWeight.normal)),
                                        ),
                                        Expanded(
                                          child: Center(
                                            child: Text(
                                              '${viewModel.percentageForeignCurrencyTransactions.toStringAsFixed(0)} %',
                                              style: TextStyle(
                                                fontSize: largeScreen ? 48 : 32,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                Expanded(
                  child: GridView(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: largeScreen ? 2 : 1,
                      childAspectRatio: 1.3,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 10.0,
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
                            isVisible: false,
                          ),
                          series: <PieSeries>[
                            PieSeries<CategorySpentGraph, String>(
                                dataSource: viewModel.incomeCategories,
                                pointColorMapper:
                                    (CategorySpentGraph data, _) => data.color,
                                dataLabelMapper:
                                    (CategorySpentGraph data, index) =>
                                        data.name,
                                dataLabelSettings: DataLabelSettings(
                                    labelPosition: largeScreen
                                        ? ChartDataLabelPosition.outside
                                        : ChartDataLabelPosition.inside,
                                    useSeriesColor: true,
                                    isVisible: true),
                                xValueMapper: (CategorySpentGraph data, _) =>
                                    data.name,
                                yValueMapper: (CategorySpentGraph data, _) =>
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
                            isVisible: true,
                            overflowMode: LegendItemOverflowMode.wrap,
                          ),
                          series: <PieSeries>[
                            PieSeries<CategorySpentGraph, String>(
                                dataSource: viewModel.outcomeCategories,
                                pointColorMapper:
                                    (CategorySpentGraph data, _) => data.color,
                                dataLabelMapper:
                                    (CategorySpentGraph data, index) =>
                                        data.name,
                                dataLabelSettings: DataLabelSettings(
                                    labelPosition:
                                        ChartDataLabelPosition.inside,
                                    useSeriesColor: true,
                                    isVisible: true),
                                xValueMapper: (CategorySpentGraph data, _) =>
                                    data.name,
                                yValueMapper: (CategorySpentGraph data, _) =>
                                    data.amount)
                          ],
                        ),
                      ),
                    ],
                  ),
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
                      label: Text('Add new graph'),
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
