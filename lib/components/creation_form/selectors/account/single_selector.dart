import 'package:budget_master/components/creation_form/selectors/selector.dart';
import 'package:budget_master/components/drop_down_button.dart';
import 'package:budget_master/models/account.dart';
import 'package:budget_master/services/db.dart';
import 'package:budget_master/utils/functions.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AccountSingleSelector extends CreationFormSelector<Account> {
  AccountSingleSelector({super.key, super.controller, Account? defaultValue})
      : super(defaultValue: defaultValue ?? Database.accounts.getAll().first);

  @override
  State<AccountSingleSelector> createState() => _AccountSingleSelectorState();
}

class _AccountSingleSelectorState extends State<AccountSingleSelector> {
  static const double width = 150;
  static const double height = 35;

  @override
  Widget build(BuildContext context) {
    return DropDownButton(
      width: width,
      height: height,
      onDrop: (ctx) => showPositionedDialog(
        context: ctx,
        builder: (ctx, offset) => _SelectorDialog(
          offset: offset,
          selected: widget.controller.value,
          onChange: (acc) => setState(() {
            widget.controller.value = acc;
          }),
        ),
        buttonHeight: height,
      ),
      displayText: widget.controller.value.name,
    );
  }
}

class _SelectorDialog extends StatefulWidget {
  const _SelectorDialog(
      {required this.offset, required this.onChange, required this.selected});

  final Offset offset;
  final void Function(Account) onChange;
  final Account selected;

  @override
  State<_SelectorDialog> createState() => __SelectorDialogState();
}

class __SelectorDialogState extends State<_SelectorDialog> {
  late Account selected;

  @override
  void initState() {
    selected = widget.selected;
    super.initState();
  }

  Widget dropDownItem(Account acc) {
    const double selectorSize = 15;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          widget.onChange(acc);
          setState(() {
            selected = acc;
          });
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
              children: Database.accounts.getAll().map(dropDownItem).toList(),
            ),
          ),
        )
      ],
    );
  }
}
