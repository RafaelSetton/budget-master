import 'package:flutter/material.dart';

class HighlightButton extends StatefulWidget {
  final Color hoverColor;
  final Color defaultColor;
  final void Function()? onSecondaryTap;
  final void Function()? onDoubleTap;
  final void Function() onPressed;
  final Widget child;

  const HighlightButton(
      {super.key,
      this.hoverColor = Colors.transparent,
      this.defaultColor = Colors.transparent,
      this.onSecondaryTap,
      this.onDoubleTap,
      required this.onPressed,
      required this.child});

  @override
  State<HighlightButton> createState() => _HighlightButtonState();
}

class _HighlightButtonState extends State<HighlightButton> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: hover ? widget.hoverColor : widget.defaultColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: GestureDetector(
        onSecondaryTap: widget.onSecondaryTap,
        onDoubleTap: widget.onDoubleTap,
        child: TextButton(
          onHover: (b) {
            setState(() {
              hover = b;
            });
          },
          onPressed: widget.onPressed,
          child: widget.child,
        ),
      ),
    );
  }
}
