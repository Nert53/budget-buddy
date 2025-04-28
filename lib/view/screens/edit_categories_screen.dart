import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_finance/constants.dart';
import 'package:personal_finance/utils/functions.dart';
import 'package:personal_finance/view/widgets/dialogs/add_category_dialog.dart';
import 'package:personal_finance/view/widgets/dialogs/edit_category_dialog.dart';
import 'package:personal_finance/view_model/edit_categories_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class EditCategoriesScreen extends StatelessWidget {
  const EditCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int rowCardCount;
    if (screenWidth < compactScreenWidth) {
      rowCardCount = 1;
    } else if (screenWidth < mediumScreenWidth) {
      rowCardCount = 2;
    } else if (screenWidth < largeScreenWidth) {
      rowCardCount = 3;
    } else {
      rowCardCount = 4;
    }

    return Consumer<EditCategoriesViewmodel>(
        builder: (context, viewModel, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Categories editor'),
          leading: IconButton(
            icon: Icon(Icons.adaptive.arrow_back),
            onPressed: () {
              context.pop();
            },
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
        ),
        floatingActionButton: screenWidth < mediumScreenWidth
            ? FloatingActionButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AddCategoryDialog(
                          viewModel: viewModel,
                        );
                      });
                },
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                child: Icon(
                  Icons.add,
                ),
              )
            : null,
        body: Center(
          child: Skeletonizer(
            enabled: viewModel.isLoading,
            child: Padding(
              padding: MediaQuery.of(context).size.width > largeScreenWidth
                  ? const EdgeInsets.symmetric(vertical: 16.0)
                  : const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: largeScreenWidth),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: rowCardCount,
                      crossAxisSpacing: 6,
                      mainAxisSpacing: 6,
                      childAspectRatio:
                          screenWidth < mediumScreenWidth ? 2.5 : 2),
                  itemCount: viewModel.categories.length +
                      1, // makes place for "new category" button
                  itemBuilder: (BuildContext context, int index) {
                    if (index == viewModel.categories.length) {
                      return FilledButton.icon(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AddCategoryDialog(
                                  viewModel: viewModel,
                                );
                              });
                        },
                        label: Text('New category',
                            style: TextStyle(fontSize: 18)),
                        icon: Icon(Icons.add),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                      );
                    }
                    return Card(
                        child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      padding: EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    convertIconCodePointToIcon(
                                        viewModel.categories[index].icon),
                                  ),
                                  SizedBox(width: 8.0),
                                  Text(
                                    viewModel.categories[index].name,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                              SizedBox(width: 32),
                              Skeleton.ignore(
                                child: Container(
                                  width: 30.0,
                                  height: 30.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: convertColorCodeToColor(
                                        viewModel.categories[index].color),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit_outlined),
                                iconSize: 26.0,
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return EditCategoryDialogSmall(
                                          viewModel: viewModel,
                                          categoryId:
                                              viewModel.categories[index].id,
                                          categoryName:
                                              viewModel.categories[index].name,
                                          categoryColor:
                                              convertColorCodeToColor(viewModel
                                                  .categories[index].color),
                                          categoryIcon:
                                              convertIconCodePointToIcon(
                                                  viewModel
                                                      .categories[index].icon),
                                        );
                                      });
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete_outlined),
                                color: Theme.of(context).colorScheme.error,
                                iconSize: 26.0,
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Delete category'),
                                          content: Text.rich(TextSpan(
                                              text:
                                                  'Are you sure you want to delete the category ',
                                              children: [
                                                TextSpan(
                                                  text: viewModel
                                                      .categories[index].name,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                TextSpan(
                                                    text:
                                                        '? All transactions with this category assigned will be also deleted.'),
                                              ])),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Cancel'),
                                            ),
                                            FilledButton(
                                              onPressed: () {
                                                viewModel.deleteCategory(
                                                    viewModel
                                                        .categories[index]);
                                                Navigator.of(context).pop();
                                              },
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    WidgetStateProperty.all<
                                                        Color>(
                                                  Theme.of(context)
                                                      .colorScheme
                                                      .error,
                                                ),
                                              ),
                                              child: Text(
                                                'Delete',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      });
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ));
                  },
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
