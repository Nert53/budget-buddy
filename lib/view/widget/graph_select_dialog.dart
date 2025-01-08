import 'package:flutter/material.dart';
import 'package:personal_finance/view_model/graph_viewmodel.dart';

class GraphSelectDialog extends StatefulWidget {
  final GraphViewModel viewModel;
  const GraphSelectDialog({super.key, required this.viewModel});

  @override
  State<GraphSelectDialog> createState() => _GraphSelectDialogState();
}

class _GraphSelectDialogState extends State<GraphSelectDialog> {
  List<bool> _selectedGraphs = List.generate(6, (index) => true);

  @override
  void initState() {
    super.initState();
  }

  void setSelectedGraph(int index, bool value) {
    widget.viewModel.allGraphs[index].selected = value;
    setState(() {
      _selectedGraphs[index] = value;
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
        width: double.maxFinite,
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.viewModel.allGraphs.length,
            itemBuilder: (context, index) {
              var currentGraph = widget.viewModel.allGraphs[index];

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
