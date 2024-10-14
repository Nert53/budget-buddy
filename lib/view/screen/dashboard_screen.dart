import 'package:flutter/material.dart';
import 'package:personal_finance/constants.dart';
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
          left: 16.0, right: 16.0, top: 16.0, bottom: 0.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 340,
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
                  const Text('Monthly spending overview',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.normal)),
                  const SizedBox(height: 8.0),
                  Expanded(
                      child: PieChart(
                    PieChartData(
                        sectionsSpace: 6, sections: model.categoryPieData),
                    // Optional
                  ))
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Container(
                  height: 160,
                  width: wideScreen
                      ? (contentWidth - 176) / 2
                      : contentWidth / 2 - 8,
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
                  width: wideScreen
                      ? (contentWidth - 176) / 2
                      : contentWidth / 2 - 8,
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
            const SizedBox(height: 16.0),
            Container(
              height: 90 * model.lastTransactions.length.toDouble(),
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
                  const Text('Last 5 transactions',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.normal)),
                  const Divider(thickness: 2),
                  Expanded(
                    child: ListView.separated(
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(),
                        itemCount: model.lastTransactions.length,
                        itemBuilder: (BuildContext context, int index) {
                          var currentTransaction =
                              model.lastTransactions[index];

                          return ListTile(
                            key: ValueKey(currentTransaction.id.toString()),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(currentTransaction.categoryIcon,
                                        color:
                                            currentTransaction.categoryColor),
                                    const SizedBox(width: 6.0),
                                    Text(currentTransaction.categoryName,
                                        style: const TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                            ),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    '${currentTransaction.date.day}.${currentTransaction.date.month}.${currentTransaction.date.year}',
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                    )),
                                Row(mainAxisSize: MainAxisSize.min, children: [
                                  currentTransaction.isOutcome
                                      ? const Icon(
                                          Icons.arrow_drop_down,
                                          color: Colors.red,
                                        )
                                      : Icon(
                                          Icons.arrow_drop_up,
                                          color: Colors.green[700],
                                        ),
                                  Text(
                                    '${currentTransaction.amount} ${currentTransaction.currencyName}',
                                    style: TextStyle(
                                        color: currentTransaction.isOutcome
                                            ? Colors.red
                                            : Colors.green[700],
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ]),
                              ],
                            ),
                          );
                        }),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
