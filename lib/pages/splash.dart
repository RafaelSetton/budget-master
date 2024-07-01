import 'package:budget_master/services/db.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  final void Function() onLoad;

  const Splash({super.key, required this.onLoad});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  Future load() async {
    await Database.load();

    if (kDebugMode) {}
    await Future.delayed(Durations.long2, widget.onLoad);
  }

  @override
  Widget build(BuildContext context) {
    load();
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Image.asset("windows/runner/resources/app_icon.ico"),
        const Text(
          "Budget Master",
          textDirection: TextDirection.ltr,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const Text(
          "v 1.0.0\nRafael Setton\n2024",
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center,
          style: TextStyle(height: 2),
        ),
      ],
    );
  }
}
