import 'package:budget_master/components/creation_form/field.dart';
import 'package:budget_master/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CreationForm extends StatefulWidget {
  const CreationForm({super.key, required this.fields, required this.onSubmit});

  final List<CreationFormField> fields;
  final void Function() onSubmit;

  @override
  State<CreationForm> createState() => _CreationFormState();
}

class _CreationFormState extends State<CreationForm> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ...widget.fields,
      ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(AppColors.popUpButton)),
        onPressed: () {},
        child: Text(
          "Criar",
          style: TextStyle(color: AppColors.popUpButtonText),
        ),
      ),
    ]);
  }
}
