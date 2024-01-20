import 'package:budget_master/components/highlight_button.dart';
import 'package:budget_master/models/account.dart';
import 'package:budget_master/models/account_group.dart';
import 'package:budget_master/services/db.dart';
import 'package:budget_master/utils/app_colors.dart';
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

  Widget colorBar(Color color) {
    return Container(
      decoration: BoxDecoration(
        color: data.color,
        borderRadius: const BorderRadius.horizontal(left: Radius.circular(10)),
      ),
      width: 7,
    );
  }

  Widget header() {
    double totalBalance = 0;
    for (var a in accounts) {
      totalBalance += a.balance;
    }
    return TextButton(
      onPressed: toggle,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text.rich(
            TextSpan(
              text: data.name.length <= 10
                  ? data.name
                  : "${data.name.substring(0, 9)}...",
              style: TextStyle(
                overflow: TextOverflow.clip,
                color: AppColors.title,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
          Text.rich(
            TextSpan(
              style: TextStyle(color: AppColors.subtitle),
              text: "R\$ $totalBalance",
            ),
          ),
        ],
      ),
    );
  }

  Widget accountBuilder(Account acc) {
    return HighlightButton(
      defaultColor:
          widget.selected == acc.id ? AppColors.iconsFocus : Colors.transparent,
      hoverColor: AppColors.iconsFocus,
      onPressed: () => widget.onSelect(acc.id),
      onDoubleTap: () {
        print("Edit");
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 25),
          Text(
            acc.name,
            style: TextStyle(color: AppColors.title),
          ),
          Expanded(
              child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            color: AppColors.icons,
            height: 1,
          )),
          Text(
            "R\$ ${acc.balance}",
            style: TextStyle(
              color: acc.balance >= 0 ? Colors.green : Colors.red,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> columnChildren = [header()];
    if (expand) columnChildren += accounts.map(accountBuilder).toList();

    return Container(
      margin: const EdgeInsets.all(10),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            colorBar(Colors.red),
            Container(
              padding: const EdgeInsets.all(10),
              width: 250,
              decoration: BoxDecoration(
                color: AppColors.secondBackground,
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
