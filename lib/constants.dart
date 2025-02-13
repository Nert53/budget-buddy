import 'package:flutter/material.dart';
import 'package:personal_finance/model/graph.dart';

// based on material design guidelines
// https://m3.material.io/foundations/layout/applying-layout/window-size-classes#2b82eea6-5d69-4a73-a7ab-8d9296f5a26d
const compactScreenWidth = 600.0;
const mediumScreenWidth = 840.0;
const largeScreenWidth = 1200.0;
const navigationRailWidth = 111.0;

// UI customisation
const tealColor = Color(0x007fb9ae);

const maxNoteLength = 1000;

// database
const databaseName = 'personal_finance_db';

// category icons
List<IconData> allCategoryIcons = [
  Icons.shopping_cart_outlined,
  Icons.restaurant_outlined,
  Icons.local_gas_station_outlined,
  Icons.home_outlined,
  Icons.directions_car_outlined,
  Icons.flight_outlined,
  Icons.medication_outlined,
  Icons.school_outlined,
  Icons.phone_outlined,
  Icons.computer_outlined,
  Icons.coffee_outlined,
  Icons.fitness_center_outlined,
  Icons.movie_outlined,
  Icons.videogame_asset_outlined,
  Icons.theater_comedy_outlined,
  Icons.music_note_outlined,
  Icons.pets_outlined,
  Icons.checkroom_outlined,
  Icons.spa_outlined,
  Icons.self_improvement_outlined,
  Icons.train_outlined,
  Icons.weekend_outlined,
  Icons.wine_bar_outlined,
  Icons.local_offer_outlined,
  Icons.casino_outlined,
  Icons.celebration_outlined,
  Icons.bar_chart_outlined,
  Icons.lightbulb_outlined,
  Icons.cell_tower_outlined,
  Icons.devices_other_rounded,
  Icons.subscriptions_outlined,
  Icons.luggage_outlined,
  Icons.local_laundry_service_outlined,
  Icons.handyman_outlined,
  Icons.savings_outlined,
  Icons.atm_outlined,
  Icons.currency_bitcoin_outlined,
  Icons.work_outline_rounded,
  Icons.emoji_events_outlined,
  Icons.real_estate_agent_outlined,
  Icons.business_center_outlined,
  Icons.redeem_outlined,
  Icons.request_quote_outlined,
  Icons.handshake_outlined,
  Icons.more_horiz_outlined,
];

// category colors
List<Color> allCategoryColors = [
  Colors.red[800]!,
  Colors.red,
  Colors.pink,
  Colors.purple,
  Colors.deepPurple,
  Colors.indigo,
  Colors.blue,
  Colors.lightBlue[200]!,
  Colors.cyan,
  Colors.green[800]!,
  Colors.green,
  Colors.lightGreen,
  Colors.lime,
  Colors.yellow,
  Colors.amber,
  Colors.orange,
  Colors.deepOrange,
  Colors.brown,
  Colors.brown[800]!,
  Colors.grey,
  Colors.blueGrey,
  Colors.blueGrey[800]!,
  Colors.black,
];

List<Graph> allGraphs = [
    Graph(id: 1, name: 'Top Categories', icon: Icons.sort, selected: false),
    Graph(
        id: 2,
        name: 'Spendings in time',
        icon: Icons.bar_chart,
        selected: true),
    Graph(
        id: 3,
        name: 'Account balance in time',
        icon: Icons.show_chart,
        selected: false),
    Graph(
        id: 4,
        name: 'Interesting numbers',
        icon: Icons.pin_outlined,
        selected: false),
    Graph(
        id: 5,
        name: 'Income type ratio',
        icon: Icons.pie_chart_outline,
        selected: true),
    Graph(
        id: 6,
        name: 'Spending type ratio',
        icon: Icons.donut_large_outlined,
        selected: false),
  ];
