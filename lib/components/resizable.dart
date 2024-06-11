import 'dart:math';

import 'package:flutter/material.dart';

class Resizable extends StatefulWidget {
  Resizable(
      {super.key,
      required this.child,
      this.minWidth = 100,
      this.maxWidth = 300,
      this.resizeRegionWidth = 7,
      this.height,
      double? initialWidth,
      this.changeRate = 1})
      : initialWidth = initialWidth ?? (minWidth + maxWidth) / 2 {
    assert(maxWidth > minWidth, "maxWidth não é maior que minWidth");
    assert(minWidth <= this.initialWidth && this.initialWidth <= maxWidth,
        "Não satisfaz minWidth <= initialWidth <= maxWidth");
  }

  final Widget child;
  final double resizeRegionWidth;
  final double? height;
  final double initialWidth;
  final double changeRate;
  final double minWidth;
  final double maxWidth;

  @override
  State<Resizable> createState() => _ResizableState();
}

class _ResizableState extends State<Resizable> {
  late double width;
  double _initX = 0;
  double _dx = 0;

  @override
  void initState() {
    width = widget.initialWidth;
    super.initState();
  }

  void _handleStart(DragStartDetails details) {
    setState(() {
      _initX = details.globalPosition.dx;
    });
  }

  void _handleUpdate(DragUpdateDetails details) {
    _dx = details.globalPosition.dx - _initX;
    _initX = details.globalPosition.dx;
    double newWidth = width + _dx * widget.changeRate;
    setState(() {
      width = min(widget.maxWidth, max(newWidth, widget.minWidth));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: width,
          child: widget.child,
        ),
        MouseRegion(
          cursor: SystemMouseCursors.resizeColumn,
          child: GestureDetector(
            onPanStart: _handleStart,
            onPanUpdate: _handleUpdate,
            child: Container(
              width: widget.resizeRegionWidth,
              height: widget.height,
              color: Colors.transparent,
            ),
          ),
        )
      ],
    );
  }
}
