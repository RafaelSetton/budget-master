import 'package:budget_master/components/creation_form/selectors/selector.dart';
import 'package:budget_master/utils/app_colors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TextSelector extends CreationFormSelector {
  TextSelector({super.key});

  String _value = "";

  @override
  String get value => _value;

  @override
  State<TextSelector> createState() => _TextSelectorState();
}

class _TextSelectorState extends State<TextSelector> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    _controller.addListener(() {
      widget._value = _controller.text;
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  InputBorder get border => const OutlineInputBorder();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 35,
      child: TextField(
        cursorColor: AppColors.cursor,
        scrollController: _scrollController,
        focusNode: _focusNode,
        onTapOutside: (_) {
          _focusNode.unfocus();
          _scrollController.jumpTo(0);
        },
        decoration: InputDecoration(
          border: border,
          fillColor: AppColors.input,
          filled: true,
          focusedBorder: border,
          contentPadding: const EdgeInsets.symmetric(horizontal: 5),
        ),
        controller: _controller,
      ),
    );
  }
}
