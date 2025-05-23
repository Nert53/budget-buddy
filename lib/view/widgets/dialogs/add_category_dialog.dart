import 'package:flutter/material.dart';
import 'package:personal_finance/view/constants/colors_categories.dart';
import 'package:personal_finance/view/constants/icons_categories.dart';
import 'package:personal_finance/view/widgets/dialogs/pick_color_dialog.dart';
import 'package:personal_finance/view/widgets/dialogs/pick_icon_dialog.dart';
import 'package:personal_finance/view/widgets/flushbars.dart';
import 'package:personal_finance/view_model/edit_categories_viewmodel.dart';

class AddCategoryDialog extends StatefulWidget {
  final EditCategoriesViewmodel viewModel;
  const AddCategoryDialog({super.key, required this.viewModel});

  @override
  State<AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  TextEditingController categoryNameController = TextEditingController();
  late Color newCategoryColor;
  late IconData newCategoryIcon;

  @override
  void initState() {
    newCategoryColor = allCategoryColors.first;
    newCategoryIcon = allCategoryIcons.first;
    super.initState();
  }

  void changeNewCategoryColor(Color newColor) {
    setState(() {
      newCategoryColor = newColor;
    });
  }

  void changeNewCategoryIcon(IconData newIcon) {
    setState(() {
      newCategoryIcon = newIcon;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create new category'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Discard'),
        ),
        FilledButton(
          onPressed: () {
            if (categoryNameController.text.isEmpty) {
              FlushbarWarning.show(
                context: context,
                message:
                    "Name of category can't be empty. Please enter some name.",
              );
              return;
            }

            widget.viewModel.addCategory(
                categoryNameController.text, newCategoryColor, newCategoryIcon);
            Navigator.of(context).pop();
          },
          child: const Text('Create'),
        ),
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: categoryNameController,
            decoration: InputDecoration(
              labelText: 'Name',
              hintText: 'Enter category name',
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
                          return IconPickDialog(
                              iconCode: allCategoryIcons.first.codePoint);
                        });

                    // navigator pop context on "discard" will return another type
                    if (newCategoryIcon.runtimeType == IconData) {
                      changeNewCategoryIcon(newCategoryIcon);
                    }
                  },
                  icon: Icon(newCategoryIcon)),
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
                          return ColorPickDialog(
                            initialColor: allCategoryColors.first.value,
                          );
                        });

                    // navigator pop context on "discard" will return another type
                    if (newCategoryColor.runtimeType == MaterialColor) {
                      changeNewCategoryColor(newCategoryColor);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: 4), // to be aligned with the icon button above
                    child: CircleAvatar(
                      backgroundColor: newCategoryColor,
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
