import 'package:budget_master/components/adjustableTable/index.dart';
import 'package:budget_master/models/transaction.dart';
import 'package:budget_master/services/db.dart';
import 'package:budget_master/utils/app_colors.dart';
import 'package:flutter/material.dart';

class TransactionsPage extends StatefulWidget {
  final List<String>? accounts;
  final List<String>? categories;

  const TransactionsPage({super.key, this.accounts, this.categories});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  bool _hasAccount(Transaction transaction) =>
      widget.accounts == null ||
      widget.accounts == [] ||
      widget.accounts!.contains(transaction.accountPrimary) ||
      widget.accounts!.contains(transaction.accountSecondary);

  bool _hasCategory(Transaction transaction) =>
      widget.categories == null ||
      widget.categories == [] ||
      (transaction.categories != null &&
          widget.categories!.any(transaction.categories!.containsKey));

  Map<String, Transaction> get transactions => Map.fromEntries(
        Database.transactions.entries.where(
          (e) => _hasAccount(e.value) && _hasCategory(e.value),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          padding: const EdgeInsets.only(top: 10, left: 5, right: 5),
          // TODO Scroll horizontal
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
