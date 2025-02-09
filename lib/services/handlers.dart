import 'package:budget_master/models/account.dart';
import 'package:budget_master/models/account_group.dart';
import 'package:budget_master/models/budget.dart';
import 'package:budget_master/models/model.dart';
import 'package:budget_master/models/scheduled_transaction.dart';
import 'package:budget_master/models/transaction.dart';
import 'package:budget_master/models/category.dart';
import 'package:budget_master/services/db.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

abstract class Handler<Element extends Model> {
  final Map<String, Element> _db;
  bool log; // For Debugging
  Handler(this._db, {this.log = false});

  @nonVirtual
  // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
  void _onChange() => Database.notifier.notifyListeners();

  Map<String, Element> get asMap => _db;

  @nonVirtual
  int getCount() => _db.length;

  @nonVirtual
  List<String> getIDs([bool Function(Element)? filter]) {
    if (filter == null) return _db.keys.toList();

    return _db.keys.where((s) => filter(get(s)!)).toList();
  }

  @nonVirtual
  List<Element> getAll([bool Function(Element)? filter]) =>
      filter == null ? _db.values.toList() : _db.values.where(filter).toList();

  @nonVirtual
  Element? get(String? id) {
    return _db[id];
  }

  bool post(Element element) {
    if (log) debugPrint("Posting $Element with id=${element.id}");
    if (_db.containsKey(element.id)) return false;

    _db[element.id] = element;
    _onChange();
    return true;
  }

  Element? edit(String? id, Element Function(Element) f,
      [bool recurse = true]) {
    if (id == null) return null;
    if (log) debugPrint("Editing $Element with id=$id");
    if (!_db.containsKey(id)) return null;
    Element newE = f(_db[id]!);

    assert(_db[id]!.id == newE.id, "Não pode alterar o id");

    _db[id] = newE;
    _onChange();
    return _db[id];
  }

  Element? delete(String id) {
    if (log) debugPrint("Deleting $Element with id=$id");
    Element? res = _db.remove(id);
    _onChange();
    return res;
  }
}

class TransactionsHandler extends Handler<Transaction> {
  TransactionsHandler(super.db);

  void _updateAccounts(Transaction t, [bool invert = false]) {
    int multiplier = invert ? -1 : 1;

    if (t.accountIn != null) {
      Database.accounts
          .edit(t.accountIn!, (a) => a.addBalance(multiplier * t.totalValue));
    }
    if (t.accountOut != null) {
      Database.accounts
          .edit(t.accountOut!, (a) => a.addBalance(-multiplier * t.totalValue));
    }
  }

  @override
  bool post(Transaction element) {
    if (!super.post(element)) return false;
    _updateAccounts(element);
    return true;
  }

  @override
  Transaction? edit(String? id, Transaction Function(Transaction p1) f,
      [bool recurse = true]) {
    Transaction? oldT = get(id);
    if (oldT == null) return null;
    Transaction newT = super.edit(id, f, recurse)!;
    _updateAccounts(oldT, true);
    _updateAccounts(newT);

    return newT;
  }

  @override
  Transaction? delete(String id) {
    Transaction? res = super.delete(id);
    if (res != null) _updateAccounts(res, true);
    return res;
  }
}

class AccountsHandler extends Handler<Account> {
  AccountsHandler(super.db);

  @override
  bool post(Account element) {
    if (!super.post(element)) return false;

    if (element.group.isNotEmpty) {
      Database.groups.edit(
          element.group, (g) => g.copyWith(addAccounts: [element.id]), false);
    }
    return true;
  }

  @override
  Account? edit(String? id, Account Function(Account p1) f,
      [bool recurse = true]) {
    Account? oldA = get(id);
    if (oldA == null || id == null) return null;
    Account newA = super.edit(id, f, recurse)!;

    if (recurse && oldA.group != newA.group) {
      if (oldA.group.isNotEmpty) {
        Database.groups
            .edit(oldA.group, (g) => g.copyWith(removeAccounts: [id]), false);
      }
      if (newA.group.isNotEmpty) {
        Database.groups
            .edit(newA.group, (g) => g.copyWith(addAccounts: [id]), false);
      }
    }
    return newA;
  }

