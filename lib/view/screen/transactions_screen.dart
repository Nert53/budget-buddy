import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_finance/model/transaction.dart';
import 'package:personal_finance/view/widget/edit_transaction_dialog.dart';
import 'package:personal_finance/view/widget/transaction_list_skeleton.dart';
import 'package:personal_finance/view_model/transactions_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TransactionViewModel viewModel = context.watch<TransactionViewModel>();

    DateFormat dateFormat = DateFormat('dd.MM.yyyy');
    DateFormat timeFormat = DateFormat('HH:mm');

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                        color: Theme.of(context).primaryColor, width: 2)),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_outlined,
                  ),
                  onPressed: () {
                    viewModel.previousMonth();
                  },
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  viewModel.currentDisplayedNewer
                      ? IconButton.filled(
                          onPressed: () => {
                                viewModel.upToDate(),
                              },
                          icon: Icon(Icons.keyboard_double_arrow_left_outlined))
                      : const SizedBox(width: 16),
                  SizedBox(
                    width: 8,
                  ),
                  GestureDetector(
                    onTap: viewModel.getAllData,
                    child: Text(
                      '${viewModel.currentMonthString} ${viewModel.currentDate.year}',
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  viewModel.currentDisplayedOlder
                      ? IconButton.filled(
                          onPressed: () => {
                                viewModel.upToDate(),
                              },
                          icon:
                              Icon(Icons.keyboard_double_arrow_right_outlined))
                      : const SizedBox(width: 16),
                ],
              ),
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                        color: Theme.of(context).primaryColor, width: 2)),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_forward_ios_outlined,
                  ),
                  onPressed: () {
                    viewModel.nextMonth();
                  },
                ),
              ),
            ],
          ),
        ),
        if (viewModel.isLoading)
          Expanded(child: Skeletonizer(child: TransactionSkeleton()))
        else if (viewModel.transactions.isEmpty)
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.search_off,
                      size: 36,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text('No transactions found in this month.'),
                ],
              ),
            ),
          )
        else
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
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
                            categoryColor: currentTransaction.categoryColor,
                            categoryIcon: currentTransaction.categoryIcon,
                            currencyId: currentTransaction.currencyId,
                            currencyName: currentTransaction.currencyName,
                            currencySymbol: currentTransaction.currencySymbol,
                          );
                        },
                      );
                    },
                    child: Card(
                      child: ListTile(
                          key: ValueKey(currentTransaction.id.toString()),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              currentTransaction.note.isEmpty
                                  ? Text(
                                      '---',
                                      style: const TextStyle(
                                          fontSize: 15, color: Colors.grey),
                                    )
                                  : Text(
                                      currentTransaction.note,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                              Text(
                                '${dateFormat.format(currentTransaction.date)} | ${timeFormat.format(currentTransaction.date)}',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey[700]),
                              ),
                            ],
                          ),
                          leading: Icon(
                            currentTransaction.categoryIcon,
                            color: currentTransaction.categoryColor,
                          ),
                          trailing:
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
                              '${viewModel.transactions[index].amount} ${viewModel.transactions[index].currencySymbol}',
                              style: TextStyle(
                                  color: currentTransaction.isOutcome
                                      ? Colors.red
                                      : Colors.green[700],
                                  fontSize: 14),
                            ),
                          ])),
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}
