import 'package:flutter/material.dart';

// based on material design guidelines
// m3.material.io/foundations/layout/applying-layout/window-size-classes#2b82eea6-5d69-4a73-a7ab-8d9296f5a26d
const compactScreenWidth = 600.0;
const mediumScreenWidth = 840.0;
const largeScreenWidth = 1200.0;

const navigationRailWidth = 111.0;

// UI customisation
const tealColor = Color(0x007fb9ae);
Color warningColor = Colors.orange[600]!;
Color successColor = Colors.green[800]!;
Color outcomeColor = Colors.red[700]!;
Color incomeColor = Colors.lightGreen[800]!;
const scaffoldBackgroundColor = Color.fromARGB(255, 224, 224, 224);

// database
const databaseName = 'personal_finance_db';
const maxNoteLength = 1000;

// url for CNB exchange rate
const exchangeRateUrl =
    'https://www.cnb.cz/cs/financni-trhy/devizovy-trh/kurzy-devizoveho-trhu/kurzy-devizoveho-trhu/denni_kurz.txt';
