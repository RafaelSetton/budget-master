import 'package:budget_master/components/creation_form/field.dart';
import 'package:budget_master/models/account.dart';
import 'package:budget_master/models/category.dart';
import 'package:budget_master/models/enums.dart';
import 'package:budget_master/models/transaction.dart';
import 'package:budget_master/pages/edit/base.dart';
import 'package:budget_master/services/db.dart';
import 'package:budget_master/utils/consts.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class TransactionEditDialog extends EditDialog {
  static List<CreationFormField> getFields(String id) {
    Transaction t = Database.transactions.get(id)!;
    if (t.isExpenseIncome) {
      return expenseIncomeFormFields(t);
    } else if (t.isTransfer) {
      return transferFormFields(t);
    } else {
      return buySellFormFields(t);
    }
  }

  static Transaction edit(Transaction t, Map<String, dynamic> data) {
    DateTime edited = DateTime.now();
    TransactionType type =
        t.isTransfer ? TransactionType.transfer : data['type'];
    DateTime dateTime = data['dateTime'];
    String description = data['description'];

    String? accountIn;
    String? accountOut;
    String? assetName;
    Currency? currency;
    double? nShares;
    double? pricePerShare;
    double? totalValue;
    Map<String, double>? categories;

    if (t.isExpenseIncome) {
      if (t.type == TransactionType.expense) {
        accountOut = (data['account'] as Account).id;
      } else {
        accountIn = (data['account'] as Account).id;
      }
      currency = data['currency'];
      categories = {
        (data['category'] as TransactionCategory).id: data['value']
      };
      totalValue = categories.values.sum;
    } else if (t.isTransfer) {
      accountIn = (data['accountIn'] as Account).id;
      accountOut = (data['accountOut'] as Account).id;
      currency = data['currency'];
      totalValue = data['value'];
    } else {
      // TODO (BuySell)
    }

    return t.copyWith(
      accountIn: accountIn,
      accountOut: accountOut,
      assetName: assetName,
      currency: currency,
      dateTime: dateTime,
      description: description,
      edited: edited,
      nShares: nShares,
      pricePerShare: pricePerShare,
      totalValue: totalValue,
      type: type,
      categories: categories,
    );
  }

  TransactionEditDialog(String id, {super.key, required BuildContext context})
      : super(
          fields: getFields(id),
          onSubmit: (d) {
            Database.transactions.edit(id, (e) => edit(e, d));
            Future.delayed(Durations.long2, Navigator.of(context).pop);
          },
          onDelete: () {
            Database.transactions.delete(id);
            Future.delayed(Durations.long2, Navigator.of(context).pop);
          },
          title: "Editar Transação",
        );
}
