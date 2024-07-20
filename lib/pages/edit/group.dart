import 'package:budget_master/pages/edit/base.dart';
import 'package:budget_master/services/db.dart';
import 'package:budget_master/utils/consts.dart';
import 'package:flutter/material.dart';

class GroupEditDialog extends EditDialog {
  GroupEditDialog(String id, {super.key, required BuildContext context})
      : super(
          fields: groupFormFields(Database.groups.get(id)),
          onSubmit: (d) {
            Database.groups.edit(
              id,
              (p1) => p1.copyWith(name: d['name'], color: d['color']),
            );
            Future.delayed(Durations.long2, Navigator.of(context).pop);
          },
          onDelete: () {
            Database.groups.delete(id);
            Future.delayed(Durations.long2, Navigator.of(context).pop);
          },
          title: "Editar Grupo",
        );
}
