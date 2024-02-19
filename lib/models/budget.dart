// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';

class Budget {
  final String id;
  final double value;
  final DateTime begin;
  final Duration duration;
  final bool rollover;
  final List<String> categories;
  final List<String> accounts;
  final String name;
  Budget({
    required this.id,
    required this.value,
    required this.begin,
    required this.duration,
    required this.rollover,
    required this.categories,
    required this.accounts,
    required this.name,
  });

  Budget copyWith({
    String? id,
    double? value,
    DateTime? begin,
    Duration? duration,
    bool? rollover,
    List<String>? categories,
    List<String>? accounts,
    String? name,
  }) {
    return Budget(
      id: id ?? this.id,
      value: value ?? this.value,
      begin: begin ?? this.begin,
      duration: duration ?? this.duration,
      rollover: rollover ?? this.rollover,
      categories: categories ?? this.categories,
      accounts: accounts ?? this.accounts,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'value': value,
      'begin': begin.millisecondsSinceEpoch,
      'duration': duration.inDays,
      'rollover': rollover,
      'categories': categories,
      'accounts': accounts,
      'name': name,
    };
  }

  factory Budget.fromMap(Map<String, dynamic> map) {
    return Budget(
      id: map['id'] as String,
      value: map['value'] as double,
      begin: DateTime.fromMillisecondsSinceEpoch(map['begin'] as int),
      duration: Duration(days: map['duration'] as int),
      rollover: map['rollover'] as bool,
      categories: List<String>.from((map['categories'])),
      accounts: List<String>.from((map['accounts'])),
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Budget.fromJson(String source) =>
      Budget.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Budget(id: $id, value: $value, begin: $begin, duration: $duration, rollover: $rollover, categories: $categories, accounts: $accounts, name: $name)';
  }

  @override
  bool operator ==(covariant Budget other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.id == id &&
        other.value == value &&
        other.begin == begin &&
        other.duration == duration &&
        other.rollover == rollover &&
        listEquals(other.categories, categories) &&
        listEquals(other.accounts, accounts) &&
        other.name == name;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        value.hashCode ^
        begin.hashCode ^
        duration.hashCode ^
        rollover.hashCode ^
        categories.hashCode ^
        accounts.hashCode ^
        name.hashCode;
  }
}
