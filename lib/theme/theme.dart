import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData mainThemeMode = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: const Color(0x007fb9ae)),
  useMaterial3: true,
  textTheme: GoogleFonts.poppinsTextTheme(),
  scaffoldBackgroundColor: const Color.fromARGB(255, 224, 224, 224),
);

ThemeData secondThemeMode = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 25, 141, 207)),
  useMaterial3: true,
  textTheme: GoogleFonts.poppinsTextTheme(),
  scaffoldBackgroundColor: const Color.fromARGB(255, 224, 224, 224),
);