import 'package:flutter/material.dart';
import 'package:personal_finance/model/time_period.dart';
import 'package:personal_finance/utils/functions.dart';
import 'package:personal_finance/view_model/transactions_viewmodel.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class FilterDateSheet extends StatefulWidget {
  final TimePeriod currentSelectedPeriod;
  const FilterDateSheet({super.key, required this.currentSelectedPeriod});

  @override
  State<FilterDateSheet> createState() => _FilterDateSheetState();
}

class _FilterDateSheetState extends State<FilterDateSheet> {
  late String selectedPeriodName;

  @override
  void initState() {
    selectedPeriodName = widget.currentSelectedPeriod.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionViewModel>(
      builder: (context, viewModel, child) {
        return BottomSheet(
          onClosing: () {
            // todo
          },
          builder: (BuildContext context) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('                '),
                      Text(
                        'Select period',
                        style: TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .fontSize),
                      ),
                      TextButton(
                        child: Text(
                          'Apply',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          viewModel.updateSelectedPeriod(selectedPeriodName);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: [
                        Wrap(
                          spacing: 5.0,
                          runSpacing: 5.0,
                          children: List.from(viewModel.periodChoice
                              .map((period) => ChoiceChip(
                                    avatar: period.icon.contains('.svg')
                                        ? SvgPicture.asset(
                                            period.icon,
                                            height: 28,
                                            width: 28,
                                            colorFilter: ColorFilter.mode(
                                                period.selected
                                                    ? Colors.black
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                BlendMode.srcIn),
                                          )
                                        : Icon(
                                            convertIconCodePointToIcon(
                                              int.parse(period.icon),
                                            ),
                                            size: 28,
                                          ),
                                    label: SizedBox(
                                        height: 52,
                                        width: 90,
                                        child:
                                            Center(child: Text(period.name))),
                                    showCheckmark: false,
                                    selected: period.name == selectedPeriodName,
                                    onSelected: (bool selected) {
                                      setState(() {
                                        selectedPeriodName = period.name;
                                      });
                                    },
                                  ))
                              .toList()),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
