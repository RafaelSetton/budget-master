import 'package:budget_master/components/creation_form/selectors/selector.dart';
import 'package:budget_master/components/drop_down_button.dart';
import 'package:budget_master/models/enums.dart';
import 'package:budget_master/utils/functions.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AccountTypeSelector extends CreationFormSelector<AccountType> {
  AccountTypeSelector({super.key, AccountType? selected})
      : _selected = selected ?? AccountType.checking;

  late AccountType _selected;

  @override
  AccountType get value => _selected;

  @override
  State<StatefulWidget> createState() => _AccountTypeSelectorState();
}

class _AccountTypeSelectorState extends State<AccountTypeSelector> {
  static const double width = 150;
  static const double height = 35;

  @override
  Widget build(BuildContext context) {
    return DropDownButton(
      width: width,
      height: height,
      onDrop: (ctx) => showPositionedDialog(
        context: ctx,
        builder: (_, offset) => _SelectorDialog(
          offset: offset,
          selected: widget._selected,
          onChange: (acc) => setState(() {
            widget._selected = acc;
          }),
        ),
        buttonHeight: height,
      ),
      displayText: widget._selected.display,
    );
  }
}

class _SelectorDialog extends StatefulWidget {
  const _SelectorDialog(
      {required this.offset, required this.onChange, required this.selected});

  final Offset offset;
  final void Function(AccountType) onChange;
  final AccountType selected;

  @override
  State<_SelectorDialog> createState() => __SelectorDialogState();
}

class __SelectorDialogState extends State<_SelectorDialog> {
  late AccountType selected;

  @override
  void initState() {
    selected = widget.selected;
    super.initState();
  }

  Widget dropDownItem(AccountType type) {
    const double selectorSize = 15;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          setState(() {
            selected = type;
          });
          widget.onChange(type);
        },
        child: Container(
          width: 150,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border.symmetric(horizontal: BorderSide(width: 0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: selectorSize,
                width: selectorSize,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent),
                  shape: BoxShape.circle,
                ),
                child: FractionallySizedBox(
                  heightFactor: 0.85,
                  widthFactor: 0.85,
                  child: Container(
                    decoration: BoxDecoration(
                      color: selected == type ? Colors.blue.shade800 : null,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              Text(type.display),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: widget.offset.dx,
          top: widget.offset.dy,
          child: SingleChildScrollView(
            child: Column(
              children: AccountType.values.map(dropDownItem).toList(),
            ),
          ),
        )
      ],
    );
  }
}
