import 'package:budget_master/components/highlight_button.dart';
import 'package:budget_master/components/scrolling_text.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DropDownButton<T> extends StatefulWidget {
  DropDownButton(
      {super.key,
      required this.width,
      required this.height,
      required this.onDrop,
      this.selected,
      required this.displayText});

  final double width;
  final double height;
  final Future Function(BuildContext) onDrop;
  T? selected;
  final String displayText;
  bool expanded = false;

  @override
  State<DropDownButton> createState() => _DropDownButtonState<T>();
}

class _DropDownButtonState<T> extends State<DropDownButton> {
  IconData get icon =>
      widget.expanded ? Icons.arrow_drop_down : Icons.arrow_left;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(5),
      ),
      width: widget.width,
      height: widget.height,
      alignment: Alignment.center,
      child: HighlightButton(
        onPressed: () {
          setState(() {
            widget.expanded = true;
          });
          widget.onDrop(context).then((value) => setState(() {
                widget.expanded = false;
              }));
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ScrollingText(widget.displayText, width: widget.width - 55),
            const SizedBox(width: 5),
            Icon(icon),
          ],
        ),
      ),
    );
  }
}
