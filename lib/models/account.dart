// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:budget_master/models/enums.dart';

class Account {
  String id;
  String name;
  String? group;
  DateTime created;
  AccountType type;
  Currency currency;
  double _balance;

  double get balance => _balance;

  Account({
    required this.name,
    required this.created,
    required this.type,
    required this.currency,
    required double balance,
    required this.id,
    this.group,
  }) : _balance = balance;

  Account copyWith({
    String? id,
    String? name,
    String? group,
    AccountType? type,
    DateTime? created,
    Currency? currency,
    double? balance,
  }) {
    return Account(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      created: created ?? this.created,
      currency: currency ?? this.currency,
      balance: balance ?? this.balance,
      group: group ?? this.group,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'type': type.toString(),
      'created': created.millisecondsSinceEpoch,
      'currency': currency.toString(),
      'balance': balance,
      'group': group,
    };
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      id: map['id'] as String,
      name: map['name'] as String,
      type: AccountType.values.byName(map['type']),
      created: DateTime.fromMillisecondsSinceEpoch(map['created'] as int),
      currency: Currency.values.byName(map['currency']),
      balance: map['balance'] as double,
      group: map['group'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Account.fromJson(String source) =>
      Account.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Account(id: $id, name: $name, created: $created, currency: $currency, _balance: $_balance)';
  }

  @override
  bool operator ==(covariant Account other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.created == created &&
        other.currency == currency &&
        other._balance == _balance;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        created.hashCode ^
        currency.hashCode ^
        _balance.hashCode;
  }
}
