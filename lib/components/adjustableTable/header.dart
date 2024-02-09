import 'dart:math';

import 'package:budget_master/utils/app_colors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AdjustableHeaderCell extends StatefulWidget {
  AdjustableHeaderCell(
      {required this.text, required this.onChange, required this.index})
      : super(key: Key(text));

  final void Function() onChange;
  final String text;
  double width = 150;
  int index;

  @override
  State<AdjustableHeaderCell> createState() => _AdjustableHeaderCellState();
}

class _AdjustableHeaderCellState extends State<AdjustableHeaderCell> {
  double _initX = 0;
  double _dx = 0;

  static const TextStyle _style = TextStyle(fontSize: 15);
  static const double _resizeRegionWidth = 5;
  static final _bgColor = AppColors.icons;
  static const double _height = 30;

  double get minWidth =>
      15; /*TextPainter(
          text: TextSpan(text: widget.text, style: _style),
          maxLines: 1,
          textDirection: TextDirection.ltr)
      .width;*/

  void _handleStart(DragStartDetails details) {
    setState(() {
      _initX = details.globalPosition.dx;
    });
  }

  void _handleUpdate(DragUpdateDetails details) {
    _dx = details.globalPosition.dx - _initX;
    _initX = details.globalPosition.dx;
    setState(() {
      widget.width += max(_dx, minWidth - widget.width);
    });
    widget.onChange();
  }

  Widget mainRegion() {
    return ReorderableDragStartListener(
      index: widget.index,
      child: Container(
        width: widget.width - _resizeRegionWidth,
        height: _height,
        color: _bgColor,
        child: Text(widget.text, style: _style),
      ),
    );
  }

  Widget resizeRegion() {
    return MouseRegion(
      cursor: SystemMouseCursors.resizeColumn,
      child: GestureDetector(
        onPanStart: _handleStart,
        onPanUpdate: _handleUpdate,
        child: Container(
          width: _resizeRegionWidth,
          height: _height,
          decoration: BoxDecoration(
            color: _bgColor,
            border: const Border.symmetric(vertical: BorderSide(width: 1.5)),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        mainRegion(),
        resizeRegion(),
      ],
    );
  }
}
