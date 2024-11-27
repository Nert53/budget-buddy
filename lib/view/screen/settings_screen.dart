import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
          ListTile(
            leading: Icon(Icons.currency_exchange_outlined),
            title: Text('Currency settings'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.color_lens_outlined),
            title: Text('Color Theme'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.bug_report_outlined),
            title: Text('Insert Testing Data'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.storage_outlined),
            title: Text('View Database'),
            onTap: () {
              context.go('/database');
            },
          ),
          ListTile(
            leading: Icon(Icons.ios_share_outlined),
            title: Text('Export Data'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.publish_outlined),
            title: Text('Import Data'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.info_outlined),
            title: Text('About App'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
