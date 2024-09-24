import 'package:flutter/material.dart';
import 'package:personal_finance/data/database.dart';
import 'package:personal_finance/view_model/transaction_viewmodel.dart';
import 'package:provider/provider.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TransactionViewModel(),
      child: const TransactionList(),
    );
  }
}

class TransactionList extends StatelessWidget {
  const TransactionList({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<TransactionViewModel>(context, listen: false).getTransactions();

    final double screenWidth = MediaQuery.of(context).size.width;

    return Consumer<TransactionViewModel>(
      builder: (context, model, child) {
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
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: model.transactions.length,
                itemBuilder: (BuildContext context, int index) {
                  return Dismissible(
                    key: ValueKey(model.transactions[index]),
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
                        key: ValueKey(model.transactions[index].id),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(model.transactions[index].id.toString()),
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
          );
        }
      },
    );
  }
}
