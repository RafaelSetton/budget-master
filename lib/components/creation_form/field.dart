import 'package:flutter/material.dart';
import 'selectors/selector.dart';

class CreationFormField extends StatefulWidget {
  const CreationFormField(
      {super.key, required this.title, required this.selector});

  final String title;
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
        children: [
          Text("${widget.title}:"),
          widget.selector,
        ],
      ),
    );
  }
}
