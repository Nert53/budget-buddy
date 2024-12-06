import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:personal_finance/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData themeData = mainThemeMode;
  final brightness = PlatformDispatcher.instance.platformBrightness;
  int _themeColorNum = 0;
  int get themeColorNum => _themeColorNum;

  ThemeProvider() {
    loadTheme();
  }

  void loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _themeColorNum = prefs.getInt('themeColor') ?? 0;

    setColor(_themeColorNum);
  }

  /*
  void setDarkMode(bool value) {
    themeData = value ? secondThemeMode : mainThemeMode;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool('isDarkMode', value);
    });
    notifyListeners();
  }

  bool isDarkMode() {
    return themeData == secondThemeMode;
  }
  */

  void setColor(int value) {
    Color color1 = Colors.green;
    Color color2 = Colors.blue;
    Color color3 = Colors.red;
    Color newColor = color1;

    switch (value) {
      case 0:
        newColor = color1;
        break;
      case 1:
        newColor = color2;
        break;
      case 2:
        newColor = color3;
        break;
      default:
        newColor = color1;
    }

    ThemeData newThemeData = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: newColor),
      useMaterial3: true,
      fontFamily: 'Poppins',
      scaffoldBackgroundColor: const Color.fromARGB(255, 224, 224, 224),
    );

    themeData = newThemeData;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setInt('themeColor', value);
    });
    notifyListeners();
  }
}
