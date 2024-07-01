import 'package:budget_master/components/creation_form/field.dart';
import 'package:budget_master/components/creation_form/selectors/bool_field.dart';
import 'package:budget_master/components/creation_form/selectors/color_field.dart';
import 'package:budget_master/components/creation_form/selectors/date_field.dart';
import 'package:budget_master/components/creation_form/selectors/multiple_selection_field.dart';
import 'package:budget_master/components/creation_form/selectors/number_field.dart';
import 'package:budget_master/components/creation_form/selectors/single_selection_field.dart';
import 'package:budget_master/components/creation_form/selectors/text_field.dart';
import 'package:budget_master/models/account.dart';
import 'package:budget_master/models/account_group.dart';
import 'package:budget_master/models/budget.dart';
import 'package:budget_master/models/enums.dart';
import 'package:budget_master/models/transaction.dart';
import 'package:budget_master/services/db.dart';

List<CreationFormField> groupFormFields([AccountGroup? group]) => [
      CreationFormField(
        title: "Nome",
        identifier: "name",
        selector: TextSelector(
          initialValue: group?.name,
        ),
      ),
      CreationFormField(
        title: "Cor",
        identifier: "color",
        selector: ColorSelector(
          initialColor: group?.color,
        ),
      ),
    ];

List<CreationFormField> accountFormFields([Account? account]) => [
      CreationFormField(
        title: "Nome",
        identifier: "name",
        selector: TextSelector(
          initialValue: account?.name,
        ),
      ),
      CreationFormField(
        title: "Grupo",
        identifier: "group",
        selector: SingleSelector(
          options: Database.groups.getIDs(),
          selectedOption: account?.group,
        ),
      ),
      CreationFormField(
        title: "Tipo",
        identifier: "type",
        selector: SingleSelector(
          optional: false,
          options: AccountType.values.asNameMap().keys.toList(),
        ),
      ),
      CreationFormField(
        title: "Moeda",
        identifier: "currency",
        selector: SingleSelector(
          optional: false,
          options: Currency.values.asNameMap().keys.toList(),
        ),
      ),
    ];

List<CreationFormField> budgetFormFields([Budget? budget]) => [
      CreationFormField(
        title: "Nome",
        identifier: "name",
        selector: TextSelector(initialValue: budget?.name),
      ),
      CreationFormField(
        title: "Valor",
        identifier: "value",
        selector: NumberSelector(initialValue: budget?.value),
      ),
      CreationFormField(
        title: "Data de Inicio",
        identifier: "begin",
        selector: DateSelector(initialDate: budget?.begin),
      ),
      CreationFormField(
        title: "Contas",
        identifier: "accounts",
        selector: MultipleSelector(
          Database.accounts.getAll().map((e) => e.id).toList(),
          display: (id) => Database.accounts.get(id)!.name,
          preSelected: budget?.accounts,
        ),
      ),
      CreationFormField(
        title: "Categorias",
        identifier: "categories",
        selector: MultipleSelector(
          const ["cat1", "cat2", "c3"],
          preSelected: budget?.categories,
        ),
      ),
      CreationFormField(
        title: "Intervalo",
        identifier: "period",
        selector: SingleSelector(
          options: TimePeriod.values.asNameMap().keys.toList(),
          optional: false,
          selectedOption: budget?.period.name,
        ),
      ),
      CreationFormField(
        title: "Rollover",
        identifier: "rollover",
        selector: BoolSelector(isChecked: budget?.rollover),
      ),
    ];

List<CreationFormField> _transactionBaseFields([Transaction? transaction]) => [
      CreationFormField(
        title: "Descrição",
        identifier: "description",
        selector: TextSelector(initialValue: transaction?.description),
      ),
      CreationFormField(
        title: "Data",
        identifier: "dateTime",
        selector: DateSelector(initialDate: transaction?.dateTime),
      ),
    ];

List<CreationFormField> expenseIncomeFormFields([Transaction? transaction]) => [
      CreationFormField(
        title: "Tipo",
        identifier: "type",
        selector: SingleSelector(
          options: const ['expense', 'income'],
          optional: false,
          selectedOption: transaction?.type.name,
        ),
      ),
      ..._transactionBaseFields(transaction),
      CreationFormField(
        title: "Conta",
        identifier: "account",
        selector: TextSelector(
            initialValue: transaction?.accountIn ?? transaction?.accountOut),
      ),
      CreationFormField(
        title: "Moeda",
        identifier: "currency",
        selector: SingleSelector(
          optional: false,
          options: Currency.values.asNameMap().keys.toList(),
        ),
      ),
      CreationFormField(
        title: "Categoria",
        identifier: "category",
        selector: SingleSelector(
          options: const ["cat1", "cat2", "c3"],
          selectedOption: transaction?.categories?.keys.first,
        ),
      ),
      CreationFormField(
        title: "Valor",
        identifier: "value",
        selector: NumberSelector(
          initialValue: transaction?.totalValue,
        ),
      ),
    ];

List<CreationFormField> transferFormFields([Transaction? transaction]) => [
      ..._transactionBaseFields(transaction),
      CreationFormField(
        title: "Da Conta",
        identifier: "accountOut",
        selector: TextSelector(initialValue: transaction?.accountOut),
      ),
      CreationFormField(
        title: "Para a Conta",
        identifier: "accountIn",
        selector: TextSelector(initialValue: transaction?.accountIn),
      ),
      CreationFormField(
        title: "Moeda",
        identifier: "currency",
        selector: SingleSelector(
          optional: false,
          options: Currency.values.asNameMap().keys.toList(),
        ),
      ),
      CreationFormField(
        title: "Valor",
        identifier: "value",
        selector: NumberSelector(
          initialValue: transaction?.totalValue,
        ),
      ),
    ];

// TODO (BuySell)
List<CreationFormField> buySellFormFields([Transaction? transaction]) => [
      CreationFormField(
        title: "Tipo",
        identifier: "type",
        selector: SingleSelector(
          options: const ['buy', 'sell'],
          optional: false,
          selectedOption: transaction?.type.name,
        ),
      ),
      ..._transactionBaseFields(transaction),
      CreationFormField(
        title: "Conta",
        identifier: "account",
        selector: TextSelector(
            initialValue: transaction?.accountIn ?? transaction?.accountOut),
      ),
      CreationFormField(
        title: "Moeda",
        identifier: "currency",
        selector: SingleSelector(
          optional: false,
          options: Currency.values.asNameMap().keys.toList(),
        ),
      ),
      CreationFormField(
        title: "Categoria",
        identifier: "category",
        selector: SingleSelector(
          options: const ["cat1", "cat2", "c3"],
          selectedOption: transaction?.categories?.keys.first,
        ),
      ),
      CreationFormField(
        title: "Valor",
        identifier: "value",
        selector: NumberSelector(
          initialValue: transaction?.totalValue,
        ),
      ),
    ];
