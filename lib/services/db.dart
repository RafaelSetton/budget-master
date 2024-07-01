import 'dart:convert';

import 'package:budget_master/models/account.dart';
import 'package:budget_master/models/account_group.dart';
import 'package:budget_master/models/budget.dart';
import 'package:budget_master/models/model.dart';
import 'package:budget_master/models/scheduled_transaction.dart';
import 'package:budget_master/models/transaction.dart';
import 'package:budget_master/services/file_manager.dart';
import 'package:budget_master/services/handlers.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';

abstract class Database {
  static late final TransactionsHandler transactions;
  static late final AccountsHandler accounts;
  static late final AccountGroupsHandler groups;
  static late final ScheduledsHandler scheduled;
  static late final BudgetsHandler budgets;
  static final ChangeNotifier notifier = ChangeNotifier();
  static final FileManager _fileManager = FileManager();

  static Future<Map<String, T>> _get<T extends Model>(
      String fileName, T Function(Map<String, dynamic>) fromMap) async {
    final String content = await _fileManager.read(fileName) ?? "{}";

    return (json.decode(content) as Map<String, dynamic>)
        .map((key, value) => MapEntry(key, fromMap(value)));
  }

  static Future load() async {
    await _fileManager.init();

    transactions =
        TransactionsHandler(await _get("transactions", Transaction.fromMap));
    accounts = AccountsHandler(await _get("accounts", Account.fromMap));
    groups = AccountGroupsHandler(await _get("groups", AccountGroup.fromMap));
    budgets = BudgetsHandler(await _get("budgets", Budget.fromMap));
    scheduled = ScheduledsHandler(
        await _get("scheduled", ScheduledTransaction.fromMap));

    _fileManager.start();

    //await _populate();

    notifier.addListener(() => _fileManager.shouldSave = true);

    groups.log = true;
    accounts.log = true;
    budgets.log = true;
    transactions.log = true;
    scheduled.log = true;

    debugPrint(repr);
  }

  static String get repr {
    return {
      "accounts": accounts.getCount(),
      "groups": groups.getCount(),
      "transactions": transactions.getCount(),
      "budgets": budgets.getCount(),
      "scheduled": scheduled.getCount(),
    }.toString();
  }
}
