import 'package:budget_master/components/creation_form/selectors/selector.dart';
import 'package:budget_master/components/drop_down_button.dart';
import 'package:budget_master/models/account_group.dart';
import 'package:budget_master/services/db.dart';
import 'package:budget_master/utils/functions.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class GroupSelector extends CreationFormSelector<AccountGroup?> {
  GroupSelector({super.key, AccountGroup? selected, String? selectedId}) {
    assert(selected == null || selectedId == null);
    _selected = selected ?? Database.groups.get(selectedId);
  }

  late AccountGroup? _selected;

  @override
  State<GroupSelector> createState() => _GroupSelectorState();

  @override
  AccountGroup? get value => _selected;
}

class _GroupSelectorState extends State<GroupSelector> {
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
      displayText: widget._selected?.name ?? "Nenhum",
    );
  }
}

class _SelectorDialog extends StatefulWidget {
  const _SelectorDialog(
      {required this.offset, required this.onChange, this.selected});

  final Offset offset;
  final void Function(AccountGroup?) onChange;
  final AccountGroup? selected;

  @override
  State<_SelectorDialog> createState() => __SelectorDialogState();
}

class __SelectorDialogState extends State<_SelectorDialog> {
  late AccountGroup? selected;
  static final AccountGroup nullSimulator =
      AccountGroup(name: "Nenhum", color: Colors.grey);

  @override
  void initState() {
    selected = widget.selected ?? nullSimulator;
    super.initState();
  }

  Widget dropDownItem(AccountGroup acc) {
    const double selectorSize = 15;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          setState(() {
            selected = acc;
          });
          widget.onChange(acc == nullSimulator ? null : acc);
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
                      color: selected == acc ? Colors.blue.shade800 : null,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              Text(acc.name),
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
              children: [
                dropDownItem(nullSimulator),
                ...Database.groups.getAll().map(dropDownItem).toList(),
              ],
            ),
          ),
        )
      ],
    );
  }
}
