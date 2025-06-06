import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:personal_finance/constants.dart';
import 'package:personal_finance/model/transaction.dart';
import 'package:personal_finance/utils/functions.dart';
import 'package:personal_finance/view/widgets/dialogs/edit_transaction_dialog.dart';
import 'package:personal_finance/view/widgets/dialogs/select_time_period.dart';
import 'package:personal_finance/view_model/transactions_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat('dd.MM.yyyy');
    DateFormat timeFormat = DateFormat('HH:mm');

    return Consumer<TransactionViewModel>(builder: (context, viewModel, child) {
      DateFormat periodFormat = viewModel.currentPeriod.toLowerCase() == 'day'
          ? DateFormat('dd.MM.yyyy')
          : DateFormat('yyyy');

      DateTime startOfWeek = viewModel.currentDate
          .subtract(Duration(days: viewModel.currentDate.weekday));
      DateTime endOfWeek = viewModel.currentDate
          .add(Duration(days: 7 - viewModel.currentDate.weekday - 1));

      bool mediumScreen = MediaQuery.of(context).size.width > mediumScreenWidth;
      int maxVisibleNoteLength = mediumScreen ? 40 : 20;

      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                viewModel.currentPeriod.toLowerCase() == 'all time' ||
                        viewModel.currentPeriod.toLowerCase() == 'range'
                    ? const SizedBox()
                    : IconButton.filled(
                        icon: const Icon(
                          Icons.arrow_back_ios_new_outlined,
                        ),
                        onPressed: () {
                          viewModel.previousTimePeriod();
                        },
                      ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FilledButton.tonal(
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return FilterDateSheet(
                                  currentSelectedPeriod: viewModel.periodChoice
                                      .firstWhere((element) =>
                                          element.selected == true));
                            });
                      },
                      child: viewModel.currentPeriod.toLowerCase() == 'range'
                          ? Text(
                              '${DateFormat('dd.MM.yyyy').format(viewModel.startDate)} - ${DateFormat('dd.MM.yyyy').format(viewModel.endDate)}',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Theme.of(context)
                                      .textTheme
                                      .headlineMedium!
                                      .color),
                            )
                          : viewModel.currentPeriod.toLowerCase() == 'all time'
                              ? Text(
                                  'All time',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Theme.of(context)
                                          .textTheme
                                          .headlineMedium!
                                          .color),
                                )
                              : viewModel.currentPeriod.toLowerCase() == 'week'
                                  ? Text(
                                      '${DateFormat('dd. MM.').format(startOfWeek)} - ${DateFormat('dd. MM. yyyy').format(endOfWeek)}',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Theme.of(context)
                                              .textTheme
                                              .headlineMedium!
                                              .color),
                                    )
                                  : viewModel.currentPeriod.toLowerCase() ==
                                          'month'
                                      ? Text(
                                          '${convertMontNumToMonthName(viewModel.currentDate.month)}  ${periodFormat.format(viewModel.currentDate)}',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .headlineMedium!
                                                  .color),
                                        )
                                      : Text(
                                          periodFormat
                                              .format(viewModel.currentDate),
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .headlineMedium!
                                                  .color),
                                        ),
                    ),
                  ],
                ),
                viewModel.currentPeriod.toLowerCase() == 'all time' ||
                        viewModel.currentPeriod.toLowerCase() == 'range'
                    ? const SizedBox()
                    : IconButton.filled(
                        icon: const Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 24,
                        ),
                        onPressed: () {
                          viewModel.nextTimePeriod();
                        },
                      ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                viewModel.filtersApplied
                    ? Text('${viewModel.transactions.length} transactions')
                    : Text(
                        "Filters are not applied!",
                        style: TextStyle(
                            color: warningColor, fontWeight: FontWeight.bold),
                      ),
                Badge.count(
                  count: viewModel.categoryFilterCount +
                      viewModel.currencyFilterCount +
                      viewModel.typeFilterCount,
                  isLabelVisible: (viewModel.categoryFilterCount +
                              viewModel.currencyFilterCount +
                              viewModel.typeFilterCount) >
                          0 ||
                      viewModel.amountFilterActive,
                  alignment: Alignment.lerp(
                      Alignment.topCenter, Alignment.topRight, 0.85),
                  child: FilledButton.tonalIcon(
                      onPressed: () {
                        context.push('/filter-transactions');
                      },
                      style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                              Theme.of(context).colorScheme.primary),
                          foregroundColor: WidgetStateProperty.all(
                              Theme.of(context).colorScheme.onPrimary)),
                      icon: Icon(Icons.filter_alt_outlined,
                          color: Theme.of(context).colorScheme.onPrimary),
                      label: Text('Filters')),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          if (viewModel.transactions.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.white,
                      child: Icon(
                        viewModel.getFilterCount() > 0
                            ? Icons.filter_alt_off_outlined
                            : Icons.search_off,
                        size: 36,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                        viewModel.getFilterCount() > 0
                            ? 'No transactions meet the current filters.'
                            : 'No transactions found in this period.',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                        ))
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: Skeletonizer(
                enabled: viewModel.isLoading,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: RefreshIndicator(
                    onRefresh: () => viewModel.refreshTransactions(),
                    child: ListView.builder(
                      itemCount: viewModel.transactions.length,
                      itemBuilder: (BuildContext context, int index) {
                        Transaction currentTransaction =
                            viewModel.transactions[index];

                        return GestureDetector(
                          onTap: () {
                            showDialog<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return EditTransaction(
                                  transactionId: currentTransaction.id,
                                  amount: currentTransaction.amount,
                                  note: currentTransaction.note,
                                  date: currentTransaction.date,
                                  isOutcome: currentTransaction.isOutcome,
                                  categories: viewModel.categories,
                                  currencies: viewModel.currencies,
                                  categoryId: currentTransaction.categoryId,
                                  categoryName: currentTransaction.categoryName,
                                  categoryColor:
                                      currentTransaction.categoryColor,
                                  categoryIcon: currentTransaction.categoryIcon,
                                  currencyId: currentTransaction.currencyId,
                                  currencyName: currentTransaction.currencyName,
                                  currencySymbol:
                                      currentTransaction.currencySymbol,
                                );
                              },
                            );
                          },
                          child: Card(
                            elevation: 2,
                            child: ListTile(
                                key: ValueKey(currentTransaction.id.toString()),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                                          color:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyMedium
                                                                  ?.color,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    TextSpan(
                                                      text: "...more",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.grey[700],
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
                                    ),
                                  ],
                                ),
                                leading: Icon(
                                  currentTransaction.categoryIcon,
                                  color: currentTransaction.categoryColor,
                                ),
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
                                        '${amountPretty(viewModel.transactions[index].amount)} ${viewModel.transactions[index].currencySymbol}',
                                        style: TextStyle(
                                            color: currentTransaction.isOutcome
                                                ? outcomeColor
                                                : incomeColor,
                                            fontSize: 14),
                                      ),
                                    ])),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
        ],
      );
    });
  }
}
