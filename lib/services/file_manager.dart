import 'dart:convert';
import 'dart:io';

import 'package:budget_master/services/db.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class FileManager {
  late final String _directory;
  bool cancel = false;
  bool shouldSave = true;

  Future _save() async {
    await _write(
      "accounts",
      json.encode(Database.accounts.getAll().map((e) => e.toMap()).toList()),
    );
    await _write(
      "groups",
      json.encode(Database.groups.getAll().map((e) => e.toMap()).toList()),
    );
    await _write(
      "transactions",
      json.encode(
          Database.transactions.getAll().map((e) => e.toMap()).toList()),
    );
    await _write(
      "budgets",
      json.encode(Database.budgets.getAll().map((e) => e.toMap()).toList()),
    );
    await _write(
      "scheduled",
      json.encode(Database.scheduled.getAll().map((e) => e.toMap()).toList()),
    );
    await _write(
      "categories",
      json.encode(Database.categories.getAll().map((e) => e.toMap()).toList()),
    );
  }

  Future start() async {
    if (cancel) return;

    if (shouldSave) {
      debugPrint("Saving data...");
      _save();
      //shouldSave = false;
    }

    Future.delayed(const Duration(seconds: 30), start);
  }

  Future init() async {
    _directory = (await getApplicationDocumentsDirectory()).path;
  }

  File _getFile(String name) {
    return File("$_directory/$name.json");
  }

  Future<String?> read(String fileName) async {
    File f = _getFile(fileName);
    String? res;
    if (await f.exists()) res = await f.readAsString();
    return res;
  }

  Future<File> _write(String fileName, String text) async {
    File f = _getFile(fileName);
    if (!(await f.exists())) await f.create();

    return await f.writeAsString(text);
  }
}
