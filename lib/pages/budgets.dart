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
  String selected = Database.budgets.keys.first;

  @override
  void initState() {
    super.initState();
  }

  Widget get selectionBar {
    return SelectionBar(
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
            accounts: Database.budgets[selected]?.accounts,
            categories: Database.budgets[selected]?.categories,
          )
        ],
      ),
    );
  }
}
