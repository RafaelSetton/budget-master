import 'package:budget_master/utils/app_colors.dart';
import 'package:flutter/material.dart';

class VerticalBar extends Border {
  const VerticalBar();

  @override
  BorderSide get right => BorderSide(color: AppColors.iconsFocus);
}
