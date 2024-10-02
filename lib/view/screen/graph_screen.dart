import 'package:flutter/material.dart';
import 'package:personal_finance/view_model/test_model.dart';
import 'package:provider/provider.dart';

class GraphScreen extends StatelessWidget {
  const GraphScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<TestModel>();

    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(),
      itemCount: model.data.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(model.data[index]),
        );
      },
    );
  }
}
