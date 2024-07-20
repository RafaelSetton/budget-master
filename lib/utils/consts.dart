import 'package:budget_master/components/creation_form/field.dart';
import 'package:budget_master/components/creation_form/selectors/account/multi_selector.dart';
import 'package:budget_master/components/creation_form/selectors/account/single_selector.dart';
import 'package:budget_master/components/creation_form/selectors/account_type_selector.dart';
import 'package:budget_master/components/creation_form/selectors/bool_field.dart';
import 'package:budget_master/components/creation_form/selectors/category/multi_selector.dart';
import 'package:budget_master/components/creation_form/selectors/category/single_selector.dart';
import 'package:budget_master/components/creation_form/selectors/color_field.dart';
import 'package:budget_master/components/creation_form/selectors/currency_selector.dart';
import 'package:budget_master/components/creation_form/selectors/date_field.dart';
import 'package:budget_master/components/creation_form/selectors/group_selector.dart';
import 'package:budget_master/components/creation_form/selectors/number_field.dart';
import 'package:budget_master/components/creation_form/selectors/text_field.dart';
import 'package:budget_master/components/creation_form/selectors/time_period_selector.dart';
import 'package:budget_master/components/creation_form/selectors/transaction_type_selector.dart';
import 'package:budget_master/models/account.dart';
import 'package:budget_master/models/account_group.dart';
import 'package:budget_master/models/budget.dart';
import 'package:budget_master/models/enums.dart';
import 'package:budget_master/models/transaction.dart';
import 'package:flutter/material.dart';

List<CreationFormField> groupFormFields([AccountGroup? group]) => [
      CreationFormField(
        title: "Nome",
        identifier: "name",
        selector: TextSelector(
          defaultValue: group?.name,
        ),
      ),
      CreationFormField(
        title: "Cor",
        identifier: "color",
        selector: ColorSelector(
          defaultValue: group?.color,
        ),
      ),
    ];

List<CreationFormField> accountFormFields([Account? account]) => [
      CreationFormField(
        title: "Nome",
        identifier: "name",
        selector: TextSelector(defaultValue: account?.name),
      ),
      CreationFormField(
        title: "Grupo",
        identifier: "group",
        selector: GroupSelector(defaultValue: account?.getGroup),
      ),
      CreationFormField(
        title: "Tipo",
        identifier: "type",
        selector: AccountTypeSelector(defaultValue: account?.type),
      ),
      CreationFormField(
        title: "Moeda",
        identifier: "currency",
        selector: CurrencySelector(defaultValue: account?.currency),
      ),
    ];

List<CreationFormField> budgetFormFields([Budget? budget]) => [
      CreationFormField(
        title: "Nome",
        identifier: "name",
        selector: TextSelector(defaultValue: budget?.name),
      ),
      CreationFormField(
        title: "Valor",
        identifier: "value",
        selector: NumberSelector(defaultValue: budget?.value),
      ),
      CreationFormField(
        title: "Data de Inicio",
        identifier: "begin",
        selector: DateSelector(defaultValue: budget?.begin),
      ),
      CreationFormField(
        title: "Contas",
        identifier: "accounts",
        selector: AccountMultiSelector(defaultValue: budget?.getAccounts),
      ),
      CreationFormField(
        title: "Categorias",
        identifier: "categories",
        selector: CategoryMultiSelector(defaultValue: budget?.getCategories),
      ),
      CreationFormField(
        title: "Intervalo",
        identifier: "period",
        selector: TimePeriodSelector(defaultValue: budget?.period),
      ),
      CreationFormField(
        title: "Rollover",
        identifier: "rollover",
        selector: BoolSelector(defaultValue: budget?.rollover),
      ),
    ];

List<CreationFormField> _transactionBaseFields([Transaction? transaction]) => [
      CreationFormField(
        title: "Descrição",
        identifier: "description",
        selector: TextSelector(defaultValue: transaction?.description),
      ),
      CreationFormField(
        title: "Data",
        identifier: "dateTime",
        selector: DateSelector(defaultValue: transaction?.dateTime),
      ),
    ];

