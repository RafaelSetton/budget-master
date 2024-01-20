import 'package:localstorage/localstorage.dart';

class Category {
  static Map<String, Map?>? _all;

  static Map<String, Map?> get all {
    _all ??= LocalStorage("categories.json").getItem("all") ?? {};
    return _all!;
  }

  static validate(String name) {
    Map<String, Map?>? curr = all;
    try {
      name.split(" > ").forEach((e) {
        curr = curr![e] as Map<String, Map?>?;
      });
    } on NoSuchMethodError catch (_) {
      return false;
    }
    return curr == null;
  }
}
