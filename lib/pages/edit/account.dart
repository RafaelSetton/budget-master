import 'package:budget_master/models/enums.dart';
import 'package:budget_master/pages/edit/base.dart';
import 'package:budget_master/services/db.dart';
import 'package:budget_master/utils/consts.dart';
import 'package:flutter/material.dart';

class AccountEditDialog extends EditDialog {
  AccountEditDialog(String id, {super.key, required BuildContext context})
      : super(
          fields: accountFormFields(Database.accounts.get(id)),
          onSubmit: (d) {
            Database.accounts.edit(
              id,
              (p1) => p1.copyWith(
                name: d['name'],
                currency: Currency.values.byName(d['currency']),
                type: AccountType.values.byName(d['type']),
                group: d['group'],
              ),
            );
            Future.delayed(Durations.long2, Navigator.of(context).pop);
          },
          onDelete: () {
            Database.accounts.delete(id);
            Future.delayed(Durations.long2, Navigator.of(context).pop);
          },
          title: "Editar Conta",
        );
}
