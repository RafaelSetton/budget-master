// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:budget_master/components/account_widget.dart';
import 'package:budget_master/components/highlight_button.dart';
import 'package:budget_master/models/account.dart';
import 'package:budget_master/models/account_group.dart';
import 'package:budget_master/services/db.dart';
import 'package:budget_master/utils/app_colors.dart';
import 'package:budget_master/utils/consts.dart';
import 'package:flutter/material.dart';

class GroupWidget extends StatefulWidget {
  final AccountGroup data;
  final void Function(String) onSelect;
  final String selected;

  const GroupWidget(this.data,
      {super.key, required this.onSelect, required this.selected});

  @override
  // ignore: no_logic_in_create_state
  State<GroupWidget> createState() => _GroupWidgetState(data);
}

class _GroupWidgetState extends State<GroupWidget> {
  AccountGroup data;
  late List<Account> accounts;
  Map<String, bool> hovers = {};
  bool expand = false;

  _GroupWidgetState(this.data) {
    accounts = Database.accountsByGroup(data.id) ?? [];
  }

  void toggle() {
    setState(() {
      expand = !expand;
    });
  }

  Widget get colorBar {
    return Container(
      decoration: BoxDecoration(
        color: data.color,
        borderRadius: const BorderRadius.horizontal(left: Radius.circular(10)),
      ),
      width: 7,
    );
  }

  Widget get header {
    double totalBalance = 0;
    for (var a in accounts) {
      totalBalance += a.balance;
    }
    return HighlightButton(
      onPressed: toggle,
      onSecondaryTap: () {
        //TODO
        print("Edit Group");
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            data.name.length <= 10
                ? data.name
                : "${data.name.substring(0, 9)}...",
            style: TextStyle(
              overflow: TextOverflow.clip,
              color: AppColors.groupTitle,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          Text(
            "R\$ $totalBalance",
            style: TextStyle(color: AppColors.groupSubtitle),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> columnChildren = [header];
    if (expand)
      columnChildren += accounts
          .map((acc) => AccountWidget(
                data: acc,
                onSelect: () => widget.onSelect(acc.id),
                selected: widget.selected == acc.id,
              ))
          .toList();

    return Container(
      margin: const EdgeInsets.all(10),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            colorBar,
            Container(
              padding: const EdgeInsets.all(10),
              width: accGroupWidth,
              decoration: BoxDecoration(
                color: AppColors.groupBackground,
                borderRadius:
                    const BorderRadius.horizontal(right: Radius.circular(10)),
              ),
              child: Column(children: columnChildren),
            ),
          ],
        ),
      ),
    );
  }
}
