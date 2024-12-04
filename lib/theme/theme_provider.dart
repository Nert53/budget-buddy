import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:personal_finance/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = mainThemeMode;
  ThemeData get themeData => _themeData;
  final _currentBrightness =
      SchedulerBinding.instance.platformDispatcher.platformBrightness;
  bool _isSystemColorMode = false;
  bool get isSystemColorMode => _isSystemColorMode;

  ThemeProvider() {
    loadTheme();
  }

  void loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isSystemColorMode = prefs.getBool('isSystemColorMode') ?? false;

    if (_isSystemColorMode) {
      themeData = _currentBrightness == Brightness.dark
          ? secondThemeMode
          : mainThemeMode;
      return;
    }

    bool isDark = prefs.getBool('isDarkMode') ?? false;
    themeData = isDark ? secondThemeMode : mainThemeMode;
  }

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool('isDarMode', themeData == secondThemeMode);
    });
    notifyListeners();
  }

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

  void setColor(int value) {
    int currentPrimaryValue = _themeData.colorScheme.primary.value;
    int mainPrimaryValue = mainThemeMode.colorScheme.primary.value;

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

    if (currentPrimaryValue == mainPrimaryValue) {
      themeData = newThemeData;
    } else {
      themeData = newThemeData;
    }
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool('isDarkMode', themeData == secondThemeMode);
    });
    notifyListeners();
  }
}
