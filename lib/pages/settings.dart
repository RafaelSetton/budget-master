import 'package:budget_master/components/creation_form/field.dart';
import 'package:budget_master/components/creation_form/index.dart';
import 'package:budget_master/components/creation_form/selectors/category/single_selector.dart';
import 'package:budget_master/models/category.dart';
import 'package:budget_master/models/model.dart';
import 'package:budget_master/pages/edit/account.dart';
import 'package:budget_master/pages/edit/base.dart';
import 'package:budget_master/pages/edit/budget.dart';
import 'package:budget_master/pages/edit/group.dart';
import 'package:budget_master/services/db.dart';
import 'package:budget_master/services/handlers.dart';
import 'package:budget_master/utils/app_colors.dart';
import 'package:budget_master/components/creation_form/selectors/text_field.dart';
import 'package:budget_master/utils/app_sizes.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Widget buildDialog(BuildContext context) {
    return Dialog(
      surfaceTintColor: Colors.transparent,
      child: Container(
        width: 350,
        height: 200,
        decoration: BoxDecoration(
          color: AppColors.popUpBackground,
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.all(10),
        child: CreationForm(
          fields: [
            CreationFormField(
                title: "Nome", identifier: 'name', selector: TextSelector()),
            CreationFormField(
                title: "Dentro de",
                identifier: 'parent',
                selector: CategorySingleSelector(allowRoots: true)),
          ],
          onSubmit: (data) {
            TransactionCategory? parent = data['parent'];
            final tc =
                TransactionCategory(name: data['name'], parent: parent?.id);
            Database.categories.post(tc);
            Navigator.pop(context);
            setState(() {});
          },
        ),
      ),
    );
  }

  Widget categoryWidget(TransactionCategory category) {
    return Container(
      color: Colors.greenAccent,
      margin: const EdgeInsets.all(5),
      child: Text(category.fullName),
    );
  }

  Widget render<T extends Model>(Handler<T> handler,
      [EditDialog Function(BuildContext, String)? builder]) {
    return SizedBox(
      height: AppSizes.window.height - 100,
      child: SingleChildScrollView(
        child: Column(
          children: handler.asMap.entries
              .map((entry) => GestureDetector(
                    onTap: () {
                      if (builder != null) {
                        showDialog(
                          context: context,
                          builder: (ctx) => builder(ctx, entry.key),
                        ).then((value) => setState(() {}));
                      }
                    },
                    child: Container(
                      color: Colors.amber,
                      margin: const EdgeInsets.all(5),
                      height: 125,
                      width: 200,
                      child: SingleChildScrollView(
                          child: Text(
                              "ID: ${entry.key}\n${entry.value.toString()}")),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Column(
          children: [
            const Text("Configurações"),
            ElevatedButton(
              onPressed: () => showDialog(
                builder: buildDialog,
                context: context,
              ),
              child: const Text("Criar Categoria"),
            ),
            Row(
              children: [
                render(Database.categories),
                render(Database.groups,
                    (ctx, id) => GroupEditDialog(context: ctx, id)),
                render(Database.accounts,
                    (ctx, id) => AccountEditDialog(context: ctx, id)),
                render(Database.budgets,
                    (ctx, id) => BudgetEditDialog(id, context: ctx)),
                render(Database.scheduled),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
