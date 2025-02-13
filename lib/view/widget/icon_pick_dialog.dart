import 'package:flutter/material.dart';
import 'package:personal_finance/constants.dart';
import 'package:personal_finance/utils/functions.dart';

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
        width: screenWidth > mediumScreenWidth ? 400 : double.maxFinite,
        height: screenWidth > mediumScreenWidth ? 400 : double.maxFinite,
        child: GridView.builder(
            shrinkWrap: true,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
            itemCount: allCategoryIcons.length,
            itemBuilder: (context, index) {
              IconData currentIcon = allCategoryIcons[index];

              if (index == selecteedIconIndex) {
                return IconButton.filled(
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
