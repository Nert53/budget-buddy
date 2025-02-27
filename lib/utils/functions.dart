import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

IconData convertIconCodePointToIcon(int iconCodePoint) {
  return IconData(iconCodePoint, fontFamily: 'MaterialIcons');
}

int convertIconToIconCodePoint(IconData icon) {
  return icon.codePoint;
}

String convertMontNumToMonthName(int monthNum) {
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

Color convertColorCodeToColor(int colorCode) {
  return Color(colorCode);
}

Color convertThemeColorNameToColor(String themeColorName) {
  switch (themeColorName) {
    case 'teal':
      return Colors.teal;
    case 'blue':
      return Colors.blue;
    case 'green':
      return Colors.green;
    case 'orange':
      return Colors.orangeAccent;
    case 'purple':
      return Colors.purple;
    case 'red':
      return Colors.red;
    case 'yellow':
      return Colors.yellow;
    default:
      return Colors.teal;
  }
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

String amountPretty(double amount) {
  final formatter = NumberFormat("#,##0.0", "en_US");
  return formatter.format(amount).replaceAll(",", " ");
}

