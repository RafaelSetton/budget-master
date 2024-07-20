import 'package:budget_master/components/adjustableTable/index.dart';
import 'package:budget_master/components/creation_form/index.dart';
import 'package:budget_master/components/tab_selector.dart';
import 'package:budget_master/models/account.dart';
import 'package:budget_master/models/category.dart';
import 'package:budget_master/models/transaction.dart';
import 'package:budget_master/services/db.dart';
import 'package:budget_master/utils/app_colors.dart';
import 'package:budget_master/utils/consts.dart';
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
              "Conta de Entrada",
              "Conta de Saída",
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
          height: 50,
          color: AppColors.bottomNavigationBackground,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => Dialog(
                  child: TabSelector(
                    tabs: [
                      TabOption(
                        title: "Receita/Despesa",
                        child: CreationForm(
                          fields: expenseIncomeFormFields(),
                          onSubmit: (map) {
                            Database.transactions
                                .post(Transaction.expenseIncome(
                              currency: map['currency'],
                              type: map['type'],
                              dateTime: map['dateTime'],
                              account: (map['account'] as Account).id,
                              categories: {
                                (map['category'] as TransactionCategory).id:
                                    map['value']
                              }, // TODO (Multiple Categories)
                              description: map['description'],
                              payee: map['payee'],
                            ));
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      TabOption(
                        title: "Transferência",
                        child: CreationForm(
                          fields: transferFormFields(),
                          onSubmit: (map) {
                            Database.transactions.post(Transaction.transfer(
                              currency: map['currency'],
                              dateTime: map['dateTime'],
                              accountIn: (map['accountIn'] as Account).id,
                              accountOut: (map['accountOut'] as Account).id,
                              totalValue: map['value'],
                              description: map['description'],
                            ));
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      TabOption(
                        title: "Compra/Venda",
                        child: CreationForm(
                          fields: buySellFormFields(),
                          onSubmit: (map) {
                            Database.transactions
                                .post(Transaction.buySellFromTotal(
                              edited: map['edited'],
                              currency: map['currency'],
                              type: map['type'],
                              dateTime: map['dateTime'],
                              accountIn: map['accountIn'],
                              nShares: map['nShares'],
                              totalValue: map['totalValue'],
                              assetName: map['assetName'],
                              description: map['description'],
                            ));
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
