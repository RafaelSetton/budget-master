import 'dart:math';

import 'package:budget_master/utils/app_colors.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class TabOption {
  final String title;
  final Widget child;

  TabOption({required this.title, required this.child});
}

class TabSelector extends StatefulWidget {
  TabSelector({super.key, required this.tabs}) {
    assert(tabs.isNotEmpty);
  }

  final List<TabOption> tabs;

  @override
  State<TabSelector> createState() => _TabSelectorState();
}

class _TabSelectorState extends State<TabSelector> {
  int selected = 0;

  double get tabWidth => 100;

  double get bodyHeight => 300;
  double get headerHeight => 30;

  double get width => max(300, tabWidth * widget.tabs.length);
  Color get defaultColor => AppColors.popUpBackground;
  Color get selectedColor => AppColors.popUpSelectedBackground;

  BorderSide get tabDivider => const BorderSide();

  Widget get header {
    return Row(
      children: widget.tabs
          .mapIndexed(
            (idx, tab) => GestureDetector(
              onTap: () => setState(() {
                selected = idx;
              }),
              child: Container(
                width: tabWidth,
                height: headerHeight,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    left: idx > 0
                        ? tabDivider
                        : BorderSide.none, // Sem borda no começo
                    right: idx < widget.tabs.length - 1
                        ? tabDivider
                        : BorderSide.none, // Sem borda no fim
                    bottom:
                        selected == idx ? BorderSide.none : const BorderSide(),
                  ),
                  color: selected == idx
                      ? AppColors.popUpSelectedBackground
                      : AppColors.popUpBackground,
                ),
                child: Text(tab.title),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget get body {
    return Container(
      width: width,
      height: bodyHeight,
      color: AppColors.popUpSelectedBackground,
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(child: widget.tabs[selected].child),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Container(
        width: width,
        height: bodyHeight + headerHeight,
        alignment: Alignment.topCenter,
        child: Column(
          children: [header, body],
        ),
      ),
    );
  }
}
