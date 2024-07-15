import 'package:budget_master/components/creation_form/selectors/selector.dart';
import 'package:budget_master/components/drop_down_button.dart';
import 'package:budget_master/models/category.dart';
import 'package:budget_master/models/enums.dart';
import 'package:budget_master/services/db.dart';
import 'package:budget_master/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:pair/pair.dart';

// ignore: must_be_immutable
class CategoryMultiSelector
    extends CreationFormSelector<List<TransactionCategory>> {
  CategoryMultiSelector({super.key, List<TransactionCategory>? selected})
      : _selected = selected ?? const [];

  @override
  State<CategoryMultiSelector> createState() => _CategoryMultiSelectorState();

  List<TransactionCategory> _selected;

  @override
  List<TransactionCategory> get value => _selected;
}

class _CategoryMultiSelectorState extends State<CategoryMultiSelector> {
  static const double width = 150;
  static const double height = 35;

  @override
  Widget build(BuildContext context) {
    return DropDownButton(
      width: width,
      height: height,
      onDrop: (ctx) => showPositionedDialog(
        context: ctx,
        builder: (_, offset) => _SelectorDialog(
          offset: offset,
          selected: widget._selected,
          onChange: (acc) => setState(() {
            widget._selected = acc;
          }),
        ),
        buttonHeight: height,
      ),
      displayText: "${widget._selected.length} selecionadas",
    );
  }
}

class _SelectorDialog extends StatefulWidget {
  const _SelectorDialog(
      {required this.offset, required this.onChange, required this.selected});

  final Offset offset;
  final void Function(List<TransactionCategory>) onChange;
  final List<TransactionCategory> selected;

  @override
  State<_SelectorDialog> createState() => __SelectorDialogState();
}

class __SelectorDialogState extends State<_SelectorDialog> {
  static const double itemWidth = 300;
  static const double itemHeight = 30;
  static const double arrowWidth = 20;
  static const double boxSize = 15;

  static final Container partialBox =
      Container(alignment: Alignment.center, color: Colors.blue.shade800);
  static final Container checkedBox = Container(
    alignment: Alignment.center,
    color: Colors.blue.shade800,
    child: const Icon(
      Icons.check,
      size: boxSize * 0.75,
      color: Colors.white,
    ),
  );

  bool allSelected = false;
  String searchText = "";

  List<TransactionCategory> get selected => _selected.keys
      .where((element) =>
          _selected[element] == CheckState.checked &&
          Database.categories.get(element)!.children.isEmpty)
      .map((k) => Database.categories.get(k)!)
      .toList();

  late Map<String, CheckState> _selected;
  late Map<String, bool> expanded;

  @override
  void initState() {
    _selected = {
      for (TransactionCategory tc in Database.categories.getAll())
        tc.id: CheckState.blank
    };
    expanded = {
      for (TransactionCategory tc in Database.categories.getAll()) tc.id: false
    };
    for (TransactionCategory element in widget.selected) {
      toggle(element, value: CheckState.checked);
      String parent = element.parent;
      if (!(expanded[parent] ?? true)) {
        do {
          expanded[parent] = true;
          parent = Database.categories.get(parent)!.parent;
        } while (parent.isNotEmpty);
      }
    }
    super.initState();
  }

  CheckState getStateFromChildren(String id) {
    List<String> children = Database.categories.get(id)!.children;
    if (children.every((ch) => _selected[ch] == CheckState.blank)) {
      return CheckState.blank;
    } else if (children.every((ch) => _selected[ch] == CheckState.checked)) {
      return CheckState.checked;
    }
    return CheckState.partial;
  }

  void toggle(TransactionCategory tc,
      {CheckState? value, bool updateParent = true}) {
    final CheckState newValue = value ??
        (_selected[tc.id] == CheckState.checked
            ? CheckState.blank
            : CheckState.checked);
    _selected[tc.id] = newValue;

    String curr = tc.parent;
    while (curr.isNotEmpty && updateParent) {
      _selected[curr] = getStateFromChildren(curr);
      curr = Database.categories.get(curr)!.parent;
    }

    for (String child in tc.children) {
      toggle(Database.categories.get(child)!,
          value: newValue, updateParent: false);
    }
  }

