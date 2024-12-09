import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_finance/view_model/edit_categories_viewmodel.dart';
import 'package:provider/provider.dart';

class EditCategoriesScreen extends StatelessWidget {
  const EditCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    EditCategoriesViewmodel viewModel =
        context.watch<EditCategoriesViewmodel>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Categories'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            context.go(
              '/settings',
            );
          },
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: viewModel.isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading categories...'),
                ],
              ),
            )
          : Center(
              child: Text('Edit Categories Screen'),
            ),
    );
  }
}
