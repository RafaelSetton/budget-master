import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

abstract class CreationFormSelector<T> extends StatefulWidget {
  CreationFormSelector(
      {super.key, ValueNotifier<T>? controller, T? defaultValue}) {
    assert(defaultValue != null || controller != null);
    // ignore: null_check_on_nullable_type_parameter
    this.controller = controller ?? ValueNotifier<T>(defaultValue!);
  }

  late final ValueNotifier<T> controller;

  @nonVirtual
  T get value => controller.value;
}
