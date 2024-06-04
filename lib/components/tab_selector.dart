import 'dart:math';

import 'package:budget_master/utils/app_colors.dart';
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

  Widget get header => Row(
        children: widget.tabs.indexed
            .map(
              (e) => GestureDetector(
                onTap: () => setState(() {
                  selected = e.$1;
                }),
                child: Container(
                  width: tabWidth,
                  height: headerHeight,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(
                      left: e.$1 > 0
                          ? tabDivider
                          : BorderSide.none, // Sem borda no começo
                      right: e.$1 < widget.tabs.length - 1
                          ? tabDivider
                          : BorderSide.none, // Sem borda no fim
                      bottom: selected == e.$1
                          ? BorderSide.none
                          : const BorderSide(),
                    ),
                    color: selected == e.$1
                        ? AppColors.popUpSelectedBackground
                        : AppColors.popUpBackground,
                  ),
                  child: Text(e.$2.title),
                ),
              ),
            )
            .toList(),
      );
  Widget get body => Container(
        width: width,
        height: bodyHeight,
        color: AppColors.popUpSelectedBackground,
        child: widget.tabs[selected].child,
      );

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
