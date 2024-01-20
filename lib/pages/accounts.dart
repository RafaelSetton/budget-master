import 'package:budget_master/components/group_widget.dart';
import 'package:budget_master/components/verticalBar.dart';
import 'package:budget_master/models/account.dart';
import 'package:budget_master/models/account_group.dart';
import 'package:budget_master/pages/transactions.dart';
import 'package:budget_master/services/db.dart';
import 'package:budget_master/utils/app_colors.dart';
import 'package:flutter/material.dart';

class AccountsPage extends StatefulWidget {
  const AccountsPage({super.key});

  @override
  State<AccountsPage> createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  final Map<String, AccountGroup> groups;
  final Map<String, Account> accounts;
  String selectedAccount;

  _AccountsPageState()
      : groups = Database.groups,
        accounts = Database.accounts,
        selectedAccount = "";

  Widget accountSelection() {
    List<GroupWidget> groupWidgets = groups.values
        .map(
          (e) => GroupWidget(
            e,
            onSelect: (selectedId) {
              setState(() => selectedAccount = selectedId);
            },
            selected: selectedAccount,
          ),
        )
        .toList();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        border: const VerticalBar(),
      ),
      child: Column(children: groupWidgets),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          accountSelection(),
          TransactionsPage(accounts: [selectedAccount]),
        ],
      ),
    );
  }
}
