import 'package:flutter/material.dart';
import 'package:personal_finance/constants.dart';

class IconPickDialog extends StatefulWidget {
  const IconPickDialog({super.key});

  @override
  State<IconPickDialog> createState() => _IconPickDialogState();
}

class _IconPickDialogState extends State<IconPickDialog> {
  late IconData selectedIcon;
  late int selecteedIconIndex;

  @override
  void initState() {
    super.initState();
    selectedIcon = Icons.ac_unit;
    selecteedIconIndex = 0;
  }

  void changeSelectedIcon(IconData newIcon, int index) {
    setState(() {
      selectedIcon = newIcon;
      selecteedIconIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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
        width: double.maxFinite,
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
