import 'package:flutter/material.dart';
import 'package:personal_finance/view_model/add_transaction_viewmodel.dart';
import 'package:provider/provider.dart';

class AddModalBottom extends StatelessWidget {
  const AddModalBottom({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AddTransactionViewModel(),
      child: const AddModalWindow(),
    );
  }
}

class AddModalWindow extends StatelessWidget {
  const AddModalWindow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Provider.of<AddTransactionViewModel>(context, listen: false);

    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Consumer<AddTransactionViewModel>(builder: (context, model, child) {
      return SizedBox(
        height: screenHeight * 0.65,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 48,
                width: screenWidth,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(28.0),
                    topRight: Radius.circular(28.0),
                  ),
                ),
                child: Center(
                    child: Text(
                  'Add Transaction',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                )),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: model.amountController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16))),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: model.noteController,
                  minLines: 3,
                  maxLines: 5,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Notes',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16))),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.error,
                        side: BorderSide(
                            color: Theme.of(context).colorScheme.error)),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Discard'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                      ),
                      onPressed: () {
                        model.saveTransaction();
                        Navigator.pop(context);
                      },
                      child: const Text('Save Transaction')),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
