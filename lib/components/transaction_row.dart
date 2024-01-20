import 'package:budget_master/models/transaction.dart';
import 'package:flutter/material.dart';

class TransactionRow extends TableRow {
  final Transaction transaction;

  const TransactionRow({super.key, required this.transaction});

  @override
  List<Widget> get children => [
        Text(transaction.id),
        Text(transaction.description),
        Text("data"),
        Text("data"),
        Text("data"),
      ];
}
