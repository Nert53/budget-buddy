import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_finance/constants.dart';
import 'package:personal_finance/model/category_spent_graph.dart';
import 'package:personal_finance/model/transaction.dart';
import 'package:personal_finance/utils/functions.dart';
import 'package:personal_finance/view/widget/extended_dashboard.dart';
import 'package:personal_finance/view_model/dashboard_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    double contentWidth = screenWidth -
        ((screenWidth > mediumScreenWidth) ? (navigationRailWidth + 32) : 32);
    bool mediumScreen = screenWidth > mediumScreenWidth;
    int maxVisibleNoteLength = mediumScreen ? 40 : 20;

    return Consumer<DashboardViewmodel>(builder: (context, viewModel, child) {
      return Skeletonizer(
        enabled: viewModel.isLoading,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              SizedBox(
                height: 12.0,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      height: 360,
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
                                        ),
                                      ),
                                      SizedBox(height: 16.0),
                                      Text(
                                        'No outcome transactions for graph.',
                                        style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  ))
                                : Skeleton.ignore(
                                    child: SfCircularChart(
                                        margin: const EdgeInsets.all(0),
                                        legend: Legend(
                                          isVisible:
                                              screenWidth > mediumScreenWidth
                                                  ? true
                                                  : false,
                                          alignment: ChartAlignment.center,
                                          position: LegendPosition.left,
                                          overflowMode:
                                              LegendItemOverflowMode.scroll,
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
                                                    viewModel
                                                        .categoryGraphData[
                                                            index]
                                                        .icon,
                                                    color: viewModel
                                                        .categoryGraphData[
                                                            index]
                                                        .color,
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
                                        series: <CircularSeries>[
                                          DoughnutSeries<CategorySpentGraph, String>(
                                              dataSource:
                                                  viewModel.categoryGraphData,
                                              pointColorMapper:
                                                  (CategorySpentGraph data, _) =>
                                                      data.color,
                                              dataLabelMapper: (CategorySpentGraph data,
                                                      index) =>
                                                  '${data.name} (${(data.amount / viewModel.thisMonthSpent * 100).toInt()} %)',
                                              dataLabelSettings: DataLabelSettings(
                                                  borderRadius: 8,
                                                  connectorLineSettings:
                                                      ConnectorLineSettings(
                                                          type: ConnectorType
                                                              .curve),
                                                  textStyle: TextStyle(
                                                      fontSize: mediumScreen
                                                          ? 12
                                                          : 11),
                                                  labelPosition: screenWidth >
                                                          largeScreenWidth
                                                      ? ChartDataLabelPosition.outside
                                                      : ChartDataLabelPosition.inside,
                                                  useSeriesColor: true,
                                                  isVisible: true),
                                              xValueMapper: (CategorySpentGraph data, _) => data.name,
                                              yValueMapper: (CategorySpentGraph data, _) => data.amount)
                                        ]),
                                  ),
                          )
                        ],
                      ),
                    ),
                  ),
                  (screenWidth > mediumScreenWidth)
                      ? const SizedBox(width: 12.0)
                      : const SizedBox(),
                  (screenWidth > mediumScreenWidth)
                      ? Expanded(
                          flex: 1,
                          child: Container(
                            height: 360,
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
                                    child: viewModel.categoryGraphData.isEmpty
                                        ? Center(
                                            child: Text(
                                              'Graph data is empty.',
                                              style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          )
                                        : ListView.builder(
                                            itemCount: viewModel
                                                .categoryGraphData.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              var category = viewModel
                                                  .categoryGraphData[index];

                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 6.0),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 16.0,
                                                      height: 16.0,
                                                      decoration: BoxDecoration(
                                                          color: category.color,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0)),
                                                    ),
                                                    const SizedBox(width: 6.0),
                                                    Text(
                                                        '${amountPretty(category.amount)} CZK (${(category.amount / viewModel.thisMonthSpent * 100).toInt()} %)',
                                                        style: const TextStyle(
                                                          fontSize: 16.0,
                                                        )),
                                                  ],
                                                ),
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
              const SizedBox(height: 12.0),
              Row(
                children: [
                  Container(
                    height: 160,
                    width: (screenWidth > mediumScreenWidth)
                        ? (contentWidth - 176) / 3
                        : contentWidth / 2 + 4,
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
                  const SizedBox(width: 12.0),
                  Container(
                    height: 160,
                    width: (screenWidth > mediumScreenWidth)
                        ? (contentWidth - 176) / 3
                        : contentWidth / 2 - 8,
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
                      ? const SizedBox(width: 12.0)
                      : const SizedBox(),
                  (screenWidth > mediumScreenWidth)
                      ? SpendingDetailExtension(
                          containerHeight: 160,
                          todaySpent: viewModel.todaySpent,
                          predictedSpent: viewModel.predictedSpent,
                        )
                      : const SizedBox(),
                ],
              ),
              const SizedBox(height: 12.0),
              Container(
                constraints: BoxConstraints(maxHeight: 400),
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
                        style: TextStyle(fontSize: 16.0)),
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
                                Text(
                                  'No transaction to display.',
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
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
                                DateFormat dateFormat =
                                    DateFormat('dd. MM. yyyy');
                                DateFormat timeFormat = DateFormat('HH:mm');

                                return ListTile(
                                  key: ValueKey(
                                      currentTransaction.id.toString()),
                                  title: Column(
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
                                                  maxVisibleNoteLength
                                              ? Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: currentTransaction
                                                            .note
                                                            .substring(0,
                                                                maxVisibleNoteLength),
                                                        style: TextStyle(
                                                            fontSize: 14,
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
                                                          fontSize: 14,
                                                          color:
                                                              Colors.grey[700],
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
                                  leading: Icon(currentTransaction.categoryIcon,
                                      color: currentTransaction.categoryColor),
                                  trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        currentTransaction.isOutcome
                                            ? Icon(
                                                Icons.arrow_drop_down,
                                                color: outcomeColor,
                                              )
                                            : Icon(
                                                Icons.arrow_drop_up,
                                                color: incomeColor,
                                              ),
                                        Text(
                                          '${amountPretty(currentTransaction.amount)} ${currentTransaction.currencySymbol}',
                                          style: TextStyle(
                                              color:
                                                  currentTransaction.isOutcome
                                                      ? outcomeColor
                                                      : incomeColor,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ]),
                                );
                              }),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
            ],
          ),
        ),
      );
    });
  }
}
