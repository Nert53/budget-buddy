import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SpendingOverTimeGraph extends StatelessWidget {
  final List<MapEntry<DateTime, double>> data;
  final bool mediumScreen;

  const SpendingOverTimeGraph(
      {super.key, required this.data, required this.mediumScreen});

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(
        text: 'Spending over time',
        textStyle: TextStyle(
          fontSize: 16,
          color: Theme.of(context).textTheme.titleMedium?.color,
        ),
      ),
      primaryXAxis: DateTimeAxis(
        dateFormat: DateFormat('dd. MM.'),
        interval: mediumScreen ? 1 : 3,
        intervalType: DateTimeIntervalType.days,
        majorGridLines: MajorGridLines(width: 0),
        edgeLabelPlacement: EdgeLabelPlacement.shift,
      ),
      primaryYAxis: const NumericAxis(
        labelFormat: '{value} CZK',
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0),
      ),
      trackballBehavior: TrackballBehavior(
        enable: true,
        activationMode: ActivationMode.singleTap,
        tooltipSettings: const InteractiveTooltip(format: 'point.x point.y'),
      ),
      series: <AreaSeries<MapEntry<DateTime, double>, DateTime>>[
        AreaSeries<MapEntry<DateTime, double>, DateTime>(
          dataSource: data,
          xValueMapper: (data, _) => data.key,
          yValueMapper: (data, _) => data.value,
          color: Theme.of(context).colorScheme.primary.withAlpha(
              (0.9 * 255).toInt()), // makes the color bit transparent
        ),
      ],
    );
  }
}
