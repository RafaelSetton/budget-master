import 'package:budget_master/components/creation_form/selectors/selector.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class DateSelector extends CreationFormSelector<DateTime> {
  DateSelector({super.key, super.controller, DateTime? defaultValue})
      : super(defaultValue: defaultValue ?? DateTime.now());

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Future<DateTime?> date = showDatePicker(
          context: context,
          firstDate: DateTime.fromMillisecondsSinceEpoch(0),
          lastDate: DateTime(3000),
          initialDate: widget.controller.value,
        );
        date.then((value) => setState(() {
              if (value != null) widget.controller.value = value;
            }));
      },
      child: Text(DateFormat("dd/MM/yyyy").format(widget.controller.value)),
    );
  }
}
