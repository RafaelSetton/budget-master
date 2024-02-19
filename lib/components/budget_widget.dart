import 'package:budget_master/components/highlight_button.dart';
import 'package:budget_master/components/progress_bar.dart';
import 'package:budget_master/models/budget.dart';
import 'package:budget_master/utils/app_colors.dart';
import 'package:budget_master/utils/consts.dart';
import 'package:flutter/material.dart';

class BudgetWidget extends StatefulWidget {
  const BudgetWidget(
      {super.key,
      this.selected = false,
      required this.data,
      required this.onSelect});

  final bool selected;
  final Budget data;
  final void Function() onSelect;

  @override
  State<BudgetWidget> createState() => _BudgetWidgetState();
}

class _BudgetWidgetState extends State<BudgetWidget> {
  Color get defaultColor =>
      widget.selected ? AppColors.iconsFocus : Colors.transparent;

  Widget get header => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            widget.data.name,
            style: TextStyle(color: AppColors.groupTitle),
          ),
          Expanded(
              child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            color: AppColors.icons,
            height: 1,
          )),
          Text(
            "R\$ ${widget.data.value}",
            style: TextStyle(
              color: widget.data.value >= 0 ? Colors.green : Colors.red,
              fontSize: 14,
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: accGroupWidth,
      margin: const EdgeInsets.all(10),
      child: HighlightButton(
        defaultColor: defaultColor,
        hoverColor: AppColors.iconsFocus,
        onPressed: widget.onSelect,
        onDoubleTap: () {}, //TODO edit
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              header,
              ProgressBar(
                progress: 50 / widget.data.value,
                mark: DateTime.now().difference(widget.data.begin).inDays /
                    widget.data.duration.inDays,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
