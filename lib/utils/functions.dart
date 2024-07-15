import 'package:flutter/material.dart';

Future<T?> showPositionedDialog<T>(
    {required BuildContext context,
    required Widget Function(BuildContext, Offset) builder,
    required double buttonHeight}) {
  RenderBox rb = context.findRenderObject() as RenderBox;
  Offset offset = rb.localToGlobal(Offset(0, buttonHeight));
  return showDialog<T>(
    context: context,
    barrierColor: Colors.transparent,
    builder: (ctx) => builder(ctx, offset),
  );
}