  @override
  Account? delete(String id) {
    Account? res = super.delete(id);
    if (res?.group.isNotEmpty ?? false) {
      Database.groups.edit(res!.group, (g) => g.copyWith(removeAccounts: [id]));
    }
    return res;
  }
}

class AccountGroupsHandler extends Handler<AccountGroup> {
  AccountGroupsHandler(super.db);

  @override
  bool post(AccountGroup element) {
    if (!super.post(element)) return false;

    for (String acc in element.accounts) {
      Database.accounts.edit(acc, (a) => a.copyWith(group: element.id));
    }
    return true;
  }

  @override
  AccountGroup? edit(String? id, AccountGroup Function(AccountGroup p1) f,
      [bool recurse = true]) {
    AccountGroup? oldG = get(id);
    if (oldG == null) return null;
    AccountGroup newG = super.edit(id, f)!;

    if (recurse) {
      for (String acc in <String>{...oldG.accounts, ...newG.accounts}) {
        if (oldG.accounts.contains(acc) && !newG.accounts.contains(acc)) {
          Database.accounts.edit(acc, (a) => a.copyWith(group: null), false);
        } else if (newG.accounts.contains(acc) &&
            !oldG.accounts.contains(acc)) {
          Database.accounts.edit(acc, (a) => a.copyWith(group: newG.id), false);
        }
      }
    }
    return newG;
  }

  @override
  AccountGroup? delete(String id) {
    AccountGroup? ret = super.delete(id);
    if (ret == null) return null;

    for (String acc in ret.accounts) {
      Database.accounts.edit(acc, (a) => a.copyWith(group: null), false);
    }

    return ret;
  }
}

class BudgetsHandler extends Handler<Budget> {
  BudgetsHandler(super.db);
}

class ScheduledsHandler extends Handler<ScheduledTransaction> {
  ScheduledsHandler(super.db);
}

class CategoriesHandler extends Handler<TransactionCategory> {
  CategoriesHandler(super.db);

  @override
  bool post(TransactionCategory element) {
    assert(element.children.isEmpty);
    if (!super.post(element)) return false;

    edit(element.parent, (g) => g.copyWith(addChildren: [element.id]), false);

    return true;
  }

  @override
  TransactionCategory? edit(
      String? id, TransactionCategory Function(TransactionCategory p1) f,
      [bool recurse = true]) {
    TransactionCategory? oldTC = get(id);
    if (oldTC == null) return null;
    TransactionCategory newTC = super.edit(id, f, recurse)!;

    if (recurse && oldTC.children != newTC.children) {
      for (String tc in oldTC.children.whereNot(newTC.children.contains)) {
        edit(tc, (p1) => p1.copyWith(parent: ""), false);
      }
      for (String tc in newTC.children.whereNot(oldTC.children.contains)) {
        edit(tc, (p1) => p1.copyWith(parent: newTC.id), false);
      }
    }
    if (recurse && oldTC.parent != newTC.parent) {
      edit(
          oldTC.parent, (p1) => p1.copyWith(removeChildren: [oldTC.id]), false);
      edit(newTC.parent, (p1) => p1.copyWith(addChildren: [newTC.id]), false);
    }
    return newTC;
  }

  @override
  TransactionCategory? delete(String id) {
    TransactionCategory? res = super.delete(id);
    if (res == null) return null;

    edit(res.parent, (p1) => p1.copyWith(removeChildren: [res.id]), false);
    for (String tc in res.children) {
      edit(tc, (p1) => p1.copyWith(parent: ""), false);
    }

    return res;
  }

  bool validate(String name) {
    Map<String, Map?>? curr = map;
    try {
      name.split(" > ").forEach((e) {
        curr = curr![e] as Map<String, Map?>?;
      });
    } on NoSuchMethodError catch (_) {
      return false;
    }
    return curr?.isEmpty ?? false;
  }

  List<TransactionCategory> get bases =>
      _db.values.where((element) => element.parent.isEmpty).toList();

  Map<String, Map?> _getMap(TransactionCategory c) {
    return {for (String sub in c.children) sub: _getMap(_db[sub]!)};
  }

  Map<String, Map?> get map {
    return {for (TransactionCategory sub in bases) sub.name: _getMap(sub)};
  }
}
