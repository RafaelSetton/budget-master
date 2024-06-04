// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:budget_master/utils/app_sizes.dart';
import 'package:flutter/material.dart';

class Grid extends StatefulWidget {
  final List<Widget> children;
  final double itemHeight;
  final double itemWidth;
  final double totalHorizontalPadding;

  const Grid({
    Key? key,
    required this.children,
    required this.itemHeight,
    required this.itemWidth,
    required this.totalHorizontalPadding,
  }) : super(key: key);

  @override
  State<Grid> createState() => _GridState();
}

class _GridState extends State<Grid> {
  double availableWidth = 0;
  int _listenerId = -1;

  void _updateWidth() {
    setState(() {
      availableWidth = AppSizes.window.width -
          AppSizes.sideBarWidth -
          widget.totalHorizontalPadding;
    });
  }

  @override
  void initState() {
    availableWidth = AppSizes.window.width -
        AppSizes.sideBarWidth -
        widget.totalHorizontalPadding;
    _listenerId = AppSizes.addListener(_updateWidth);
    super.initState();
  }

  @override
  void dispose() {
    AppSizes.removeListener(_listenerId);
    super.dispose();
  }

  List<List<Widget>> split() {
    List<List<Widget>> res = [];
    int n = (availableWidth / widget.itemWidth).floor();
    for (int i = 0; i < widget.children.length; i += n) {
      res.add(widget.children.sublist(i, min(i + n, widget.children.length)));
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: split()
          .map((e) => Row(
                children: e,
              ))
          .toList(),
    );
  }
}
