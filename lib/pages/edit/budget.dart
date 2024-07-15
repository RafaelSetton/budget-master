import 'package:budget_master/models/account.dart';
import 'package:budget_master/models/category.dart';
import 'package:budget_master/pages/edit/base.dart';
import 'package:budget_master/services/db.dart';
import 'package:budget_master/utils/consts.dart';
import 'package:flutter/material.dart';

class BudgetEditDialog extends EditDialog {
  BudgetEditDialog(String id, {super.key, required BuildContext context})
      : super(
          fields: budgetFormFields(Database.budgets.get(id)),
          onSubmit: (d) {
            Database.budgets.edit(
              id,
              (p1) => p1.copyWith(
                name: d['name'],
                value: d['value'],
                accounts:
                    (d['accounts'] as List<Account>).map((e) => e.id).toList(),
                begin: d['begin'],
                categories: (d['categories'] as List<TransactionCategory>)
                    .map((e) => e.id)
                    .toList(),
                period: d['period'],
                rollover: d['rollover'],
              ),
            );
            Future.delayed(Durations.long2, Navigator.of(context).pop);
          },
          onDelete: () {
            Database.budgets.delete(id);
            Future.delayed(Durations.long2, Navigator.of(context).pop);
          },
          title: "Editar Orçamento",
        );
}
