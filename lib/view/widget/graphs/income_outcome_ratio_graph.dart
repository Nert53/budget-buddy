import 'package:flutter/material.dart';
import 'package:personal_finance/model/category_spent_graph.dart';
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
                  title: ChartTitle(text: 'Ratio of income categories'),
                  legend: Legend(
                    isVisible: largeScreen,
                    overflowMode: LegendItemOverflowMode.wrap,
                  ),
                  series: <PieSeries>[
                    PieSeries<CategorySpentGraph, String>(
                        dataSource: incomeCategories,
                        pointColorMapper: (CategorySpentGraph data, _) =>
                            data.color,
                        dataLabelMapper: (CategorySpentGraph data, index) =>
                            data.name,
                        dataLabelSettings: DataLabelSettings(
                            labelPosition: ChartDataLabelPosition.inside,
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
                  title: ChartTitle(text: 'Ratio of outcome categories'),
                  legend: Legend(
                    isVisible: largeScreen,
                    overflowMode: LegendItemOverflowMode.wrap,
                  ),
                  series: <PieSeries>[
                    PieSeries<CategorySpentGraph, String>(
                        dataSource: outcomeCategories,
                        pointColorMapper: (CategorySpentGraph data, _) =>
                            data.color,
                        dataLabelMapper: (CategorySpentGraph data, index) =>
                            data.name,
                        dataLabelSettings: DataLabelSettings(
                            labelPosition: ChartDataLabelPosition.inside,
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
