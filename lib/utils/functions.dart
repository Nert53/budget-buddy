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
    case 'home':
      return Icons.cottage_outlined;
    case 'work':
      return Icons.work_outline;
    case 'handshake':
      return Icons.handshake_outlined;
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

convertColorCodeToColor(int colorCode) {
  return Color(colorCode);
}

extension DateTimeExtension on DateTime {
  int daysInMonth() {
    switch (month) {
      case 1:
        return 31;
      case 2:
        return year % 4 == 0 ? 29 : 28;
      case 3:
        return 31;
      case 4:
        return 30;
      case 5:
        return 31;
      case 6:
        return 30;
      case 7:
        return 31;
      case 8:
        return 31;
      case 9:
        return 30;
      case 10:
        return 31;
      case 11:
        return 30;
      case 12:
        return 31;
      default:
        return 30;
    }
  }
}
