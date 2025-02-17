import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_finance/data/database.dart';
import 'package:personal_finance/theme/seed_colors.dart';
import 'package:personal_finance/theme/theme_provider.dart';
import 'package:personal_finance/view/widget/add_currency_dialog.dart';
import 'package:personal_finance/view/widget/edit_currency_dialog.dart';
import 'package:personal_finance/view_model/settings_viewmodel.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsViewmodel>(builder: (context, viewModel, child) {
      if (viewModel.isLoading) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }

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
                  context.push('/edit-categories');
                },
              ),
            ),
            Card(
              child: ExpansionTile(
                leading: Icon(Icons.currency_exchange_outlined),
                title: Text('Currency settings'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      12.0), // makes clikable are rounded same as card
                ),
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: viewModel.currencies.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == viewModel.currencies.length) {
                          return ListTile(
                            leading: Icon(Icons.add),
                            title: Text(
                              'Add new currency',
                              style: TextStyle(fontSize: 14),
                            ),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AddCurrencyDialog(
                                      viewModel: viewModel);
                                },
                              );
                            },
                          );
                        }

                        CurrencyItem currentCurrency =
                            viewModel.currencies[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  '${currentCurrency.name} (${currentCurrency.symbol})'),
                              Row(children: [
                                OutlinedButton(
                                  child: Text(
                                      currentCurrency.exchangeRate.toString()),
                                  onPressed: () => {
                                    if (currentCurrency.name.toLowerCase() ==
                                        'czech koruna')
                                      {
                                        Flushbar(
                                          icon: Icon(Icons.error_outline,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surface),
                                          message:
                                              "You can't change exchange rate for Czech Koruna.",
                                          shouldIconPulse: false,
                                          messageColor: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .error,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          margin: const EdgeInsets.all(12),
                                          duration: Duration(seconds: 4),
                                        ).show(context)
                                      }
                                    else
                                      {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return EditCurrencyDialog(
                                                viewModel: viewModel,
                                                currentCurrency:
                                                    currentCurrency,
                                              );
                                            })
                                      }
                                  },
                                ),
                              ]),
                            ],
                          ),
                        );
                      })
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
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Export Transactions'),
                        content: Text(
                            'All transactions will be exported into .json file.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancel'),
                          ),
                          FilledButton(
                            onPressed: () {
                              viewModel.exportData();
                              Navigator.of(context).pop();
                            },
                            child: Text('Export'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.info_outlined),
                title: Text('About App'),
                onTap: () {
                  //TODO - add dialog about app and its developement
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
