import "package:budget_master/components/creation_form/selectors/selector.dart";
import "package:budget_master/components/creation_form/selectors/text_field.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";

class NumberSelector extends CreationFormSelector<double> {
  NumberSelector({super.key, super.controller, double? defaultValue})
      : super(defaultValue: defaultValue ?? 0) {
    _textController = ValueNotifier(value.toString())
      ..addListener(() {
        controller.value = double.tryParse(_textSelector.value) ?? 0;
      });
    _textSelector = TextSelector(
      controller: _textController,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9\\.]"))],
    );
  }

  late final ValueNotifier<String> _textController;
  late final TextSelector _textSelector;

  @override
  State<NumberSelector> createState() => _NumberSelectorState();
}

class _NumberSelectorState extends State<NumberSelector> {
  @override
  Widget build(BuildContext context) {
    return widget._textSelector;
  }
}
