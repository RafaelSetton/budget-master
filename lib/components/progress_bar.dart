// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:budget_master/utils/app_colors.dart';
import 'package:budget_master/utils/app_sizes.dart';
import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({super.key, required this.progress, required this.mark});

  final double progress;
  final double mark;

  double get greenPoint => mark * 0.8;
  double get yellowPoint => mark;
  double get redPoint => mark * 1.1;

  double get width => AppSizes.accGroupWidth - 30;

  Color mixColors(Color color1, Color color2, double point) {
    return Color.fromARGB(
      (color2.alpha * point + color1.alpha * (1 - point)).toInt(),
      (color2.red * point + color1.red * (1 - point)).toInt(),
      (color2.green * point + color1.green * (1 - point)).toInt(),
      (color2.blue * point + color1.blue * (1 - point)).toInt(),
    );
  }

  Color get color {
    if (progress <= greenPoint) return Colors.green;
    if (progress <= yellowPoint)
      return mixColors(Colors.green, Colors.yellow,
          (progress - greenPoint) / (yellowPoint - greenPoint));
    if (progress <= redPoint)
      return mixColors(Colors.yellow, Colors.red,
          (progress - yellowPoint) / (redPoint - yellowPoint));
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      width: width,
      margin: const EdgeInsets.symmetric(vertical: 7),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                height: 20,
                width: width,
                color: AppColors.icons,
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                height: 20,
                width: width * progress,
                decoration: BoxDecoration(
                  color: color,
                  border: Border(
                    right: BorderSide(
                      color: HSLColor.fromColor(color)
                          .withLightness(0.3)
                          .toColor(),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: width * mark,
              child: Container(
                height: 20,
                width: 1,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
