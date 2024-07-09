import 'package:budget_master/components/creation_form/field.dart';
import 'package:budget_master/components/creation_form/index.dart';
import 'package:budget_master/components/creation_form/selectors/account/multi_selector.dart';
import 'package:budget_master/components/creation_form/selectors/category/multi_selector.dart';
import 'package:budget_master/components/creation_form/selectors/date_field.dart';
import 'package:budget_master/components/creation_form/selectors/single_selection_field.dart';
import 'package:budget_master/models/enums.dart';
import 'package:budget_master/models/transaction.dart';
import 'package:budget_master/services/db.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BarGraphFieldSelector extends StatelessWidget {
  final Function(List<String>, List<String>, DateTime, DateTime, TimePeriod,
      Map<String, Map<int, double>>, int) onUpdate;
  BarGraphFieldSelector({super.key, required this.onUpdate})
      : _categories = [],
        _accounts = [],
        _beginDate = DateTime.now(),
        _endDate = DateTime.now().add(const Duration(days: 1)),
        _interval = TimePeriod.year;

  List<String> _categories;
  List<String> _accounts;
  DateTime _beginDate;
  DateTime _endDate;
  TimePeriod _interval;
  Map<String, Map<int, double>> _data = {};

  int get nBars => getKey(_endDate) - getKey(_beginDate) + 1;

  int getKey(DateTime date) {
    DateTime normalized = DateTime.fromMillisecondsSinceEpoch(
            date.difference(_beginDate).inMilliseconds)
        .toUtc();
    switch (_interval) {
      case TimePeriod.day:
        return date.difference(_beginDate).inDays;
      case TimePeriod.week:
        return date.difference(_beginDate).inDays ~/ 7;
      case TimePeriod.month:
        return (normalized.year - 1970) * 12 + normalized.month;
      case TimePeriod.year:
        return normalized.year - 1970;
    }
  }

  void update(Map<String, dynamic> data) {
    _beginDate = data["Data Inicial"];
    _endDate = data["Data Final"];
    _categories = data["Categorias"];
    _accounts = data["Contas"];
    _interval = TimePeriod.values.byName(data["Intervalo"]);

    assert(
        _endDate.isAfter(_beginDate), "Data final deve ser depois da inicial");
    assert(nBars <= 54, "Acima do limite de 54 intervalos");

    _data = {for (var cat in _categories) cat: {}};
    for (Transaction t in Database.transactions.getAll()) {
      if (!t.isExpenseIncome ||
          t.dateTime.isAfter(_endDate) ||
          t.dateTime.isBefore(_beginDate)) continue;
      for (String cat in t.categories!.keys) {
        if (!_categories.contains(cat)) continue;
        double val = t.categories![cat]!;
        int key = getKey(t.dateTime);
        if (_data[cat]!.containsKey(key)) {
          _data[cat]![key] = _data[cat]![key]! + val;
        } else {
          _data[cat]![key] = val;
        }
      }
    }
    onUpdate(
        _categories, _accounts, _beginDate, _endDate, _interval, _data, nBars);
  }

  @override
  Widget build(BuildContext context) {
    return CreationForm(
      submitText: "Atualizar",
      onSubmit: update,
      fields: [
        CreationFormField(
          title: "Categorias",
          selector: CategoryMultiSelector(),
        ),
        CreationFormField(
          title: "Contas",
          selector: AccountMultiSelector(),
        ),
        CreationFormField(title: "Data Inicial", selector: DateSelector()),
        CreationFormField(title: "Data Final", selector: DateSelector()),
        CreationFormField(
            title: "Intervalo",
            selector: SingleSelector(
              optional: false,
              options: TimePeriod.values.asNameMap().keys.toList(),
            )),
      ],
    );
  }
}
