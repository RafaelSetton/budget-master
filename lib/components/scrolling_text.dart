import 'package:flutter/material.dart';

class ScrollingText extends StatelessWidget {
  ScrollingText(this.text, {super.key, required this.width});

  final ScrollController scrollController = ScrollController();
  final String text;
  final double width;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (b) {
        scrollController.jumpTo(0);
        Future.delayed(
          Durations.long2,
          () {
            if (scrollController.positions.isEmpty) return;
            scrollController.animateTo(
              scrollController.position.maxScrollExtent,
              duration: Duration(
                  milliseconds:
                      scrollController.position.maxScrollExtent.toInt() * 13),
              curve: Curves.linear,
            );
          },
        );
      },
      child: SizedBox(
        width: width,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: scrollController,
          child: Text(text),
        ),
      ),
    );
  }
}
