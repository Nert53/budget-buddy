import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_finance/constants.dart';

ThemeData mainThemeMode = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: const Color(0x007fb9ae)),
  useMaterial3: true,
  textTheme: GoogleFonts.poppinsTextTheme(),
  scaffoldBackgroundColor: scaffoldBackgroundColor,
  sliderTheme: SliderThemeData(showValueIndicator: ShowValueIndicator.never),
);
