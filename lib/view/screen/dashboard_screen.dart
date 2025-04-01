import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_finance/constants.dart';
import 'package:personal_finance/model/category_spent_graph.dart';
import 'package:personal_finance/model/transaction.dart';
import 'package:personal_finance/utils/functions.dart';
import 'package:personal_finance/view/widget/extended_dashboard.dart';
import 'package:personal_finance/view_model/dashboard_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    double contentWidth = screenWidth -
        ((screenWidth > mediumScreenWidth) ? (navigationRailWidth + 32) : 32);

    return Consumer<DashboardViewmodel>(builder: (context, viewModel, child) {
      if (viewModel.isLoading) {
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

      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            SizedBox(
              height: 16.0,
            ),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    height: 340,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(16.0)),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 1),
                          blurRadius: 2.0,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Monthly spending overview',
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8.0),
                        Expanded(
                          child: viewModel.categoryGraphData.isEmpty
                              ? Center(
                                  child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 32,
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .surfaceContainer,
                                      child: Icon(
                                        Icons.sentiment_dissatisfied,
                                        size: 32,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                      ),
                                    ),
                                    SizedBox(height: 16.0),
                                    Text(
                                      'No data to display in graph.',
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary),
                                    ),
                                  ],
                                ))
                              : SfCircularChart(
                                  margin: const EdgeInsets.all(0),
                                  legend: Legend(
                                    isVisible: screenWidth > mediumScreenWidth
                                        ? true
                                        : false,
                                    alignment: ChartAlignment.center,
                                    position: LegendPosition.left,
                                    overflowMode: LegendItemOverflowMode.scroll,
                                  ),
                                  series: <CircularSeries>[
                                      // Renders doughnut chart
                                      DoughnutSeries<CategorySpentGraph,
                                              String>(
                                          dataSource:
                                              viewModel.categoryGraphData,
                                          pointColorMapper:
                                              (CategorySpentGraph data, _) =>
                                                  data.color,
                                          dataLabelMapper:
                                              (CategorySpentGraph data,
                                                      index) =>
                                                  data.name,
                                          dataLabelSettings: DataLabelSettings(
                                              labelPosition: screenWidth >
                                                      largeScreenWidth
                                                  ? ChartDataLabelPosition
                                                      .outside
                                                  : ChartDataLabelPosition
                                                      .inside,
                                              useSeriesColor: true,
                                              isVisible: true),
                                          xValueMapper:
                                              (CategorySpentGraph data, _) =>
                                                  data.name,
                                          yValueMapper:
                                              (CategorySpentGraph data, _) =>
                                                  data.amount)
                                    ]),
                        )
                      ],
                    ),
                  ),
                ),
                (screenWidth > mediumScreenWidth)
                    ? const SizedBox(width: 16.0)
                    : const SizedBox(),
                (screenWidth > mediumScreenWidth)
                    ? Expanded(
                        flex: 1,
                        child: Container(
                          height: 340,
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(16.0)),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0, 1),
                                blurRadius: 2.0,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Categories exactly spent',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8.0),
                              Expanded(
                                  child: ListView.builder(
                                itemCount: viewModel.categoryGraphData.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var category =
                                      viewModel.categoryGraphData[index];

                                  return Row(
                                    children: [
                                      Container(
                                        width: 16.0,
                                        height: 16.0,
                                        decoration: BoxDecoration(
                                            color: category.color,
                                            borderRadius:
                                                BorderRadius.circular(8.0)),
                                      ),
                                      const SizedBox(width: 6.0),
                                      Text(
                                          '${category.amount.toStringAsFixed(0)} CZK',
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                          )),
                                    ],
                                  );
                                },
                              ))
                            ],
                          ),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Container(
                  height: 160,
                  width: (screenWidth > mediumScreenWidth)
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
                        blurRadius: 2.0,
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
                              child: Text(
                                  '${amountPretty(viewModel.accountBalance, decimalDigits: 0)} CZK',
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
                  width: (screenWidth > mediumScreenWidth)
                      ? (contentWidth - 176) / 4
                      : contentWidth / 2 - 8,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 1),
                        blurRadius: 2.0,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('This month spent',
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.normal)),
                      Expanded(
                          child: Center(
                              child: Text(
                                  '${amountPretty(viewModel.thisMonthSpent, decimalDigits: 0)} CZK',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold)))),
                    ],
                  ),
                ),
                (screenWidth > mediumScreenWidth)
                    ? const SizedBox(width: 16.0)
                    : const SizedBox(),
                (screenWidth > mediumScreenWidth)
                    ? SpendingDetailExtension(
                        containerHeight: 160,
                        todaySpent: viewModel.todaySpent,
                        predictedSpent: viewModel.predictedSpentThisMonth,
                      )
                    : const SizedBox(),
              ],
            ),
            const SizedBox(height: 16.0),
            Container(
              constraints: BoxConstraints(maxHeight: 380),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 1),
                    blurRadius: 2.0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Last 5 transactions',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16.0),
                  Expanded(
                    child: viewModel.lastTransactions.isEmpty
                        ? Center(
                            child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 32,
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .surfaceContainer,
                                child: Icon(
                                  Icons.playlist_remove,
                                  size: 30,
                                ),
                              ),
                              SizedBox(height: 16.0),
                              Text('No transaction to display.'),
                            ],
                          ))
                        : ListView.separated(
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const Divider(),
                            itemCount: viewModel.lastTransactions.length,
                            itemBuilder: (BuildContext context, int index) {
                              Transaction currentTransaction =
                                  viewModel.lastTransactions[index];
                              DateFormat dateFormat = DateFormat('dd.MM.yyyy');
                              DateFormat timeFormat = DateFormat('HH:mm');

                              return ListTile(
                                key: ValueKey(currentTransaction.id.toString()),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        currentTransaction.note.isEmpty
                                            ? Text(
                                                '(No note)',
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.grey),
                                              )
                                            : currentTransaction.note.length >
                                                    20
                                                ? RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text:
                                                              currentTransaction
                                                                  .note
                                                                  .substring(
                                                                      0, 20),
                                                          style: TextStyle(
                                                              color: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyMedium
                                                                  ?.color,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        TextSpan(
                                                          text: "...more",
                                                          style: TextStyle(
                                                            color: Colors
                                                                .grey[700],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                : Text(
                                                    currentTransaction.note,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                        Text(
                                          '${dateFormat.format(currentTransaction.date)} | ${timeFormat.format(currentTransaction.date)}',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[700]),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                leading: Icon(currentTransaction.categoryIcon,
                                    color: currentTransaction.categoryColor),
                                trailing: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
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
                                            '${amountPretty(currentTransaction.amount)} ${currentTransaction.currencySymbol}',
                                            style: TextStyle(
                                                color:
                                                    currentTransaction.isOutcome
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
            ),
            SizedBox(height: 16.0),
          ],
        ),
      );
    });
  }
}
