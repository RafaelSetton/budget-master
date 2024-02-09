import 'package:budget_master/utils/app_colors.dart';
import 'package:flutter/material.dart';

class VerticalBar extends Border {
  const VerticalBar([this.width = 1]);

  final double width;

  @override
  BorderSide get right => BorderSide(color: AppColors.iconsFocus, width: width);
}
