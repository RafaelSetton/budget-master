import 'package:flutter/material.dart';

abstract final class AppColors {
  static Color background = Colors.grey.shade800;
  static Color bottomNavigationBackground = Colors.grey.shade400;

  static Color icons = Colors.grey.shade400;
  static Color iconsFocus = Colors.grey.shade700;

  static Color tableHeaderBackGround = Colors.grey.shade100;
  static Color tableHeaderText = Colors.black;
  static MaterialColor tableBodyBackground =
      MaterialColor(0, {0: Colors.white, 1: Colors.blue.shade100});
  static Color tableBodyText = Colors.grey.shade900;

  static Color popUpBackground = Colors.grey.shade300;
  static Color popUpSelectedBackground = Colors.grey.shade500;
  static Color popUpText = Colors.black87;
  static Color popUpButton = Colors.cyan.shade900;
  static Color popUpButtonText = Colors.white;
  static Color popUpDecoration = Colors.cyan.shade700;

  static Color groupBackground = Colors.black;
  static Color groupTitle = Colors.white;
  static Color groupSubtitle = Colors.white70;

  static Color cursor = Colors.cyan.shade400;
  static Color input = Colors.grey.shade300;
}
