import 'package:budget_master/components/creation_form/selectors/selector.dart';
import 'package:budget_master/utils/app_colors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SingleSelector extends CreationFormSelector {
  SingleSelector({super.key, required this.options}) {
    options.insert(0, "Nenhum");
  }

  final List<String> options;
  String _value = "Nenhum";

  @override
  String get value => _value;

  @override
  State<SingleSelector> createState() => _SingleSelectorState();
}

class _SingleSelectorState extends State<SingleSelector> {
  String value = "Nenhum";

  void onChange(String? value) {
    setState(() {
      this.value = value ?? "Nenhum";
    });
    widget._value = this.value;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: value,
      icon: const Icon(Icons.arrow_drop_down),
      style: TextStyle(color: AppColors.popUpText),
      underline: Container(
        height: 2,
        color: AppColors.popUpDecoration,
      ),
      items: widget.options.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: onChange,
    );
  }
}
