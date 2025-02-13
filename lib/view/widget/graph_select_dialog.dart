import 'package:flutter/material.dart';
import 'package:personal_finance/constants.dart';
import 'package:personal_finance/view_model/graph_viewmodel.dart';
import 'dart:math';

class GraphSelectDialog extends StatefulWidget {
  final GraphViewModel viewModel;
  const GraphSelectDialog({super.key, required this.viewModel});

  @override
  State<GraphSelectDialog> createState() => _GraphSelectDialogState();
}

class _GraphSelectDialogState extends State<GraphSelectDialog> {
  @override
  void initState() {
    super.initState();
  }

  void setSelectedGraph(int index, bool value) {
    setState(() {
      allGraphs[index].selected = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add new graph'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Save'),
        ),
      ],
      content: SizedBox(
        width: min(400, MediaQuery.of(context).size.width),
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: allGraphs.length,
            itemBuilder: (context, index) {
              var currentGraph = allGraphs[index];

              return ListTile(
                title: Text(
                  currentGraph.name,
                  style: TextStyle(fontSize: 14),
                ),
                leading: Checkbox(
                    value: currentGraph.selected,
                    onChanged: (value) {
                      setSelectedGraph(index, value!);
                    }),
                trailing: Icon(currentGraph.icon,
                    color: currentGraph.selected
                        ? Theme.of(context).primaryColor
                        : null),
              );
            }),
      ),
    );
  }
}
