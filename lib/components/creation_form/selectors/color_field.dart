import 'package:budget_master/components/creation_form/selectors/selector.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ColorSelector extends CreationFormSelector<MaterialColor> {
  ColorSelector({super.key, super.controller, super.defaultValue = Colors.red});

  @override
  State<ColorSelector> createState() => _ColorSelectorState();
}

class _ColorSelectorState extends State<ColorSelector> {
  void onChange(MaterialColor value) {
    setState(() {
      widget.controller.value = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) => showDialog(
        context: context,
        barrierColor: Colors.transparent,
        builder: (context) => _ColorDialog(
          details: details,
          selected: widget.controller.value,
          onChange: onChange,
        ),
      ),
      child: Icon(
        Icons.square,
        color: widget.controller.value,
      ),
    );
  }
}

// ignore: must_be_immutable
class _ColorDialog extends StatefulWidget {
  _ColorDialog(
      {required this.details, required this.selected, required this.onChange});

  final TapDownDetails details;
  final Function(MaterialColor) onChange;
  MaterialColor selected;

  @override
  State<_ColorDialog> createState() => __ColorDialogState();
}

class __ColorDialogState extends State<_ColorDialog> {
  Widget itemBuilder(BuildContext context, int index) {
    MaterialColor color = Colors.primaries[index];
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.selected = color;
        });
        widget.onChange(color);
      },
      child: Container(
        decoration: BoxDecoration(
          color: color == widget.selected ? Colors.white30 : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Container(
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
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
          left: widget.details.globalPosition.dx,
          top: widget.details.globalPosition.dy,
          child: Container(
            width: 300,
            height: 155,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(5),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6),
              itemBuilder: itemBuilder,
              itemCount: Colors.primaries.length,
            ),
          ),
        ),
      ],
    );
  }
}
