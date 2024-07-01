import "package:budget_master/components/creation_form/selectors/selector.dart";
import "package:budget_master/components/creation_form/selectors/text_field.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";

class NumberSelector extends CreationFormSelector<double> {
  NumberSelector({super.key, double? initialValue})
      : _textSelector = TextSelector(
          initialValue: initialValue?.toString(),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp("[0-9\\.]"))
          ],
        );

  final TextSelector _textSelector;

  @override
  State<NumberSelector> createState() => _NumberSelectorState();

  @override
  double get value => double.parse(_textSelector.value);
}

class _NumberSelectorState extends State<NumberSelector> {
  @override
  Widget build(BuildContext context) {
    return widget._textSelector;
  }
}
