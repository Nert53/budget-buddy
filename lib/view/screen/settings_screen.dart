import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_finance/repository/database.dart';
import 'package:personal_finance/theme/named_colors.dart';
import 'package:personal_finance/theme/theme_provider.dart';
import 'package:personal_finance/utils/functions.dart';
import 'package:personal_finance/view/widget/dialogs/add_currency_dialog.dart';
import 'package:personal_finance/view/widget/dialogs/edit_currency_dialog.dart';
import 'package:personal_finance/view/widget/dialogs/export_transactions_dialog.dart';
import 'package:personal_finance/view_model/settings_viewmodel.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsViewmodel>(builder: (context, viewModel, child) {
      if (viewModel.isLoading) {
        return Center(
          child: CircularProgressIndicator.adaptive(),
        );
      }

      return ListView(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        children: <Widget>[
          SizedBox(height: 8.0),
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
                                return AddCurrencyDialog(viewModel: viewModel);
                              },
                            );
                          },
                        );
                      }

                      CurrencyItem currentCurrency =
                          viewModel.currencies[index];

                      if (currentCurrency.name.toLowerCase() ==
                          'czech koruna') {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  '${currentCurrency.name} (${currentCurrency.symbol})'),
                              Text(
                                'Default currency.',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                '${currentCurrency.name} (${currentCurrency.symbol})'),
                            OutlinedButton(
                              child: Text(
                                'Edit',
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              ),
                              onPressed: () => {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return EditCurrencyDialog(
                                        viewModel: viewModel,
                                        currentCurrency: currentCurrency,
                                      );
                                    })
                              },
                            ),
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
              title: Text('Color theme'),
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
                      title: Text(NamedColor.values[index].name.capitalize()),
                      trailing: context
                                  .read<ThemeProvider>()
                                  .themeColorName
                                  .toLowerCase() ==
                              NamedColor.values[index].name
                          ? Icon(Icons.check)
                          : null,
                      onTap: () {
                        context.read<ThemeProvider>().setColorFromSeed(
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
                Icons.adaptive.share_outlined,
              ),
              title: Text('Export data'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return ExportTransactionsDialog(viewModel: viewModel);
                  },
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(
                Icons.delete_forever_outlined,
                color: Theme.of(context).colorScheme.error,
              ),
              title: Text('Delete all transactions',
                  style: TextStyle(color: Theme.of(context).colorScheme.error)),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Delete all transactions?'),
                      content: Text(
                          'This action will delete all transactions. This action cannot be undone.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancel'),
                        ),
                        FilledButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                                Theme.of(context).colorScheme.error),
                          ),
                          child: Text(
                            'Delete',
                          ),
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
              title: Text('About app'),
              onTap: () {
                showAboutDialog(
                    context: context,
                    applicationVersion: '1.0',
                    applicationName: 'Buget Buddy',
                    children: [
                      Text(
                          'This is a multiplaform personal finance app made on Palacký University as a bachelor thesis by Vojtěch Netrh in 2025.'),
                    ]);
              },
            ),
          ),
        ],
      );
    });
  }
}
