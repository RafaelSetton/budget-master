// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:flutter/material.dart';

class AccountGroup {
  String id;
  String name;
  List<String> accounts;
  MaterialColor color;

  AccountGroup({
    required this.id,
    required this.name,
    required this.accounts,
    required this.color,
  });

  AccountGroup copyWith({
    String? id,
    String? name,
    List<String>? accounts,
    MaterialColor? color,
  }) {
    return AccountGroup(
      color: color ?? this.color,
      id: id ?? this.id,
      name: name ?? this.name,
      accounts: accounts ?? this.accounts,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'color': Colors.primaries.indexOf(color),
      'id': id,
      'name': name,
      'accounts': accounts,
    };
  }

  factory AccountGroup.fromMap(Map<String, dynamic> map) {
    return AccountGroup(
      color: Colors.primaries[map['color']],
      id: map['id'] as String,
      name: map['name'] as String,
      accounts: List<String>.from(map['accounts']),
    );
  }

  String toJson() => json.encode(toMap());

  factory AccountGroup.fromJson(String source) =>
      AccountGroup.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'AccountGroup(id: $id, name: $name, accounts: $accounts)';

  @override
  bool operator ==(covariant AccountGroup other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name && other.accounts == accounts;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ accounts.hashCode;
}