  Widget selectionBox(TransactionCategory tc) {
    Container child;
    switch (_selected[tc.id]!) {
      case CheckState.blank:
        child = Container();
      case CheckState.partial:
        child = partialBox;
      case CheckState.checked:
        child = checkedBox;
    }

    return Container(
      height: boxSize,
      width: boxSize,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueAccent),
      ),
      child: FractionallySizedBox(
        heightFactor: 0.85,
        widthFactor: 0.85,
        child: child,
      ),
    );
  }

  Widget expandArrow(TransactionCategory tc) {
    if (tc.children.isEmpty) return Container(width: arrowWidth);
    return GestureDetector(
      onTap: () {
        setState(() {
          expanded[tc.id] = !expanded[tc.id]!;
        });
      },
      child: Icon(
        expanded[tc.id]! ? Icons.arrow_drop_down : Icons.arrow_right,
        size: arrowWidth,
      ),
    );
  }

  Widget dropDownItem(TransactionCategory tc, int depth) {
    final double pad = 15.0 * depth;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        width: itemWidth,
        height: itemHeight,
        padding: EdgeInsets.only(left: pad, right: 5, top: 5, bottom: 5),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border.symmetric(horizontal: BorderSide(width: 0.3)),
        ),
        child: Row(
          children: [
            expandArrow(tc),
            GestureDetector(
              onTap: () {
                setState(() {
                  toggle(tc);
                });
                widget.onChange(selected);
              },
              child: SizedBox(
                width: itemWidth - arrowWidth - pad - 5,
                child: Row(children: [
                  selectionBox(tc),
                  Container(
                    width: 10,
                    color: Colors.white,
                  ), // Tem q ter cor pra clicar
                  Text(tc.name),
                  Expanded(
                    child: Container(
                        color: Colors.white), // Tem q ter cor pra clicar
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool matches(TransactionCategory tc) {
    if (tc.fullName.toLowerCase().contains(searchText.toLowerCase())) {
      return true;
    }
    return tc.children
        .any((element) => matches(Database.categories.get(element)!));
  }

  List<Pair<TransactionCategory, int>> orderedCategories(
      [TransactionCategory? base, int depth = -1]) {
    List<Pair<TransactionCategory, int>> res = [];
    if (base == null) {
      for (TransactionCategory tc in Database.categories.bases) {
        res.addAll(orderedCategories(tc, depth + 1));
      }
    } else if (matches(base) &&
        (base.parent.isEmpty || expanded[base.parent]!)) {
      // Matches search and is expanded
      res.add(Pair(base, depth));
      for (String tc in base.children) {
        res.addAll(orderedCategories(Database.categories.get(tc), depth + 1));
      }
    }

    return res;
  }

  Widget searchWidget() {
    return Container(
      width: itemWidth,
      height: itemHeight * 1.5,
      color: Colors.white,
      padding: const EdgeInsets.all(5),
      child: SearchBar(
        onChanged: (s) {
          setState(() {
            searchText = s;
          });
        },
        leading: const Icon(Icons.search),
        trailing: [
          Tooltip(
            message: allSelected ? "Desmarcar tudo" : "Marcar tudo",
            child: IconButton(
              isSelected: allSelected,
              onPressed: () {
                setState(() {
                  allSelected = !allSelected;
                  for (String k in _selected.keys) {
                    _selected[k] =
                        allSelected ? CheckState.checked : CheckState.blank;
                  }
                });
                widget.onChange(selected);
              },
              iconSize: boxSize,
              icon: const Icon(Icons.check_box_outline_blank),
              selectedIcon: const Icon(Icons.check_box_outlined),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: widget.offset.dx,
          top: widget.offset.dy,
          child: Column(
            children: [
              searchWidget(),
              SizedBox(
                width: itemWidth,
                height: itemHeight * 10,
                child: SingleChildScrollView(
                  child: Column(
                    children: orderedCategories()
                        .where((p) =>
                            p.key.parent.isEmpty || expanded[p.key.parent]!)
                        .map((p) => dropDownItem(p.key, p.value))
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
