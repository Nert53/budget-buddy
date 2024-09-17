import 'package:flutter/material.dart';
import 'package:personal_finance/constants.dart';
import 'package:personal_finance/view_model/dashboard_viewmodel.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => DashboardViewmodel(),
        child: const DashboardScreenMain());
  }
}

class DashboardScreenMain extends StatelessWidget {
  const DashboardScreenMain({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<DashboardViewmodel>(context, listen: false);

    final double screenWidth = MediaQuery.of(context).size.width;
    bool wideScreen = screenWidth > laptopScreenWidth;
    double contentWidth =
        screenWidth - (wideScreen ? (navigationRailWidth + 32) : 32);

    return Consumer<DashboardViewmodel>(
      builder: (context, model, child) => Padding(
        padding: const EdgeInsets.only(
            left: 16.0, right: 16.0, top: 16.0, bottom: 16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 200,
                width: contentWidth,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 1),
                      blurRadius: 5.0,
                    ),
                  ],
                ),
                child: Text('Sidebar'),
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Container(
                    height: 200,
                    width: contentWidth / 2 - 8,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainer,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(16.0)),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 1),
                          blurRadius: 5.0,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Balance'),
                        Expanded(
                            child:
                                Center(child: Text('${model.accountBalance}'))),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Container(
                    height: 200,
                    width: contentWidth / 2 - 8,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainer,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(16.0)),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 1),
                          blurRadius: 5.0,
                        ),
                      ],
                    ),
                    child: Text('Content'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
