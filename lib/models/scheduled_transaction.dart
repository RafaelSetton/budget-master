// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:budget_master/models/model.dart';
import 'package:budget_master/models/transaction.dart';
import 'package:budget_master/models/time_interval.dart';

class ScheduledTransaction extends Model {
  @override
  String get id => "scheduled-${transaction.id}";

  Transaction transaction;
  DateTime nextDate;
  TimeInterval interval;
  bool autoCreate;

  ScheduledTransaction({
    required this.transaction,
    required this.nextDate,
    required this.interval,
    required super.name,
    this.autoCreate = false,
    super.edited,
  });

  ScheduledTransaction copyWith({
    Transaction? transaction,
    DateTime? nextDate,
    TimeInterval? interval,
    bool? autoCreate,
    String? name,
  }) {
    return ScheduledTransaction(
      name: name ?? this.name,
      transaction: transaction ?? this.transaction,
      nextDate: nextDate ?? this.nextDate,
      interval: interval ?? this.interval,
      autoCreate: autoCreate ?? this.autoCreate,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'transaction': transaction.toMap(),
      'nextDate': nextDate.millisecondsSinceEpoch,
      'interval': interval.toMap(),
      'autoCreate': autoCreate,
      'name': name,
    };
  }

  factory ScheduledTransaction.fromMap(Map<String, dynamic> map) {
    return ScheduledTransaction(
      transaction:
          Transaction.fromMap(map['transaction'] as Map<String, dynamic>),
      nextDate: DateTime.fromMillisecondsSinceEpoch(map['nextDate'] as int),
      interval: TimeInterval.fromMap(map['interval']),
      autoCreate: map['autoCreate'] as bool,
      name: map['name'] ?? "",
    );
  }

  factory ScheduledTransaction.fromJson(String source) =>
      ScheduledTransaction.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ScheduledTransaction(transaction: $transaction, nextDate: $nextDate, interval: $interval, autoCreate: $autoCreate)';
  }

  @override
  bool operator ==(covariant ScheduledTransaction other) {
    if (identical(this, other)) return true;

    return other.transaction == transaction &&
        other.nextDate == nextDate &&
        other.interval == interval &&
        other.autoCreate == autoCreate;
  }

  @override
  int get hashCode {
    return transaction.hashCode ^
        nextDate.hashCode ^
        interval.hashCode ^
        autoCreate.hashCode;
  }
}
