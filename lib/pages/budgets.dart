import 'package:budget_master/components/budget_widget.dart';
import 'package:budget_master/components/vertical_bar.dart';
import 'package:budget_master/services/db.dart';
import 'package:budget_master/utils/app_colors.dart';
import 'package:flutter/material.dart';

class BudgetsPage extends StatefulWidget {
  const BudgetsPage({super.key});

  @override
  State<BudgetsPage> createState() => _BudgetsPageState();
}

class _BudgetsPageState extends State<BudgetsPage> {
  String? selected;

  Widget selection() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        border: const VerticalBar(),
      ),
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: Database.budgets.values
            .map(
              (e) => BudgetWidget(
                data: e,
                selected: selected == e.id,
                onSelect: () {
                  setState(() {
                    selected = e.id;
                  });
                },
              ),
            )
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          selection(),
        ],
      ),
    );
  }
}
