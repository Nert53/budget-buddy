import 'package:flutter/material.dart';
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

  void setSelectedGraph(int graphId, String graphName, bool value) {
    setState(() {
      widget.viewModel.reselectGraph(graphId, graphName, value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Manage graphs'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Exit manager'),
        ),
      ],
      content: SizedBox(
        width: min(400, MediaQuery.of(context).size.width),
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.viewModel.allGraphs.length,
            itemBuilder: (context, index) {
              var currentGraph = widget.viewModel.allGraphs[index];

              return ListTile(
                title: Text(
                  currentGraph.namePretty,
                  style: TextStyle(fontSize: 14),
                ),
                leading: Checkbox(
                    value: currentGraph.selected,
                    onChanged: (value) {
                      setSelectedGraph(
                          currentGraph.id, currentGraph.name, value!);
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
