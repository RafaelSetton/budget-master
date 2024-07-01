import 'package:budget_master/components/creation_form/selectors/selector.dart';
import 'package:flutter/material.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';

// ignore: must_be_immutable
class MultipleSelector extends CreationFormSelector<List<String>> {
  final List<String> options;
  late List<String> _selected;
  late final Map<String, String> pairs;

  MultipleSelector(this.options,
      {super.key,
      List<String>? preSelected,
      String Function(String)? display}) {
    display ??= (e) => e;
    _selected = preSelected?.map(display).toList() ?? [];
    pairs = Map.fromEntries(options.map((e) => MapEntry(display!(e), e)));
  }

  @override
  State<MultipleSelector> createState() => _MultipleSelectorState();

  @override
  List<String> get value => _selected.map((e) => pairs[e]!).toList();
}

class _MultipleSelectorState extends State<MultipleSelector> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomDropdown.multiSelectSearch(
        initialItems: widget._selected,
        items: widget.pairs.keys.toList(),
        onListChanged: (val) => widget._selected = val,
      ),
    );
  }
}
