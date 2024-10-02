import 'package:flutter/material.dart';
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

    if (model.isLoading) {
      return Center(
          child: Row(
        children: [
          SizedBox(
            width: screenWidth / 2 - 24,
          ),
          const CircularProgressIndicator(),
        ],
      ));
    }
    if (model.transactions.isEmpty) {
      return const Center(
        child: Text('No transactions found'),
      );
    } else {
      return Column(
        children: [
          Container(
            color: Theme.of(context).colorScheme.primary,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new_outlined,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  onPressed: () {
                    model.refresh();
                  },
                ),
                Text(
                  convertMontNumToMonthName(DateTime.now().month),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 24,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  onPressed: () {
                    // Navigator.pushNamed(context, '/addTransaction');
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: ListView.builder(
                itemCount: model.transactions.length,
                itemBuilder: (BuildContext context, int index) {
                  return Dismissible(
                    key: Key(model.transactions[index].id.toString()),
                    onDismissed: (direction) {
                      model.deleteTransaction(model.transactions[index]);
                    },
                    direction: DismissDirection.endToStart,
                    background: Container(
                      decoration: BoxDecoration(
                          color: Colors.red[700],
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 16),
                      child: const Icon(
                        Icons.delete_outlined,
                        color: Colors.white,
                      ),
                    ),
                    child: Card(
                      child: ListTile(
                        key: ValueKey(model.transactions[index].id.toString()),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(model.toString()),
                            Text(model.transactions[index].note),
                            Text(
                              model.transactions[index].date.toString(),
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
}
