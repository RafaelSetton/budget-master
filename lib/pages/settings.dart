import 'package:budget_master/components/creation_form/field.dart';
import 'package:budget_master/components/creation_form/index.dart';
import 'package:budget_master/components/creation_form/selectors/category/single_selector.dart';
import 'package:budget_master/models/category.dart';
import 'package:budget_master/services/db.dart';
import 'package:budget_master/utils/app_colors.dart';
import 'package:budget_master/components/creation_form/selectors/text_field.dart';
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
            Database.categories.post(
                TransactionCategory(name: data['name'], parent: parent?.id));
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
            ...Database.categories.getAll().map(categoryWidget).toList(),
          ],
        ),
      ),
    );
  }
}
