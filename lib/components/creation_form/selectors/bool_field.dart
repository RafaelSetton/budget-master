import 'package:budget_master/components/creation_form/selectors/selector.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BoolSelector extends CreationFormSelector {
  BoolSelector({super.key, super.controller, super.defaultValue = false});

  @override
  State<BoolSelector> createState() => _BoolSelectorState();
}

class _BoolSelectorState extends State<BoolSelector> {
  static const Color _activeColor = Colors.grey;
  static const Color _defaultColor = Colors.white;

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };

    if (states.any(interactiveStates.contains)) {
      return _activeColor;
    }
    return _defaultColor;
  }

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      checkColor: Colors.black,
      fillColor: MaterialStateColor.resolveWith(getColor),
      value: widget.controller.value,
      onChanged: (bool? value) {
        setState(() {
          widget.controller.value = value!;
        });
      },
    );
  }
}
