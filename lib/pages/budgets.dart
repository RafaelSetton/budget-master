import 'package:budget_master/components/budget_widget.dart';
import 'package:budget_master/components/selection_bar.dart';
import 'package:budget_master/pages/transactions.dart';
import 'package:budget_master/services/db.dart';
import 'package:flutter/material.dart';

class BudgetsPage extends StatefulWidget {
  const BudgetsPage({super.key});

  @override
  State<BudgetsPage> createState() => _BudgetsPageState();
}

class _BudgetsPageState extends State<BudgetsPage> {
  String selected = Database.budgets.getIDs().first;

  @override
  void initState() {
    super.initState();
  }

  Widget get selectionBar {
    return SelectionBar(
      children: Database.budgets
          .getIDs()
          .map(
            (e) => BudgetWidget(
              id: e,
              selected: selected == e,
              onSelect: () {
                setState(() {
                  selected = e;
                });
              },
            ),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          selectionBar,
          TransactionsPage(
            filter: Database.budgets.get(selected)?.filter ?? (t) => false,
          )
        ],
      ),
    );
  }
}
