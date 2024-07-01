import 'package:budget_master/components/creation_form/selectors/selector.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class DateSelector extends CreationFormSelector<DateTime> {
  DateSelector({super.key, DateTime? initialDate})
      : _date = initialDate ?? DateTime.now();

  @override
  State<DateSelector> createState() => _DateSelectorState();

  DateTime _date;

  @override
  DateTime get value => _date;
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
          initialDate: widget._date,
        );
        date.then((value) => setState(() {
              if (value != null) widget._date = value;
            }));
      },
      child: Text(DateFormat("dd/MM/yyyy").format(widget._date)),
    );
  }
}
