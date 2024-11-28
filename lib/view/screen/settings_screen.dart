import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_finance/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: ListView(
        children: <Widget>[
          SizedBox(height: 12.0),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: ListTile(
              leading: Icon(Icons.category_outlined),
              title: Text('Categories editor'),
              onTap: () {},
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.currency_exchange_outlined),
              title: Text('Currency settings'),
              onTap: () {},
            ),
          ),
          Card(
            child: ExpansionTile(
              leading: Icon(Icons.color_lens_outlined),
              title: Text('Color Theme'),
              children: [
                ListTile(
                  leading: Container(
                    width: 30.0,
                    height: 30.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                  ),
                  title: Text('Green'),
                  onTap: () {
                    context.read<ThemeProvider>().setColor(0);
                  },
                ),
                ListTile(
                  leading: Container(
                    width: 30.0,
                    height: 30.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                    ),
                  ),
                  title: Text('Blue'),
                  onTap: () {
                    context.read<ThemeProvider>().setColor(1);
                  },
                ),
                ListTile(
                  leading: Container(
                    width: 30.0,
                    height: 30.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                  ),
                  title: Text('Red'),
                  onTap: () {
                    context.read<ThemeProvider>().setColor(2);
                  },
                ),
              ],
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.bug_report_outlined),
              title: Text('Insert Testing Data'),
              onTap: () {},
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(
                Icons.storage_outlined,
                color: Colors.orange,
              ),
              title: Text(
                'View Database',
                style: TextStyle(color: Colors.orange),
              ),
              onTap: () {
                context.go('/database');
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.ios_share_outlined),
              title: Text('Export Data'),
              onTap: () {},
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.publish_outlined),
              title: Text('Import Data'),
              onTap: () {},
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.info_outlined),
              title: Text('About App'),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}
