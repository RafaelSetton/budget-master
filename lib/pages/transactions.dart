import 'package:budget_master/components/transaction_row.dart';
import 'package:budget_master/models/transaction.dart';
import 'package:budget_master/services/db.dart';
import 'package:budget_master/utils/app_colors.dart';
import 'package:flutter/material.dart';

class TransactionsPage extends StatefulWidget {
  final List<String>? accounts;

  const TransactionsPage({super.key, this.accounts});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  late Map<String, Transaction> transactions;

  Widget headerCell(String text) {
    return Container(
      alignment: Alignment.center,
      height: 30,
      decoration: BoxDecoration(
        color: AppColors.icons,
        border: Border.all(color: Colors.black),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  TableRow header() {
    return TableRow(
      children: [
        headerCell("Data"),
        headerCell("Description"),
        headerCell("Value"),
        headerCell("Account"),
        headerCell("Category"),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    transactions = Map.fromEntries(
      Database.transactions.entries.where(
        (element) =>
            widget.accounts == null ||
            widget.accounts!.contains(element.value.accountPrimary) ||
            widget.accounts!.contains(element.value.accountSecondary),
      ),
    );

    return Table(
      defaultColumnWidth: FixedColumnWidth(100),
      children: [header()] +
          transactions.values
              .map((e) => TransactionRow(transaction: e))
              .toList(),
    );
  }
}

/*@override
  Widget build(BuildContext context) {
    transactions = Map.fromEntries(
      Database.transactions.entries.where(
        (element) =>
            widget.accounts == null ||
            widget.accounts!.contains(element.value.accountPrimary) ||
            widget.accounts!.contains(element.value.accountSecondary),
      ),
    );
    List<Widget> children = [header()] +
        transactions.values.map((e) => TransactionRow(transaction: e)).toList();

    return Column(
      children: children,
    );
  }*/