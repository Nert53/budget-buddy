import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:personal_finance/constants.dart';

class ColorPickDialog extends StatefulWidget {
  const ColorPickDialog({super.key});

  @override
  State<ColorPickDialog> createState() => _ColorPickDialogState();
}

class _ColorPickDialogState extends State<ColorPickDialog> {
  late Color selectedColor;

  @override
  void initState() {
    super.initState();
    selectedColor = Colors.red;
  }

  void changeSelectedColor(Color newColor) {
    setState(() {
      selectedColor = newColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Pick a color'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Discard'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop(selectedColor);
          },
          child: Text('Save'),
        ),
      ],
      content: SingleChildScrollView(
        child: BlockPicker(
          pickerColor: selectedColor,
          availableColors: allCategoryColors,
          onColorChanged: (newColor) {
            print(newColor.value);

            changeSelectedColor(newColor);
          },
        ),
      ),
    );
  }
}
