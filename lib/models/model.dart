import 'dart:convert';

import 'package:flutter/material.dart';

abstract class Model {
  Model({DateTime? edited, required this.name})
      : edited = edited ?? DateTime.now();

  String get id;
  String name;
  final DateTime edited;

  @protected
  static DateTime fromMilliOrNow(int? millisecondsSinceEpoch) {
    if (millisecondsSinceEpoch != null) {
      return DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
    } else {
      return DateTime.now();
    }
  }

  Map<String, dynamic> toMap();

  String toJson() => json.encode(toMap());
}
