import 'package:flutter/material.dart';
import 'package:personal_finance/utils/functions.dart';
import 'package:personal_finance/view_model/transactions_viewmodel.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FilterDateSheet extends StatefulWidget {
  final TransactionViewModel viewModel;
  const FilterDateSheet({super.key, required this.viewModel});

  @override
  State<FilterDateSheet> createState() => _FilterDateSheetState();
}

class _FilterDateSheetState extends State<FilterDateSheet> {
  final bool test = true;

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
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
                        fontSize:
                            Theme.of(context).textTheme.titleMedium!.fontSize),
                  ),
                  TextButton(
                    child: Text(
                      'Done',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
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
                      children: List.from(widget.viewModel.periodChoice
                          .map((period) => FilterChip(
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
                                    child: Center(child: Text(period.name))),
                                showCheckmark: false,
                                selected: period.selected,
                                onSelected: (bool selected) {
                                  setState(() {
                                    for (var element
                                        in widget.viewModel.periodChoice) {
                                      element.selected = false;
                                    }

                                    var selectedPeriod = widget
                                        .viewModel.periodChoice
                                        .firstWhere(
                                      (element) => element.name == period.name,
                                    );
                                    selectedPeriod.selected = selected;
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
  }
}