List<CreationFormField> expenseIncomeFormFields([Transaction? transaction]) => [
      CreationFormField(
        title: "Tipo",
        identifier: "type",
        selector: TransactionTypeSelector(
          options: const [TransactionType.expense, TransactionType.income],
          defaultValue: transaction?.type,
        ),
      ),
      ..._transactionBaseFields(transaction),
      CreationFormField(
        title: "Conta",
        identifier: "account",
        selector: AccountSingleSelector(
            defaultValue: transaction?.type == TransactionType.expense
                ? transaction?.getAccountOut
                : transaction?.getAccountIn),
      ),
      CreationFormField(
        title: "Moeda",
        identifier: "currency",
        selector: CurrencySelector(defaultValue: transaction?.currency),
      ),
      CreationFormField(
        title: "Categoria",
        identifier: "category",
        selector: CategorySingleSelector(
            allowRoots: false,
            defaultValue: transaction?.getCategories?.firstOrNull),
      ),
      CreationFormField(
        title: "Valor",
        identifier: "value",
        selector: NumberSelector(defaultValue: transaction?.totalValue),
      ),
      CreationFormField(
        title: "Beneficiário",
        identifier: "payee",
        selector: TextSelector(defaultValue: transaction?.payee),
      ),
    ];

List<CreationFormField> transferFormFields([Transaction? transaction]) => [
      ..._transactionBaseFields(transaction),
      CreationFormField(
        title: "Da Conta",
        identifier: "accountOut",
        selector:
            AccountSingleSelector(defaultValue: transaction?.getAccountOut),
      ),
      CreationFormField(
        title: "Para a Conta",
        identifier: "accountIn",
        selector:
            AccountSingleSelector(defaultValue: transaction?.getAccountIn),
      ),
      CreationFormField(
        title: "Moeda",
        identifier: "currency",
        selector: CurrencySelector(defaultValue: transaction?.currency),
      ),
      CreationFormField(
        title: "Valor",
        identifier: "value",
        selector: NumberSelector(defaultValue: transaction?.totalValue),
      ),
    ];

// TODO (BuySell)
List<CreationFormField> buySellFormFields([Transaction? transaction]) {
  ValueNotifier<double> valueController =
      ValueNotifier(transaction?.totalValue ?? 0);
  ValueNotifier<double> nSharesController =
      ValueNotifier(transaction?.nShares ?? 0);
  ValueNotifier<double> shareValueController =
      ValueNotifier(transaction?.pricePerShare ?? 0);

  valueController.addListener(() {
    shareValueController.value =
        valueController.value / nSharesController.value;
  });
  shareValueController.addListener(() {
    valueController.value =
        shareValueController.value * nSharesController.value;
  });
  nSharesController.addListener(() {
    valueController.value =
        shareValueController.value * nSharesController.value;
  });

  return [
    CreationFormField(
      title: "Tipo",
      identifier: "type",
      selector: TransactionTypeSelector(
        options: const [TransactionType.buy, TransactionType.sell],
        defaultValue: transaction?.type,
      ),
    ),
    ..._transactionBaseFields(transaction),
    CreationFormField(
      title: "Conta",
      identifier: "account",
      selector: AccountSingleSelector(
          defaultValue: transaction?.type == TransactionType.expense
              ? transaction?.getAccountOut
              : transaction?.getAccountIn),
    ),
    CreationFormField(
      title: "Moeda",
      identifier: "currency",
      selector: CurrencySelector(defaultValue: transaction?.currency),
    ),
    CreationFormField(
      title: "Valor total",
      identifier: "totalValue",
      selector: NumberSelector(controller: valueController),
    ),
    CreationFormField(
      title: "Valor por Ativo",
      identifier: "pricePerShare",
      selector: NumberSelector(controller: shareValueController),
    ),
    CreationFormField(
      title: "Número de Ativos",
      identifier: "nShares",
      selector: NumberSelector(controller: nSharesController),
    ),
  ];
}
