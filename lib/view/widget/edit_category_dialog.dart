import 'dart:math';

import 'package:flutter/material.dart';

class EditCategoryDialogSmall extends StatelessWidget {
  final String categoryName;
  final Color categoryColor;
  final IconData categoryIcon;

  const EditCategoryDialogSmall({
    super.key,
    required this.categoryName,
    required this.categoryColor,
    required this.categoryIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: TextEditingController(text: categoryName),
          decoration: InputDecoration(
            labelText: 'Name',
            hintText: categoryName,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
              child: Icon(categoryIcon),
            ),
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
                onTap: () {},
                child: CircleAvatar(
                  backgroundColor: categoryColor,
                ),
              ),
            ),
          ],
        ),
      ],
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
