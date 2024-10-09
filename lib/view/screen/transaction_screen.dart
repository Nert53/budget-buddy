import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_finance/utils/functions.dart';
import 'package:personal_finance/view_model/transaction_viewmodel.dart';
import 'package:provider/provider.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
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
              Text(
                '${model.currentMonthString} ${model.currentYear}',
                style: const TextStyle(
                  fontSize: 22,
                ),
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
          const Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        else if (model.transactions.isEmpty)
          const Expanded(
            child: Center(
              child: Text('No transactions found'),
            ),
          )
        else
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: ListView.builder(
                itemCount: model.transactions.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(
                      key: ValueKey(model.transactions[index].id.toString()),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(model.transactions[index].note),
                          Text(
                            '${dateFormat.format(model.transactions[index].date)} | ${timeFormat.format(model.transactions[index].date)}',
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[700]),
                          ),
                        ],
                      ),
                      leading: const Icon(Icons.local_grocery_store_outlined),
                      trailing: Text(
                        '${model.transactions[index].amount} ${model.transactions[index].currency}',
                        style: const TextStyle(color: Colors.red),
                      ),
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
