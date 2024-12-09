import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:personal_finance/theme/theme.dart';
import 'package:personal_finance/utils/functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData themeData = mainThemeMode;
  final brightness = PlatformDispatcher.instance.platformBrightness;
  String _themeColorName = 'teal';
  String get themeColorName => _themeColorName;

  ThemeProvider() {
    loadTheme();
  }

  void loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _themeColorName = prefs.getString('themeColorName') ?? 'teal';

    Color themeColor = convertThemeColorNameToColor(themeColorName);
    setColor(themeColor, themeColorName);
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

  void setColor(Color newColor, String newColorName) {
    ThemeData newThemeData = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: newColor),
      useMaterial3: true,
      fontFamily: 'Poppins',
      scaffoldBackgroundColor: const Color.fromARGB(255, 224, 224, 224),
    );

    themeData = newThemeData;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('themeColorName', newColorName);
    });
    notifyListeners();
  }
}
