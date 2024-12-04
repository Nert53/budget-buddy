import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_finance/view/widget/edit_transaction.dart';
import 'package:personal_finance/view/widget/transaction_skeleton.dart';
import 'package:personal_finance/view_model/transaction_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var model = context.watch<TransactionViewModel>();

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
                    model.previousMonth();
                  },
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  model.currentDisplayedNewer
                      ? IconButton.filled(
                          onPressed: () => {
                                model.upToDate(),
                              },
                          icon: Icon(Icons.keyboard_double_arrow_left_outlined))
                      : const SizedBox(width: 16),
                  SizedBox(
                    width: 8,
                  ),
                  GestureDetector(
                    onTap: model.getAllData,
                    child: Text(
                      '${model.currentMonthString} ${model.currentDate.year}',
                      style: const TextStyle(
                        fontSize: 22,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  model.currentDisplayedOlder
                      ? IconButton.filled(
                          onPressed: () => {
                                model.upToDate(),
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
                    model.nextMonth();
                  },
                ),
              ),
            ],
          ),
        ),
        if (model.isLoading)
          Expanded(child: Skeletonizer(child: TransactionSkeleton()))
        else if (model.transactions.isEmpty)
          const Expanded(
            child: Center(
              child: Text('No transactions found in this month.'),
            ),
          )
        else
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: ListView.builder(
                itemCount: model.transactions.length,
                itemBuilder: (BuildContext context, int index) {
                  var currentTransaction = model.transactions[index];

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
                            categoryId: currentTransaction.categoryId,
                            currencyId: currentTransaction.currencyId,
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
                              Text(
                                currentTransaction.note,
                                style: TextStyle(fontWeight: FontWeight.bold),
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
                              '${model.transactions[index].amount} ${model.transactions[index].currencyName}',
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
