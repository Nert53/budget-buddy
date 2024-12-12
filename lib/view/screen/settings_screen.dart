import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_finance/data/database.dart';
import 'package:personal_finance/theme/seed_colors.dart';
import 'package:personal_finance/theme/theme_provider.dart';
import 'package:personal_finance/view_model/settings_viewmodel.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SettingsViewmodel viewModel = context.watch<SettingsViewmodel>();

    if (viewModel.isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
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
                trailing: Icon(Icons.keyboard_arrow_right),
                title: Text('Categories editor'),
                onTap: () {
                  context.go('/edit-categories');
                },
              ),
            ),
            Card(
              child: ExpansionTile(
                leading: Icon(Icons.currency_exchange_outlined),
                title: Text('Currency settings'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      12.0), // makes clikable are rounded as same card
                ),
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: viewModel.currencies.length,
                      itemBuilder: (BuildContext context, int index) {
                        CurrencyItem currentCurrency =
                            viewModel.currencies[index];

                        return ListTile(
                          title: Text(
                              '${currentCurrency.name} (${currentCurrency.symbol})'),
                          trailing: OutlinedButton(
                            child:
                                Text(currentCurrency.exchangeRate.toString()),
                            onPressed: () => {},
                          ),
                          onTap: () {},
                        );
                      }),
                ],
              ),
            ),
            Card(
              child: ExpansionTile(
                leading: Icon(Icons.color_lens_outlined),
                title: Text('Color Theme'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: NamedColor.values.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: Container(
                          width: 30.0,
                          height: 30.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: NamedColor.values[index].color,
                          ),
                        ),
                        title: Text(NamedColor.values[index].name),
                        onTap: () {
                          context.read<ThemeProvider>().setColor(
                              NamedColor.values[index].color,
                              NamedColor.values[index].name);
                        },
                      );
                    },
                  ),
                ],
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
                leading: Icon(
                  Icons.delete_forever_outlined,
                  color: Colors.orange,
                ),
                title: Text('Delete All Transactions',
                    style: TextStyle(color: Colors.orange)),
                onTap: () {},
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
}
