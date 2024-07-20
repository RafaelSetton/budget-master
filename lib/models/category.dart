import 'package:budget_master/models/model.dart';
import 'package:budget_master/services/db.dart';
import 'package:collection/collection.dart';

// TODO (Categories) Expense vs Income

class TransactionCategory extends Model {
  final String _id;
  final String parent;
  final List<String> children;
  late final String fullName;

  List<TransactionCategory> get getChildren =>
      children.map((e) => Database.categories.get(e)!).toList();

  @override
  String get id => _id;

  TransactionCategory({
    required super.name,
    String? parent,
    this.children = const [],
    String? fullName,
    String? id,
    super.edited,
  })  : _id = id ?? name,
        parent = parent ?? "" {
    this.fullName = fullName ??
        (this.parent.isEmpty
            ? name
            : "${Database.categories.get(parent)!.fullName} > $name");
  }

  TransactionCategory copyWith({
    String? id,
    String? name,
    String? parent,
    String? fullName,
    List<String>? children,
    List<String> addChildren = const [],
    List<String> removeChildren = const [],
    DateTime? edited,
  }) {
    children ??= (this.children + addChildren)
        .whereNot(removeChildren.contains)
        .toList();
    return TransactionCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      parent: parent ?? this.parent,
      fullName: fullName,
      children: children,
      edited: edited,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "parent": parent,
      "fullName": fullName,
      "children": children,
      "edited": edited.millisecondsSinceEpoch,
    };
  }

  factory TransactionCategory.fromMap(Map<String, dynamic> map) {
    return TransactionCategory(
      id: map['id'],
      name: map['name'],
      parent: map['parent'],
      fullName: map['fullName'],
      children: List<String>.from(map['children']),
      edited: DateTime.fromMillisecondsSinceEpoch(
          map['edited'] ?? 1641031200000 + 1000000 * 36 * 24 * 73),
    );
  }

  @override
  String toString() {
    return "Category($fullName, id: $id, name: $name, parent: $parent, children: ${children.length}, edited: $edited)";
  }
}
