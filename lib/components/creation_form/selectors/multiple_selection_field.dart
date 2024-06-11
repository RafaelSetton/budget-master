import 'package:budget_master/components/creation_form/selectors/selector.dart';
import 'package:flutter/material.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';

// ignore: must_be_immutable
class MultipleSelector extends CreationFormSelector {
  final List<String> options;
  List<String> _selected;

  MultipleSelector(this.options, {super.key}) : _selected = const [];

  @override
  State<MultipleSelector> createState() => _MultipleSelectorState();

  @override
  get value => _selected;
}

class _MultipleSelectorState extends State<MultipleSelector> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomDropdown.multiSelectSearch(
        items: widget.options,
        onListChanged: (val) => widget._selected = val,
      ),
    );
  }
}
