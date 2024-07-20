import 'package:budget_master/components/creation_form/selectors/selector.dart';
import 'package:budget_master/components/drop_down_button.dart';
import 'package:budget_master/models/enums.dart';
import 'package:budget_master/utils/functions.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TransactionTypeSelector extends CreationFormSelector<TransactionType> {
  TransactionTypeSelector(
      {super.key,
      List<TransactionType>? options,
      super.controller,
      TransactionType? defaultValue})
      : assert(options?.isNotEmpty ?? true),
        options = options ?? TransactionType.values,
        super(
            defaultValue:
                defaultValue ?? options?.first ?? TransactionType.expense);

  final List<TransactionType> options;

  @override
  State<StatefulWidget> createState() => _TransactionTypeSelectorState();
}

class _TransactionTypeSelectorState extends State<TransactionTypeSelector> {
  static const double width = 150;
  static const double height = 35;

  Widget get dropDown {
    return DropDownButton(
      width: width,
      height: height,
      onDrop: (ctx) => showPositionedDialog(
        context: ctx,
        builder: (_, offset) => _SelectorDialog(
          offset: offset,
          selected: widget.controller.value,
          options: widget.options,
          onChange: (acc) => setState(() {
            widget.controller.value = acc;
          }),
        ),
        buttonHeight: height,
      ),
      displayText: widget.controller.value.display,
    );
  }

  Widget rowItem(TransactionType tt) {
    const double selectorSize = 15;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          setState(() {
            widget.controller.value = tt;
          });
        },
        child: Container(
          //width: 150,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
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
                      color: widget.controller.value == tt
                          ? Colors.blue.shade800
                          : null,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              Text(tt.display),
            ],
          ),
        ),
      ),
    );
  }

  Widget get row {
    return SizedBox(
      width: width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: widget.options.map(rowItem).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.options.length > 2 ? dropDown : row;
  }
}

class _SelectorDialog extends StatefulWidget {
  const _SelectorDialog(
      {required this.offset,
      required this.onChange,
      required this.selected,
      required this.options});

  final List<TransactionType> options;
  final Offset offset;
  final void Function(TransactionType) onChange;
  final TransactionType selected;

  @override
  State<_SelectorDialog> createState() => __SelectorDialogState();
}

class __SelectorDialogState extends State<_SelectorDialog> {
  late TransactionType selected;

  @override
  void initState() {
    selected = widget.selected;
    super.initState();
  }

  Widget dropDownItem(TransactionType type) {
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
              children: widget.options.map(dropDownItem).toList(),
            ),
          ),
        )
      ],
    );
  }
}
