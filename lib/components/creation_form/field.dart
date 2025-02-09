import 'package:flutter/material.dart';
import 'selectors/selector.dart';

class CreationFormField extends StatefulWidget {
  const CreationFormField(
      {super.key,
      required this.title,
      required this.selector,
      String? identifier})
      : identifier = identifier ?? title;

  final String title;
  final String identifier;
  final CreationFormSelector selector;

  dynamic get value => selector.value;

  @override
  State<CreationFormField> createState() => _CreationFormFieldState();
}

class _CreationFormFieldState extends State<CreationFormField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text("${widget.title}:"),
          const SizedBox(width: 15),
          widget.selector,
        ],
      ),
    );
  }
}
