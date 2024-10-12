import 'package:flutter/material.dart';
import 'package:personal_finance/constants.dart';
import 'package:personal_finance/utils/functions.dart';
import 'package:personal_finance/view_model/dashboard_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    bool wideScreen = screenWidth > mediumScreenWidth;
    double contentWidth =
        screenWidth - (wideScreen ? (navigationRailWidth + 32) : 32);

    final model = context.watch<DashboardViewmodel>();

    if (model.isLoading) {
      return Center(
          child: Row(
        children: [
          SizedBox(
            width: contentWidth / 2 - 24,
          ),
          const CircularProgressIndicator(),
        ],
      ));
    }

    return Padding(
      padding: const EdgeInsets.only(
          left: 16.0, right: 16.0, top: 16.0, bottom: 16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 240,
              width: contentWidth,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 1),
                    blurRadius: 5.0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Monthly spending graph',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.normal)),
                  const SizedBox(height: 8.0),
                  Expanded(
                      child: LineChart(
                    LineChartData(
                      titlesData: const FlTitlesData(
                        topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                      ),
                      minX: 0,
                      maxX: model.currrentDate.daysInMonth().toDouble(),
                      minY: 0,
                      maxY: 1000,
                    ),
                  ))
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Container(
                  height: 160,
                  width: contentWidth / 2 - 8,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 1),
                        blurRadius: 5.0,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Account Balance',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.normal),
                      ),
                      Expanded(
                          child: Center(
                              child: Text('${model.accountBalance} CZK',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold)))),
                    ],
                  ),
                ),
                const SizedBox(width: 16.0),
                Container(
                  height: 160,
                  width: contentWidth / 2 - 8,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 1),
                        blurRadius: 5.0,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('This month spendings',
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.normal)),
                      Expanded(
                          child: Center(
                              child: Text('${model.thisMonthBalance} CZK',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold)))),
                    ],
                  ),
                ),
              ],
            ),
            //OutlinedButton(onPressed: model.refresh, child: const Text('Refresh')),
          ],
        ),
      ),
    );
  }
}
