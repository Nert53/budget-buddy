import 'package:flutter/material.dart';
import 'package:personal_finance/model/category_spent_graph.dart';
import 'package:personal_finance/utils/functions.dart';
import 'package:personal_finance/view/widget/graphs/nothing_to_display.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class IncomeOutcomeRatioGraph extends StatelessWidget {
  final bool mediumScreen;
  final bool largeScreen;
  final List<CategorySpentGraph> incomeCategories;
  final List<CategorySpentGraph> outcomeCategories;

  const IncomeOutcomeRatioGraph(
      {super.key,
      required this.mediumScreen,
      required this.largeScreen,
      required this.incomeCategories,
      required this.outcomeCategories});

  @override
  Widget build(BuildContext context) {
    return GridView(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: mediumScreen ? 2 : 1,
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: incomeCategories.isEmpty
              ? Column(
                  children: [
                    SizedBox(height: 16.0),
                    Text(
                      'Ratio of income categories',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    NothingToDisplay(),
                  ],
                )
              : SfCircularChart(
                  title: ChartTitle(
                      text: 'Ratio of income categories',
                      textStyle: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).textTheme.titleMedium?.color,
                      )),
                  margin: EdgeInsets.only(top: 12),
                  legend: Legend(
                    isVisible: largeScreen,
                    overflowMode: LegendItemOverflowMode.wrap,
                    legendItemBuilder: (
                      String name,
                      dynamic series,
                      dynamic point,
                      int index,
                    ) {
                      return SizedBox(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(
                              incomeCategories[index].icon,
                              color: incomeCategories[index].color,
                              size: 18,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(name),
                          ],
                        ),
                      );
                    },
                  ),
                  series: <PieSeries>[
                    PieSeries<CategorySpentGraph, String>(
                        dataSource: incomeCategories,
                        pointColorMapper: (CategorySpentGraph data, _) =>
                            data.color,
                        dataLabelMapper: (CategorySpentGraph data, index) =>
                            "${data.name} (${amountPretty(data.amount)} CZK)",
                        dataLabelSettings: DataLabelSettings(
                            labelPosition: ChartDataLabelPosition.inside,
                            textStyle:
                                TextStyle(fontSize: mediumScreen ? 12 : 11),
                            useSeriesColor: true,
                            isVisible: true),
                        xValueMapper: (CategorySpentGraph data, _) => data.name,
                        yValueMapper: (CategorySpentGraph data, _) =>
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
          child: outcomeCategories.isEmpty
              ? Column(
                  children: [
                    SizedBox(height: 16.0),
                    Text(
                      'Ratio of outcome categories',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    NothingToDisplay(),
                  ],
                )
              : SfCircularChart(
                  title: ChartTitle(
                      text: 'Ratio of outcome categories',
                      textStyle: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).textTheme.titleMedium?.color,
                      )),
                  margin: EdgeInsets.only(top: 12),
                  legend: Legend(
                    isVisible: largeScreen,
                    overflowMode: LegendItemOverflowMode.wrap,
                    legendItemBuilder: (
                      String name,
                      dynamic series,
                      dynamic point,
                      int index,
                    ) {
                      return SizedBox(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(
                              outcomeCategories[index].icon,
                              color: outcomeCategories[index].color,
                              size: 18,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(name),
                          ],
                        ),
                      );
                    },
                  ),
                  series: <PieSeries>[
                    PieSeries<CategorySpentGraph, String>(
                        dataSource: outcomeCategories,
                        pointColorMapper: (CategorySpentGraph data, _) =>
                            data.color,
                        dataLabelMapper: (CategorySpentGraph data, index) =>
                            "${data.name} (${amountPretty(data.amount)} CZK)",
                        dataLabelSettings: DataLabelSettings(
                            labelPosition: ChartDataLabelPosition.inside,
                            textStyle:
                                TextStyle(fontSize: mediumScreen ? 12 : 11),
                            useSeriesColor: true,
                            isVisible: true),
                        xValueMapper: (CategorySpentGraph data, _) => data.name,
                        yValueMapper: (CategorySpentGraph data, _) =>
                            data.amount)
                  ],
                ),
        ),
      ],
    );
  }
}
