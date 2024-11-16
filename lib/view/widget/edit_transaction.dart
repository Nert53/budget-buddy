import 'package:flutter/material.dart';
import 'package:personal_finance/view_model/transaction_viewmodel.dart';

class EditTransaction extends StatefulWidget {
  final String id;
  final String note;
  final double amount;
  DateTime date;
  final bool isOutcome;
  final TransactionViewModel viewModel;

  EditTransaction({
    super.key,
    required this.id,
    required this.note,
    required this.amount,
    required this.date,
    required this.isOutcome,
    required this.viewModel,
  });

  @override
  State<EditTransaction> createState() => _EditTransactionState();
}

class _EditTransactionState extends State<EditTransaction> {
  TextEditingController noteController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    noteController.text = widget.note;
    amountController.text = widget.amount.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AlertDialog(
          title: Row(
            children: [
              const Text('Edit Transaction'),
              const SizedBox(width: 64),
              IconButton(
                onPressed: () {
                  widget.viewModel.deleteTransactionById(widget.id);
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.delete_outlined),
                style:
                    ButtonStyle(iconColor: WidgetStateProperty.all(Colors.red)),
              ),
            ],
          ),
          content: Column(
            children: [
              TextField(
                controller: amountController,
                decoration: InputDecoration(
                  labelText: 'Amount',
                ),
              ),
              TextField(
                controller: noteController,
                decoration: InputDecoration(
                  labelText: 'Note',
                ),
              ),
              Row(
                children: [
                  Icon(Icons.calendar_month_outlined),
                  TextButton(
                    onPressed: () {
                      showDatePicker(
                        context: context,
                        initialDate: widget.date,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      ).then((value) {
                        if (value != null) {
                          setState(() {
                            widget.date = value;
                          });
                        }
                      });
                    },
                    child: Text(
                      widget.date.toString(),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.schedule_outlined),
                  TextButton(
                    onPressed: () {
                      showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(widget.date),
                      ).then((value) {
                        if (value != null) {
                          setState(() {});
                        }
                      });
                    },
                    child: Text(
                      widget.date.toString(),
                    ),
                  ),
                ],
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Discard changes'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ],
    );
  }
}
