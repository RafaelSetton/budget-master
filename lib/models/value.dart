import 'package:budget_master/models/enums.dart';
import 'package:flutter/material.dart';

class Value {
  double v;
  Currency currency;

  Value(this.v, this.currency);

  Value operator +(Value other) {
    if (other.currency != currency) {
      throw ErrorDescription("Cannot sum values of different currencies");
    }
    return Value(v + other.v, currency);
  }

  @override
  String toString() {
    return v.toString();
  }
}
