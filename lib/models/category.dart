import 'package:localstorage/localstorage.dart';

class Category {
  final String name;
  final Category? parent;
  final List<Category> children;

  String get fullName => parent != null ? "${parent?.fullName} > $name" : name;

  Category({required this.name, this.parent, this.children = const []}) {
    if (parent == null) _bases.add(this);
  }

  static final List<Category> _bases =
      LocalStorage("categories.json").getItem("all") ?? [];

  static Map<String, Map?> _getMap(Category c) {
    return {for (Category sub in c.children) sub.name: _getMap(sub)};
  }

  static Map<String, Map?> get all {
    return {for (Category sub in _bases) sub.name: _getMap(sub)};
  }

  static bool validate(String name) {
    Map<String, Map?>? curr = all;
    try {
      name.split(" > ").forEach((e) {
        curr = curr![e] as Map<String, Map?>?;
      });
    } on NoSuchMethodError catch (_) {
      return false;
    }
    return curr?.isEmpty ?? false;
  }
}
