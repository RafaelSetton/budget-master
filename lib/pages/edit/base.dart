import 'package:budget_master/components/creation_form/field.dart';
import 'package:budget_master/components/creation_form/index.dart';
import 'package:budget_master/components/deletion_button.dart';
import 'package:budget_master/utils/app_colors.dart';
import 'package:flutter/material.dart';

class EditDialog extends StatefulWidget {
  const EditDialog({
    super.key,
    required this.title,
    required this.fields,
    required this.onSubmit,
    required this.onDelete,
  });

  final String title;
  final List<CreationFormField> fields;
  final void Function(Map<String, dynamic>) onSubmit;
  final void Function() onDelete;

  @override
  State<EditDialog> createState() => _EditDialogState();
}

class _EditDialogState<EP extends EditDialog> extends State<EP> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 450,
        width: 350,
        decoration: BoxDecoration(
          color: AppColors.popUpBackground,
          borderRadius: BorderRadius.circular(25),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(width: 20),
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  DeletionButton(onDelete: widget.onDelete),
                ],
              ),
              CreationForm(
                fields: widget.fields,
                onSubmit: widget.onSubmit,
                submitText: "Salvar",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
