// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:budget_master/models/account.dart';
import 'package:budget_master/models/category.dart';
import 'package:budget_master/models/model.dart';
import 'package:budget_master/services/db.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'dart:core';

import 'package:budget_master/models/enums.dart';

class Transaction extends Model {
  @override
  String get id => _id;

  // Basics
  String _id;
  Currency currency;
  TransactionType type;
  DateTime dateTime;
  double _totalValue;
  String description;
  String? accountIn;
  String? accountOut;

  // For Expenses/Incomes
  Map<String, double>? categories;
  String? payee;

  // For Buy's/Sell's
  double? nShares;
  double? _pricePerShare;
  String? assetName;

  bool get isBuySell =>
      type == TransactionType.buy || type == TransactionType.sell;
  bool get isExpenseIncome =>
      type == TransactionType.expense || type == TransactionType.income;
  bool get isTransfer => type == TransactionType.transfer;

  double get pricePerShare => isBuySell
      ? _pricePerShare!
      : throw UnimplementedError("Transaction is not buy/sell");
  double get totalValue {
    if (isExpenseIncome) {
      return categories!.values.sum;
    } else if (isBuySell) {
      return nShares! * _pricePerShare!;
    }
    return _totalValue;
  }

  set pricePerShare(double val) {
    if (!isBuySell) throw UnimplementedError("Transaction is not buy/sell");
    _pricePerShare = val;
    _totalValue = _pricePerShare! * nShares!;
  }

  set totalValue(double val) {
    _totalValue = val;
    if (isBuySell) _pricePerShare = _totalValue / nShares!;
  }

  Account? get getAccountIn => Database.accounts.get(accountIn);
  Account? get getAccountOut => Database.accounts.get(accountOut);

  List<TransactionCategory>? get getCategories => categories?.keys
      .map(Database.categories.get)
      .whereType<TransactionCategory>()
      .toList();

  Map<String, String> display() {
    //TODO (Transaction)
    return {
      "Conta de Entrada": getAccountIn?.name ?? "",
      "Conta de Saída": getAccountOut?.name ?? "",
      "Valor": totalValue.toString(),
      "Data": DateFormat('dd/MM/yyyy').format(dateTime),
      "Descrição": description,
      "Beneficiário": payee ?? "",
      "Categoria(s)":
          categories?.keys.reduce((value, element) => "$value, $element") ?? "",
    };
  }

  Transaction._main({
    String? id,
    super.edited,
    required this.currency,
    required this.type,
    required this.dateTime,
    required double totalValue,
    required this.description,
    this.accountIn,
    this.categories,
    this.accountOut,
    this.nShares,
    this.assetName,
    this.payee,
    double? pricePerShare,
  })  : _totalValue = totalValue,
        _pricePerShare = pricePerShare,
        _id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        super(name: "");

  factory Transaction.expenseIncome({
    String? id,
    DateTime? edited,
    required Currency currency,
    required TransactionType type,
    required DateTime dateTime,
    required String account,
    required Map<String, double> categories,
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
      totalValue: categories.values.sum,
      accountIn: type == TransactionType.income ? account : null,
      accountOut: type == TransactionType.expense ? account : null,
      categories: categories,
      payee: payee,
    );
  }

  factory Transaction.buySellFromTotal({
    String? id,
    required DateTime edited,
    required Currency currency,
    required TransactionType type,
    required DateTime dateTime,
    required String accountIn,
    required double nShares,
    required double totalValue,
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
      accountIn: accountIn,
      nShares: nShares,
      pricePerShare: totalValue / nShares,
      assetName: assetName,
    );
  }

  factory Transaction.buySellPerShare({
    String? id,
    required DateTime edited,
    required Currency currency,
    required TransactionType type,
    required DateTime dateTime,
    required String accountIn,
    required double nShares,
    required double pricePerShare,
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
      accountIn: accountIn,
      nShares: nShares,
      pricePerShare: pricePerShare,
      assetName: assetName,
    );
  }

  factory Transaction.transfer({
    String? id,
    DateTime? edited,
    required Currency currency,
    required DateTime dateTime,
    required String accountIn,
    required double totalValue,
    required String accountOut,
    required String description,
  }) {
    return Transaction._main(
      id: id,
      description: description,
      edited: edited,
      currency: currency,
      type: TransactionType.transfer,
      dateTime: dateTime,
      totalValue: totalValue,
      accountIn: accountIn,
      accountOut: accountOut,
    );
  }

  Transaction copyWith({
    String? id,
    DateTime? edited,
    Currency? currency,
    DateTime? dateTime,
    double? totalValue,
    String? accountIn,
    String? description,
    String? accountOut,
    Map<String, double>? categories,
    double? nShares,
    double? pricePerShare,
    String? assetName,
    TransactionType? type,
    String? payee,
  }) {
    return Transaction._main(
      id: id ?? this.id,
      edited: edited ?? this.edited,
      currency: currency ?? this.currency,
      dateTime: dateTime ?? this.dateTime,
      totalValue: totalValue ?? _totalValue,
      accountIn: accountIn ?? this.accountIn,
      description: description ?? this.description,
      accountOut: accountOut ?? this.accountOut,
      categories: categories ?? this.categories,
      nShares: nShares ?? this.nShares,
      pricePerShare: pricePerShare ?? _pricePerShare,
      assetName: assetName ?? this.assetName,
      type: type ?? this.type,
      payee: payee ?? this.payee,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'edited': edited.millisecondsSinceEpoch,
      'currency': currency.name,
      'dateTime': dateTime.millisecondsSinceEpoch,
      'totalValue': _totalValue,
      'accountIn': accountIn,
      'description': description,
      'accountOut': accountOut,
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
      totalValue: (map['totalValue'] as num).toDouble(),
      accountIn: map['accountIn'] as String?,
      description: map['description'] as String,
      accountOut: map['accountOut'] as String?,
      categories: map['categories'] != null
          ? Map<String, double>.from((map['categories'])
              .map((key, value) => MapEntry(key, value.toDouble())))
          : null,
      nShares: (map['nShares'] as num?)?.toDouble(),
      pricePerShare: (map['pricePerShare'] as num?)?.toDouble(),
      assetName: map['assetName'] != null ? map['assetName'] as String : null,
      type: TransactionType.values.byName(map['type']),
    );
  }

  factory Transaction.fromJson(String source) =>
      Transaction.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString([long = false]) {
    return long
        ? '''Transaction(
      Required:
        id: $id,
        edited: $edited, 
        type: $type,
        currency: $currency, 
        dateTime: $dateTime, 
        totalValue: $_totalValue, 
        accountIn: $accountIn, 
        description: $description, 
      Transfers:
        accountOut: $accountOut, 
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
        other.accountIn == accountIn &&
        other.description == description &&
        other.accountOut == accountOut &&
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
        accountIn.hashCode ^
        description.hashCode ^
        accountOut.hashCode ^
        categories.hashCode ^
        nShares.hashCode ^
        _pricePerShare.hashCode ^
        assetName.hashCode;
  }
}
