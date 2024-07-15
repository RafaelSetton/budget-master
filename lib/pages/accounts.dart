import 'package:budget_master/components/account_widget.dart';
import 'package:budget_master/components/group_widget.dart';
import 'package:budget_master/components/selection_bar.dart';
import 'package:budget_master/pages/transactions.dart';
import 'package:budget_master/services/db.dart';
import 'package:flutter/material.dart';

class AccountsPage extends StatefulWidget {
  const AccountsPage({super.key});

  @override
  State<AccountsPage> createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  String selectedAccount = "";

  void reset() => setState(() {});

  @override
  void initState() {
    Database.notifier.addListener(reset);
    super.initState();
  }

  @override
  void dispose() {
    Database.notifier.removeListener(reset);
    super.dispose();
  }

  GroupWidget groupWidget(String groupID) {
    return GroupWidget(
      groupID,
      onSelect: (selectedId) {
        setState(() => selectedAccount = selectedId);
      },
      selected: selectedAccount,
    );
  }

  AccountWidget accountWidget(e) {
    return AccountWidget(
      data: e,
      onSelect: () {
        setState(() => selectedAccount = e.id);
      },
      selected: selectedAccount == e.id,
    );
  }

  Widget get accountSelection {
    List<GroupWidget> groupWidgets =
        Database.groups.getIDs().map(groupWidget).toList();
    List<AccountWidget> ungroupedAccounts = Database.accounts
        .getAll((element) => element.group.isEmpty)
        .map(accountWidget)
        .toList();

    return SelectionBar(children: [...ungroupedAccounts, ...groupWidgets]);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          accountSelection,
          TransactionsPage(
            filter: (t) =>
                t.accountIn == selectedAccount ||
                t.accountOut == selectedAccount,
          ),
        ],
      ),
    );
  }
}
