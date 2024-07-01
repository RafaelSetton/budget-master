import 'package:budget_master/components/creation_form/field.dart';
import 'package:budget_master/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CreationForm extends StatefulWidget {
  const CreationForm({
    super.key,
    required this.fields,
    required this.onSubmit,
    this.submitText = "Criar",
  });

  final String submitText;
  final List<CreationFormField> fields;
  final void Function(Map<String, dynamic>) onSubmit;

  @override
  State<CreationForm> createState() => _CreationFormState();
}

class _CreationFormState extends State<CreationForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...widget.fields,
        ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(AppColors.popUpButton)),
          onPressed: () => widget.onSubmit(
              {for (var f in widget.fields) f.identifier: f.selector.value}),
          child: Text(
            widget.submitText,
            style: TextStyle(color: AppColors.popUpButtonText),
          ),
        ),
      ],
    );
  }
}
