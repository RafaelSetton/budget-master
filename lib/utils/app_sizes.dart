import 'package:flutter/material.dart';

class AppSizes {
  static Size window = const Size(1280, 720);
  static const double sideBarWidth = 75;
  static const double secondaryBarWidth = 280;
  static const double accGroupWidth = 250;

  static final ChangeNotifier notifier = ChangeNotifier();

  static void update(BuildContext context) {
    window = MediaQuery.of(context).size;
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    notifier.notifyListeners();
  }
}
