// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:budget_master/models/enums.dart';
import 'package:budget_master/models/model.dart';
import 'package:budget_master/models/transaction.dart';
import 'package:collection/collection.dart';

class Budget extends Model {
  @override
  String get id => created.millisecondsSinceEpoch.toString();

  final bool rollover;
  final double value;
  final String name;
  final DateTime created;
  final DateTime begin;
  final TimePeriod period;
  final List<String> categories;
  final List<String> accounts;

  int get durationInDays {
    switch (period) {
      case TimePeriod.day:
        return 1;
      case TimePeriod.week:
        return 7;
      case TimePeriod.month:
        return begin.copyWith(month: begin.month + 1).difference(begin).inDays;
      case TimePeriod.year:
        return begin.copyWith(year: begin.year + 1).difference(begin).inDays;
    }
  }

  bool filter(Transaction t) {
    return Set.from(accounts)
            .intersection({t.accountIn, t.accountOut}).isNotEmpty &&
        Set.from(categories)
            .intersection(
                Set.from(t.categories?.keys ?? const Iterable.empty()))
            .isNotEmpty;
  }

  Budget({
    required this.rollover,
    required this.value,
    required this.name,
    DateTime? created,
    required this.begin,
    required this.period,
    required this.categories,
    required this.accounts,
    DateTime? edited,
  })  : created = created ?? DateTime.now(),
        super(edited: edited);

  Budget copyWith({
    bool? rollover,
    double? value,
    String? name,
    DateTime? created,
    DateTime? begin,
    TimePeriod? period,
    List<String>? categories,
    List<String>? accounts,
  }) {
    return Budget(
      created: created ?? this.created,
      value: value ?? this.value,
      begin: begin ?? this.begin,
      period: period ?? this.period,
      rollover: rollover ?? this.rollover,
      categories: categories ?? this.categories,
      accounts: accounts ?? this.accounts,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'rollover': rollover,
      'value': value,
      'name': name,
      'created': created.millisecondsSinceEpoch,
      'begin': begin.millisecondsSinceEpoch,
      'period': period.name,
      'categories': categories,
      'accounts': accounts,
      'edited': edited.millisecondsSinceEpoch,
    };
  }

  factory Budget.fromMap(Map<String, dynamic> map) {
    return Budget(
        rollover: map['rollover'] as bool,
        value: map['value'] as double,
        name: map['name'] as String,
        created: Model.fromMilliOrNow(map['created']),
        begin: Model.fromMilliOrNow(map['begin']),
        period: TimePeriod.values.byName(map['period']),
        categories: List<String>.from((map['categories'])),
        accounts: List<String>.from((map['accounts'])),
        edited: Model.fromMilliOrNow(map['edited']));
  }

  factory Budget.fromJson(String source) =>
      Budget.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Budget(id: $id, value: $value, begin: $begin, period: $period, rollover: $rollover, categories: $categories, accounts: $accounts, name: $name)';
  }

  @override
  bool operator ==(covariant Budget other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.id == id &&
        other.value == value &&
        other.begin == begin &&
        other.period == period &&
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
        period.hashCode ^
        rollover.hashCode ^
        categories.hashCode ^
        accounts.hashCode ^
        name.hashCode;
  }
}
