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
        selector: GroupSelector(selectedId: account?.group),
      ),
      CreationFormField(
        title: "Tipo",
        identifier: "type",
        selector: AccountTypeSelector(),
      ),
      CreationFormField(
        title: "Moeda",
        identifier: "currency",
        selector: CurrencySelector(),
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
        selector: AccountMultiSelector(
            selected: budget?.accounts
                .map((e) => Database.accounts.get(e)!)
                .toList()),
      ),
      CreationFormField(
        title: "Categorias",
        identifier: "categories",
        selector: CategoryMultiSelector(
          selected: budget?.categories
              .map((e) => Database.categories.get(e)!)
              .toList(),
        ),
      ),
      CreationFormField(
        title: "Intervalo",
        identifier: "period",
        selector: TimePeriodSelector(),
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
        selector: TransactionTypeSelector(
          options: const [TransactionType.expense, TransactionType.income],
          selected: transaction?.type,
        ),
      ),
      ..._transactionBaseFields(transaction),
      CreationFormField(
        title: "Conta",
        identifier: "account",
        selector: AccountSingleSelector(
            /* selected: transaction?.accountIn ?? transaction?.accountOut */),
      ),
      CreationFormField(
        title: "Moeda",
        identifier: "currency",
        selector: CurrencySelector(),
      ),
      CreationFormField(
        title: "Categoria",
        identifier: "category",
        selector: CategorySingleSelector(),
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
        selector: AccountSingleSelector(
            selected: Database.accounts.get(transaction?.accountOut)),
      ),
      CreationFormField(
        title: "Para a Conta",
        identifier: "accountIn",
        selector: AccountSingleSelector(
            selected: Database.accounts.get(transaction?.accountIn)),
      ),
      CreationFormField(
        title: "Moeda",
        identifier: "currency",
        selector: CurrencySelector(),
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
        selector: TransactionTypeSelector(
          options: const [TransactionType.buy, TransactionType.sell],
          selected: transaction?.type,
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
        selector: CurrencySelector(),
      ),
      CreationFormField(
        title: "Valor",
        identifier: "value",
        selector: NumberSelector(
          initialValue: transaction?.totalValue,
        ),
      ),
    ];
