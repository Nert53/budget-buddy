import 'package:flutter/material.dart';

convertIconNameToIcon(String iconName) {
  switch (iconName.toLowerCase()) {
    case 'grocery':
      return Icons.local_grocery_store_outlined;
    case 'restaurant':
      return Icons.restaurant;
    case 'directions_car':
      return Icons.directions_car_outlined;
    case 'celebration':
      return Icons.celebration_outlined;
    case 'health':
      return Icons.health_and_safety_outlined;
    default:
      return Icons.attach_money;
  }
}

convertMontNumToMonthName(int monthNum) {
  switch (monthNum) {
    case 1:
      return 'January';
    case 2:
      return 'February';
    case 3:
      return 'March';
    case 4:
      return 'April';
    case 5:
      return 'May';
    case 6:
      return 'June';
    case 7:
      return 'July';
    case 8:
      return 'August';
    case 9:
      return 'September';
    case 10:
      return 'October';
    case 11:
      return 'November';
    case 12:
      return 'December';
    default:
      return 'Unknown';
  }
}
