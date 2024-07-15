// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:budget_master/models/enums.dart';
import 'package:budget_master/models/model.dart';

class Account extends Model {
  @override
  String get id => created.millisecondsSinceEpoch.toString();

  String group;
  DateTime created;
  AccountType type;
  Currency currency;
  double _balance;

  double get balance => _balance;

  Account({
    required super.name,
    DateTime? created,
    required this.type,
    required this.currency,
    double? balance,
    String? group,
    super.edited,
  })  : _balance = balance ?? 0,
        created = created ?? DateTime.now(),
        group = group ?? "";

  Account copyWith({
    String? name,
    String? group,
    DateTime? created,
    AccountType? type,
    Currency? currency,
    double? balance,
    DateTime? edited,
  }) {
    return Account(
      name: name ?? this.name,
      type: type ?? this.type,
      created: created ?? this.created,
      currency: currency ?? this.currency,
      balance: balance ?? this.balance,
      group: group ?? this.group,
      edited: edited,
    );
  }

  Account addBalance(double diff) {
    return copyWith(balance: double.parse((balance + diff).toStringAsFixed(3)));
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'type': type.name,
      'created': created.millisecondsSinceEpoch,
      'currency': currency.name,
      'balance': balance,
      'group': group,
      'edited': edited.millisecondsSinceEpoch,
    };
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      name: map['name'] as String,
      type: AccountType.values.byName(map['type']),
      created: Model.fromMilliOrNow(map['created']),
      currency: Currency.values.byName(map['currency']),
      balance: map['balance'] as double?,
      group: map['group'],
      edited: Model.fromMilliOrNow(map['edited']),
    );
  }

  factory Account.fromJson(String source) =>
      Account.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Account(name: $name, group: $group, balance: $_balance, id: $id)';
  }

  @override
  bool operator ==(covariant Account other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.created == created &&
        other.currency == currency &&
        other._balance == _balance;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        created.hashCode ^
        currency.hashCode ^
        _balance.hashCode;
  }
}
