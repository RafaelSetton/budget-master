import 'package:budget_master/components/creation_form/index.dart';
import 'package:budget_master/components/tab_selector.dart';
import 'package:budget_master/models/account.dart';
import 'package:budget_master/models/account_group.dart';
import 'package:budget_master/models/budget.dart';
import 'package:budget_master/services/db.dart';
import 'package:budget_master/utils/consts.dart';
import 'package:flutter/material.dart';

class CreationPopUp extends StatefulWidget {
  const CreationPopUp({super.key});

  @override
  State<CreationPopUp> createState() => _CreationPopUpState();
}

class _CreationPopUpState extends State<CreationPopUp> {
  void pop() {
    Future.delayed(Durations.long2, Navigator.of(context).pop);
  }

  CreationForm get groupCreationPage {
    return CreationForm(
      onSubmit: (m) {
        Database.groups.post(AccountGroup.fromMap(m));
        pop();
      },
      fields: groupFormFields(),
    );
  }

  CreationForm get accountCreationPage {
    return CreationForm(
      onSubmit: (m) {
        Database.accounts.post(Account.fromMap(m));
        pop();
      },
      fields: accountFormFields(),
    );
  }

  CreationForm get budgetCreationPage {
    return CreationForm(
      onSubmit: (m) {
        Database.budgets.post(Budget.fromMap(m));
        pop();
      },
      fields: budgetFormFields(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      child: TabSelector(
        tabs: [
          TabOption(title: "Grupo", child: groupCreationPage),
          TabOption(title: "Conta", child: accountCreationPage),
          TabOption(title: "Orçamento", child: budgetCreationPage),
        ],
      ),
    );
  }
}
