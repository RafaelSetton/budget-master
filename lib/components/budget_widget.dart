import 'package:budget_master/components/highlight_button.dart';
import 'package:budget_master/components/progress_bar.dart';
import 'package:budget_master/models/budget.dart';
import 'package:budget_master/models/transaction.dart';
import 'package:budget_master/pages/edit/budget.dart';
import 'package:budget_master/services/db.dart';
import 'package:budget_master/utils/app_colors.dart';
import 'package:budget_master/utils/app_sizes.dart';
import 'package:flutter/material.dart';

class BudgetWidget extends StatefulWidget {
  const BudgetWidget(
      {super.key,
      this.selected = false,
      required this.onSelect,
      required this.id});

  final String id;
  final bool selected;
  final void Function() onSelect;

  @override
  State<BudgetWidget> createState() => _BudgetWidgetState();
}

class _BudgetWidgetState extends State<BudgetWidget> {
  late Budget data;

  @override
  void initState() {
    data = Database.budgets.get(widget.id)!;
    super.initState();
  }

  Color get defaultColor =>
      widget.selected ? AppColors.iconsFocus : Colors.transparent;

  Widget get header {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          data.name,
          style: TextStyle(color: AppColors.groupTitle),
        ),
        Expanded(
            child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          color: AppColors.icons,
          height: 1,
        )),
        Text(
          "R\$ ${data.value}",
          style: TextStyle(
            color: data.value >= 0 ? Colors.green : Colors.red,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  double get valueUsed {
    double v = 0;
    for (Transaction t in Database.transactions.getAll(data.filter)) {
      for (String c in t.categories!.keys) {
        if (data.categories.contains(c)) v += t.categories![c]!;
      }
    }

    return v;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.accGroupWidth,
      margin: const EdgeInsets.all(10),
      child: HighlightButton(
        defaultColor: defaultColor,
        hoverColor: AppColors.iconsFocus,
        onPressed: widget.onSelect,
        onSecondaryTap: () {
          showDialog(
            context: context,
            builder: (ctx) => BudgetEditDialog(widget.id, context: context),
          ).then((value) => setState(() {
                data = Database.budgets.get(widget.id)!;
              }));
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              header,
              ProgressBar(
                progress: valueUsed / data.value,
                mark: DateTime.now().difference(data.begin).inDays /
                    data.durationInDays,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
