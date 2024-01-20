import 'dart:convert';

import 'package:budget_master/models/account.dart';
import 'package:budget_master/models/account_group.dart';
import 'package:budget_master/models/transaction.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Database {
  /* static LocalStorage? _database;
  static String? _directory; */
  static late Map<String, Transaction> _transactions;
  static late Map<String, Account> _accounts;
  static late Map<String, AccountGroup> _groups;
  static late SharedPreferences _prefs;

  static Future load() async {
    _prefs = await SharedPreferences.getInstance();

    await setData();

    var data =
        json.decode(_prefs.getString("accounts")!) as Map<String, dynamic>;
    _accounts = data.map((key, value) => MapEntry(key, Account.fromMap(value)));

    data = json.decode(_prefs.getString("groups")!) as Map<String, dynamic>;
    _groups =
        data.map((key, value) => MapEntry(key, AccountGroup.fromMap(value)));

    data =
        json.decode(_prefs.getString("transactions")!) as Map<String, dynamic>;
    _transactions =
        data.map((key, value) => MapEntry(key, Transaction.fromMap(value)));
  }

  static void setValue(String key, dynamic value) async {
    _prefs.setString(key, value.toJson());
  }

  static Map<String, Transaction> get transactions => _transactions;
  static Map<String, Account> get accounts => _accounts;
  static Map<String, AccountGroup> get groups => _groups;

  /* static LocalStorage get database {
    _database ??= LocalStorage(
      kDebugMode ? "budget_master_debug.json" : "budget_master_database.json",
    );
    return _database!;
  } */

  static AccountGroup? groupById(String id) => groups[id];
  static Account? accountById(String id) => accounts[id];
  static Transaction? transactionById(String id) => transactions[id];

  static List<Account>? accountsByGroup(String groupId) =>
      groups[groupId]?.accounts.map((e) => accounts[e]!).toList();

  static List<Transaction>? transactionsByAccount(String accountId) {
    return accounts[accountId] != null
        ? transactions.values
            .where((element) =>
                element.accountPrimary == accountId ||
                element.accountSecondary == accountId)
            .toList()
        : null;
  }

  static Future setData() async {
    Map exampleTransactions = {
      "tr1": {
        'id': 'tr1',
        'edited': 123456,
        'currency': 'brl',
        'dateTime': 456123,
        'totalValue': 12.5,
        'accountPrimary': "acc3",
        'description': "description",
        'accountSecondary': null,
        'categories': {"cat1": 10, "cat2": 2.5},
        'nShares': null,
        'pricePerShare': null,
        'assetName': null,
        'type': 'expense',
      },
    };
    Map exampleAccounts = {
      "acc1": {
        'id': 'acc1',
        'name': 'Rafael Inter',
        'type': 'checking',
        'created': 123456,
        'currency': 'brl',
        'balance': 15.65,
        'group': 'g1',
      },
      "acc2": {
        'id': 'acc2',
        'name': 'Rafael BB',
        'type': 'checking',
        'created': 11223,
        'currency': 'brl',
        'balance': 35.24,
        'group': null,
      },
      "acc3": {
        'id': 'acc3',
        'name': 'Rafael XP',
        'type': 'credit',
        'created': 2453,
        'currency': 'brl',
        'balance': -4.54,
        'group': 'g1',
      },
      "acc4": {
        'id': 'acc4',
        'name': 'Ricardo BB',
        'type': 'credit',
        'created': 2453,
        'currency': 'brl',
        'balance': -44.4,
        'group': 'g3',
      },
      "acc5": {
        'id': 'acc5',
        'name': 'Ricardo XP',
        'type': 'credit',
        'created': 2453,
        'currency': 'brl',
        'balance': 42.5,
        'group': 'g2',
      },
      "acc6": {
        'id': 'acc6',
        'name': 'Ricardo Bolso',
        'type': 'credit',
        'created': 2453,
        'currency': 'brl',
        'balance': 1.85,
        'group': 'g2',
      },
    };
    Map exampleGroups = {
      "g1": {
        'id': 'g1',
        'name': "RAFA",
        'accounts': ["acc1", 'acc3'],
        'color': 3
      },
      "g3": {
        'id': 'g3',
        'name': "RICO",
        'accounts': ['acc4'],
        'color': 1
      },
      "g2": {
        'id': 'g2',
        'name': "INVEST",
        'accounts': ["acc5", 'acc6'],
        'color': 9
      }
    };

    await _prefs.setString("transactions", json.encode(exampleTransactions));
    await _prefs.setString("accounts", json.encode(exampleAccounts));
    await _prefs.setString("groups", json.encode(exampleGroups));
  }
}
