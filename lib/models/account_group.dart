// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:budget_master/models/model.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class AccountGroup extends Model {
  @override
  String get id => _id;

  final String _id;
  String name;
  List<String> accounts;
  MaterialColor color;

  AccountGroup({
    String? id,
    required this.name,
    this.accounts = const [],
    required this.color,
    DateTime? edited,
  })  : _id = id ?? name,
        super(edited: edited);

  AccountGroup copyWith({
    String? id,
    String? name,
    MaterialColor? color,
    List<String>? accounts,
    List<String> addAccounts = const [],
    List<String> removeAccounts = const [],
  }) {
    accounts ??= (this.accounts..addAll(addAccounts))
        .whereNot(removeAccounts.contains)
        .toList();
    return AccountGroup(
      color: color ?? this.color,
      id: id ?? this.id,
      name: name ?? this.name,
      accounts: accounts,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'accounts': accounts,
      'color': Colors.primaries.indexOf(color),
      'edited': edited.millisecondsSinceEpoch,
    };
  }

  factory AccountGroup.fromMap(Map<String, dynamic> map) {
    return AccountGroup(
      id: map['id'] as String?,
      name: map['name'] as String,
      color: Colors.primaries[map['color']],
      accounts: List<String>.from(map['accounts'] ?? []),
      edited: Model.fromMilliOrNow(map['edited']),
    );
  }

  factory AccountGroup.fromJson(String source) =>
      AccountGroup.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'AccountGroup(id: $id, name: $name, accounts: $accounts, color: $color)';

  @override
  bool operator ==(covariant AccountGroup other) {
    if (identical(this, other)) return true;
    return other.name == name &&
        other.id == id &&
        other.edited == edited &&
        other.accounts == accounts &&
        other.color == color;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      edited.hashCode ^
      name.hashCode ^
      accounts.hashCode ^
      color.hashCode;
}
