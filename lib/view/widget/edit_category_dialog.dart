import 'package:flutter/material.dart';
import 'package:personal_finance/data/database.dart';
import 'package:personal_finance/utils/functions.dart';
import 'package:personal_finance/view/widget/color_pick_dialog.dart';
import 'package:personal_finance/view/widget/icon_pick_dialog.dart';
import 'package:personal_finance/view_model/edit_categories_viewmodel.dart';

class EditCategoryDialogSmall extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  final Color categoryColor;
  final IconData categoryIcon;
  final EditCategoriesViewmodel viewModel;

  const EditCategoryDialogSmall({
    super.key,
    required this.categoryId,
    required this.categoryName,
    required this.categoryColor,
    required this.categoryIcon,
    required this.viewModel,
  });

  @override
  State<EditCategoryDialogSmall> createState() =>
      _EditCategoryDialogSmallState();
}

class _EditCategoryDialogSmallState extends State<EditCategoryDialogSmall> {
  late Color selectedCategoryColor;
  late IconData selectedCategoryIcon;

  @override
  void initState() {
    super.initState();
    selectedCategoryColor = widget.categoryColor;
    selectedCategoryIcon = widget.categoryIcon;
  }

  void changeSelectedCategoryColor(Color newColor) {
    setState(() {
      selectedCategoryColor = newColor;
    });
  }

  void changeSelectedCategoryIcon(IconData newIcon) {
    setState(() {
      selectedCategoryIcon = newIcon;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit category'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Cancel',
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
        ),
        FilledButton(
          onPressed: () {
            String stringColorCode =
                selectedCategoryColor.value.toRadixString(16);
            CategoryItem updatedCategory = CategoryItem(
              id: widget.categoryId,
              name: widget.categoryName,
              icon: convertIconToIconCodePoint(selectedCategoryIcon),
              color: int.parse(stringColorCode, radix: 16),
            );
            widget.viewModel.updateCategory(updatedCategory);
            Navigator.of(context).pop();
          },
          child: Text(
            'Save',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: TextEditingController(text: widget.categoryName),
            decoration: InputDecoration(
              labelText: 'Name',
              hintText: widget.categoryName,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Icon',
                style: TextStyle(fontSize: 16),
              ),
              IconButton.outlined(
                  onPressed: () async {
                    var newCategoryIcon = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return IconPickDialog();
                        });

                    // navigator pop context on "discard" will return another type
                    if (newCategoryIcon.runtimeType == IconData) {
                      changeSelectedCategoryIcon(newCategoryIcon);
                    }
                  },
                  icon: Icon(selectedCategoryIcon)),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Color', style: TextStyle(fontSize: 16)),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () async {
                    var newCategoryColor = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ColorPickDialog();
                        });

                    // navigator pop context on "discard" will return another type
                    if (newCategoryColor.runtimeType == MaterialColor) {
                      changeSelectedCategoryColor(newCategoryColor);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: 4), // to be aligned with the icon button above
                    child: CircleAvatar(
                      backgroundColor: selectedCategoryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class EditCategoryDialogLarge extends StatelessWidget {
  final String categoryName;
  final Color categoryColor;
  final IconData categoryIcon;

  const EditCategoryDialogLarge({
    super.key,
    required this.categoryName,
    required this.categoryColor,
    required this.categoryIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        TextField(
          decoration: InputDecoration(
            labelText: 'Category name',
          ),
        ),
        TextField(
          decoration: InputDecoration(
            labelText: 'Category icon',
          ),
        ),
      ],
    );
  }
}
