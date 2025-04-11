import 'package:flutter/material.dart';
import 'package:personal_finance/model/category_spent_graph.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HighSpendingCategoriesGraph extends StatelessWidget {
  final List<CategorySpentGraph> data;
  final bool mediumScreen;

  const HighSpendingCategoriesGraph(
      {super.key, required this.data, required this.mediumScreen});

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      title: ChartTitle(text: 'Highets spending categories'),
      plotAreaBorderWidth: 0,
      primaryXAxis: CategoryAxis(),
      primaryYAxis: NumericAxis(
        labelFormat: mediumScreen ? '{value} CZK' : '{value}',
      ),
      series: <ColumnSeries>[
        ColumnSeries(
          dataSource: data,
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
    );
  }
}
