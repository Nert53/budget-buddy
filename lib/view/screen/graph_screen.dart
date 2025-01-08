import 'package:flutter/material.dart';
import 'package:personal_finance/view/widget/graph_select_dialog.dart';
import 'package:personal_finance/view_model/graph_viewmodel.dart';
import 'package:provider/provider.dart';

class GraphScreen extends StatelessWidget {
  const GraphScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GraphViewModel>(builder: (context, viewModel, child) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: ListView.builder(
                itemCount: 2 + 1,
                itemBuilder: (context, index) {
                  if (index == 2) {
                    return Column(
                      children: [
                        SizedBox(height: 16.0),
                        FilledButton.tonalIcon(
                          onPressed: () {
                            showDialog(context: context, builder: 
                            (context) {
                              return GraphSelectDialog(viewModel: viewModel);
                            });
                          },
                          label: Text('Add new graph'),
                          icon: Icon(
                            Icons.add,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                              Theme.of(context).primaryColor,
                            ),
                            foregroundColor: WidgetStateProperty.all(
                              Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ],
                    );
                  }

                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 6.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: SizedBox(
                      height: 200,
                      child: Center(
                        child: Text('Graph'),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
