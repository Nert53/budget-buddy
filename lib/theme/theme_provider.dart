import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_finance/constants.dart';
import 'package:personal_finance/theme/theme.dart';
import 'package:personal_finance/utils/functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData themeData = mainThemeMode;
  final brightness = PlatformDispatcher.instance.platformBrightness;
  String themeColorName = 'teal';

  ThemeProvider() {
    loadTheme();
  }

  void loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    themeColorName = prefs.getString('themeColorName') ?? 'teal';

    Color themeColor = convertThemeColorNameToColor(themeColorName);
    setColorFromSeed(themeColor, themeColorName);
  }

  void setColorFromSeed(Color newSeedColor, String newSeedColorName) {
    ThemeData newThemeData = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: newSeedColor),
      useMaterial3: true,
      textTheme: GoogleFonts.poppinsTextTheme(),
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      sliderTheme:
          SliderThemeData(showValueIndicator: ShowValueIndicator.never),
    );

    themeData = newThemeData;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('themeColorName', newSeedColorName);
    });
    themeColorName = newSeedColorName;
    notifyListeners();
  }
}
