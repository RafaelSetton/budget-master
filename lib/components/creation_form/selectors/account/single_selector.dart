import 'package:budget_master/components/creation_form/selectors/selector.dart';
import 'package:budget_master/components/highlight_button.dart';
import 'package:budget_master/models/account.dart';
import 'package:budget_master/services/db.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AccountSingleSelector extends CreationFormSelector<Account> {
  AccountSingleSelector({super.key, Account? selected}) {
    _selected = selected ?? Database.accounts.getAll().first;
  }

  @override
  State<AccountSingleSelector> createState() => _AccountSingleSelectorState();

  late Account _selected;

  @override
  Account get value => _selected;
}

class _AccountSingleSelectorState extends State<AccountSingleSelector> {
  static const double width = 150;
  static const double height = 35;

  bool expanded = false;
  IconData get icon => expanded ? Icons.arrow_drop_down : Icons.arrow_left;

  Widget dropDownButton(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: HighlightButton(
        onPressed: () {
          setState(() {
            expanded = true;
          });
          RenderBox rb = context.findRenderObject() as RenderBox;
          Offset offset = rb.localToGlobal(const Offset(0, height));
          showDialog(
            context: context,
            barrierColor: Colors.transparent,
            builder: (ctx) => _SelectorDialog(
              offset: offset,
              selected: widget._selected,
              onChange: (acc) => setState(() {
                widget._selected = acc;
              }),
            ),
          ).then((value) => setState(() {
                expanded = false;
              }));
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(widget._selected.name),
            const SizedBox(width: 5),
            Icon(icon),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(5),
      ),
      width: width,
      height: height,
      alignment: Alignment.center,
      child: dropDownButton(context),
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
