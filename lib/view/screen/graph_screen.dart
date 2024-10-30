import 'package:flutter/material.dart';
import 'package:personal_finance/view_model/graph_viewmodel.dart';
import 'package:provider/provider.dart';

class GraphScreen extends StatelessWidget {
  const GraphScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<GraphViewModel>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            child: ListView(
              children: [
                SizedBox(height: 12.0),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: SizedBox(
                    height: 200,
                    child: Center(
                      child: Text('Graph'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          FilledButton.tonalIcon(
            onPressed: () => {},
            label: Text('Add new graph'),
            icon: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
