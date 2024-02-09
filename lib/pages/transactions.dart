import 'package:budget_master/components/adjustableTable/index.dart';
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
  Map<String, Transaction> get transactions => Map.fromEntries(
        Database.transactions.entries.where(
          (element) =>
              widget.accounts == null ||
              widget.accounts!.contains(element.value.accountPrimary) ||
              widget.accounts!.contains(element.value.accountSecondary),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          padding: const EdgeInsets.only(top: 10, left: 5, right: 5),
          child: AdjustableTable(
            columns: const [
              "Valor",
              "Conta",
              "Data",
              "Descrição",
              "Beneficiário",
              "Categoria(s)",
              //"Saldo",
            ],
            transactions: transactions.values.toList(),
          ),
        ),
        bottomNavigationBar: Container(
          // TODO nova transação
          height: 50,
          color: AppColors.bottomNavigationBackground,
        ),
      ),
    );
  }
}
