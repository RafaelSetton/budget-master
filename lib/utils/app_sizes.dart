import 'package:flutter/material.dart';

class AppSizes {
  static Size window = const Size(1280, 720);
  static const double sideBarWidth = 75;
  static const double secondaryBarWidth = 280;
  static final Map<int, void Function()> _listeners = {};
  static int counter = 0;
  static int addListener(void Function() listener) {
    _listeners[++counter] = listener;
    return counter;
  }

  static void removeListener(int id) {
    _listeners.remove(id);
  }

  static void update(BuildContext context) {
    window = MediaQuery.of(context).size;
    for (var element in _listeners.values) {
      element();
    }
  }
}
