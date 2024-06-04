// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:intl/intl.dart';
import 'dart:core';

import 'package:budget_master/models/enums.dart';

class Transaction {
  // Required
  String id;
  DateTime edited;
  Currency currency;
  TransactionType type;
  DateTime dateTime;
  num _totalValue;
  String accountPrimary;
  String description;

  // For Transfers
  String? accountSecondary;

  // For Expenses/Incomes
  Map<String, num>? categories;
  String? payee;

  // For Buy's/Sell's
  num? nShares;
  num? _pricePerShare;
  String? assetName;

  bool get isBuySell =>
      type == TransactionType.buy || type == TransactionType.sell;
  bool get isExpenseIncome =>
      type == TransactionType.expense || type == TransactionType.income;
  bool get isTransfer => type == TransactionType.transfer;

  num get pricePerShare => isBuySell
      ? _pricePerShare!
      : throw UnimplementedError("Transaction is not buy/sell");
  num get totalValue => _totalValue;

  set pricePerShare(num val) {
    if (!isBuySell) throw UnimplementedError("Transaction is not buy/sell");
    _pricePerShare = val;
    _totalValue = _pricePerShare! * nShares!;
  }

  set totalValue(num val) {
    _totalValue = val;
    if (isBuySell) _pricePerShare = _totalValue / nShares!;
  }

  Map<String, dynamic> display() {
    return {
      "Conta": accountPrimary,
      "Valor": totalValue.toString(),
      "Data": DateFormat('dd/MM/yyyy').format(dateTime),
      "Descrição": description,
      "Beneficiário": payee ?? "",
      "Categoria(s)":
          categories?.keys.reduce((value, element) => "$value, $element") ?? "",
    };
  }

  Transaction._main({
    required this.id,
    required this.edited,
    required this.currency,
    required this.type,
    required this.dateTime,
    required num totalValue,
    required this.accountPrimary,
    required this.description,
    this.categories,
    this.accountSecondary,
    this.nShares,
    this.assetName,
    this.payee,
    num? pricePerShare,
  })  : _totalValue = totalValue,
        _pricePerShare = pricePerShare;

  factory Transaction.expenseIncome({
    required String id,
    required DateTime edited,
    required Currency currency,
    required TransactionType type,
    required DateTime dateTime,
    required num totalValue,
    required String accountPrimary,
    required Map<String, num> categories,
    required String description,
    required String payee,
  }) {
    return Transaction._main(
      id: id,
      description: description,
      edited: edited,
      currency: currency,
      type: type,
      dateTime: dateTime,
      totalValue: totalValue,
      accountPrimary: accountPrimary,
      categories: categories,
      payee: payee,
    );
  }

  factory Transaction.buySellFromTotal({
    required String id,
    required DateTime edited,
    required Currency currency,
    required TransactionType type,
    required DateTime dateTime,
    required String accountPrimary,
    required num nShares,
    required num totalValue,
    required String assetName,
    required String description,
  }) {
    return Transaction._main(
      id: id,
      description: description,
      edited: edited,
      currency: currency,
      type: type,
      dateTime: dateTime,
      totalValue: totalValue,
      accountPrimary: accountPrimary,
      nShares: nShares,
      pricePerShare: totalValue / nShares,
      assetName: assetName,
    );
  }

  factory Transaction.buySellPerShare({
    required String id,
    required DateTime edited,
    required Currency currency,
    required TransactionType type,
    required DateTime dateTime,
    required String accountPrimary,
    required num nShares,
    required num pricePerShare,
    required String assetName,
    required String description,
  }) {
    return Transaction._main(
      id: id,
      description: description,
      edited: edited,
      currency: currency,
      type: type,
      dateTime: dateTime,
      totalValue: pricePerShare * nShares,
      accountPrimary: accountPrimary,
      nShares: nShares,
      pricePerShare: pricePerShare,
      assetName: assetName,
    );
  }

