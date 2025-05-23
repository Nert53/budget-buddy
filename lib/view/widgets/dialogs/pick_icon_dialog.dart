import 'package:flutter/material.dart';
import 'package:personal_finance/constants.dart';
import 'package:personal_finance/utils/functions.dart';
import 'package:personal_finance/view/constants/icons_categories.dart';

class IconPickDialog extends StatefulWidget {
  final int iconCode;
  const IconPickDialog({super.key, required this.iconCode});

  @override
  State<IconPickDialog> createState() => _IconPickDialogState();
}

class _IconPickDialogState extends State<IconPickDialog> {
  late IconData selectedIcon;
  late int selecteedIconIndex;

  @override
  void initState() {
    super.initState();
    selectedIcon = convertIconCodePointToIcon(widget.iconCode);
    selecteedIconIndex = allCategoryIcons.indexOf(selectedIcon);
  }

  void changeSelectedIcon(IconData newIcon, int index) {
    setState(() {
      selectedIcon = newIcon;
      selecteedIconIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool mediumScreen = screenWidth > mediumScreenWidth;

    return AlertDialog(
      title: Text('Pick an icon'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Discard'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop(selectedIcon);
          },
          child: Text('Save'),
        ),
      ],
      content: SizedBox(
        width: mediumScreen ? 400 : double.maxFinite,
        height: mediumScreen ? 400 : 400,
        child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: mediumScreen ? 5 : 4),
            itemCount: allCategoryIcons.length,
            itemBuilder: (context, index) {
              IconData currentIcon = allCategoryIcons[index];

              if (index == selecteedIconIndex) {
                return IconButton.filledTonal(
                  isSelected: index == selecteedIconIndex,
                  onPressed: () {
                    changeSelectedIcon(currentIcon, index);
                  },
                  icon: Icon(currentIcon),
                );
              }

              return IconButton(
                onPressed: () {
                  changeSelectedIcon(currentIcon, index);
                },
                icon: Icon(currentIcon),
              );
            }),
      ),
    );
  }
}
