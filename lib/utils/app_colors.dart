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

  static Color groupBackground = Colors.black;
  static Color groupTitle = Colors.white;
  static Color groupSubtitle = Colors.white70;
}