  factory Transaction.transfer({
    required String id,
    required DateTime edited,
    required Currency currency,
    required TransactionType type,
    required DateTime dateTime,
    required String accountPrimary,
    required num totalValue,
    required String accountSecondary,
    required String description,
  }) {
    return Transaction._main(
      id: id,
      description: description,
      edited: edited,
      currency: currency,
      type: type,
      dateTime: dateTime,
      totalValue: totalValue,
      accountPrimary: accountPrimary,
      accountSecondary: accountPrimary,
    );
  }

  Transaction copyWith({
    String? id,
    DateTime? edited,
    Currency? currency,
    DateTime? dateTime,
    num? totalValue,
    String? accountPrimary,
    String? description,
    String? accountSecondary,
    Map<String, num>? categories,
    num? nShares,
    num? pricePerShare,
    String? assetName,
    TransactionType? type,
  }) {
    return Transaction._main(
      id: id ?? this.id,
      edited: edited ?? this.edited,
      currency: currency ?? this.currency,
      dateTime: dateTime ?? this.dateTime,
      totalValue: totalValue ?? _totalValue,
      accountPrimary: accountPrimary ?? this.accountPrimary,
      description: description ?? this.description,
      accountSecondary: accountSecondary ?? this.accountSecondary,
      categories: categories ?? this.categories,
      nShares: nShares ?? this.nShares,
      pricePerShare: pricePerShare ?? _pricePerShare,
      assetName: assetName ?? this.assetName,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'edited': edited.millisecondsSinceEpoch,
      'currency': currency.name,
      'dateTime': dateTime.millisecondsSinceEpoch,
      'totalValue': _totalValue,
      'accountPrimary': accountPrimary,
      'description': description,
      'accountSecondary': accountSecondary,
      'categories': categories,
      'nShares': nShares,
      'pricePerShare': _pricePerShare,
      'assetName': assetName,
      'type': type.name,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction._main(
      id: map['id'] as String,
      edited: DateTime.fromMillisecondsSinceEpoch(map['edited'] as int),
      currency: Currency.values.byName(map['currency']),
      dateTime: DateTime.fromMillisecondsSinceEpoch(map['dateTime'] as int),
      totalValue: map['totalValue'] as num,
      accountPrimary: map['accountPrimary'] as String,
      description: map['description'] as String,
      accountSecondary: map['accountSecondary'] as String?,
      categories: map['categories'] != null
          ? Map<String, num>.from(map['categories'])
          : null,
      nShares: map['nShares'] != null ? map['nShares'] as num : null,
      pricePerShare: map['pricePerShare'] as num?,
      assetName: map['assetName'] != null ? map['assetName'] as String : null,
      type: TransactionType.values.byName(map['type']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Transaction.fromJson(String source) =>
      Transaction.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString([long = false]) {
    return long
        ? '''Transaction(
      Required:
        id: $id,
        edited: $edited, 
        currency: $currency, 
        dateTime: $dateTime, 
        totalValue: $_totalValue, 
        accountPrimary: $accountPrimary, 
        description: $description, 
      Transfers:
        accountSecondary: $accountSecondary, 
      InOut:
        categories: $categories, 
      BuySell:
        nShares: $nShares, 
        pricePerShare: $_pricePerShare, 
        assetName: $assetName,
      )'''
        : "Transaction(id: $id)";
  }

  @override
  bool operator ==(covariant Transaction other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.edited == edited &&
        other.currency == currency &&
        other.dateTime == dateTime &&
        other._totalValue == _totalValue &&
        other.accountPrimary == accountPrimary &&
        other.description == description &&
        other.accountSecondary == accountSecondary &&
        other.categories == categories &&
        other.nShares == nShares &&
        other._pricePerShare == _pricePerShare &&
        other.assetName == assetName;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        edited.hashCode ^
        currency.hashCode ^
        dateTime.hashCode ^
        _totalValue.hashCode ^
        accountPrimary.hashCode ^
        description.hashCode ^
        accountSecondary.hashCode ^
        categories.hashCode ^
        nShares.hashCode ^
        _pricePerShare.hashCode ^
        assetName.hashCode;
  }
}
