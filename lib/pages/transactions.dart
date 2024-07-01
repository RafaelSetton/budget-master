import 'package:budget_master/components/adjustableTable/index.dart';
import 'package:budget_master/models/transaction.dart';
import 'package:budget_master/services/db.dart';
import 'package:budget_master/utils/app_colors.dart';
import 'package:flutter/material.dart';

class TransactionsPage extends StatefulWidget {
  final bool Function(Transaction)? filter;

  const TransactionsPage({super.key, this.filter});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  List<Transaction> get transactions =>
      Database.transactions.getAll(widget.filter);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          padding: const EdgeInsets.only(top: 10, left: 5, right: 5),
          // TODO (Transaction)
          //Scroll horizontal
          child: AdjustableTable(
            //TODO (Transaction)
            //Todas as colunas
            columns: const [
              "Valor",
              "Conta",
              "Data",
              "Descrição",
              "Beneficiário",
              "Categoria(s)",
              //"Saldo",
            ],
            transactions: transactions,
          ),
        ),
        bottomNavigationBar: Container(
          // TODO nova transação
          height: 50,
          color: AppColors.bottomNavigationBackground,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: IconButton(
            onPressed: () {
              debugPrint("Create Transaction");
              // TODO (Transaction)
            },
            icon: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
