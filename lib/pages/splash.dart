import 'package:budget_master/services/db.dart';
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

    widget.onLoad();
  }

  @override
  Widget build(BuildContext context) {
    load();
    return const Placeholder();
  }
}
