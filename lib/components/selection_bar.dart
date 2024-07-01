import 'package:budget_master/components/vertical_bar.dart';
import 'package:budget_master/utils/app_colors.dart';
import 'package:budget_master/utils/app_sizes.dart';
import 'package:flutter/material.dart';

class SelectionBar extends StatefulWidget {
  final List<Widget> children;

  const SelectionBar({super.key, required this.children});

  @override
  State<SelectionBar> createState() => _SelectionBarState();
}

class _SelectionBarState extends State<SelectionBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        border: const VerticalBar(),
      ),
      height: AppSizes.window.height,
      width: AppSizes.secondaryBarWidth,
      padding: const EdgeInsets.only(top: 10),
      child: SingleChildScrollView(child: Column(children: widget.children)),
    );
  }
}
