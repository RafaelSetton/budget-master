import 'package:budget_master/components/creation_form/selectors/selector.dart';
import 'package:budget_master/components/drop_down_button.dart';
import 'package:budget_master/models/category.dart';
import 'package:budget_master/services/db.dart';
import 'package:budget_master/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:pair/pair.dart';

// ignore: must_be_immutable
class CategorySingleSelector
    extends CreationFormSelector<TransactionCategory?> {
  CategorySingleSelector(
      {super.key,
      TransactionCategory? selected,
      this.allowRoots = false,
      this.optional = true})
      : _selected = selected ??
            Database.categories
                .getAll()
                .firstOrNull; //((element) => element.children.isEmpty);

  @override
  State<CategorySingleSelector> createState() => _CategorySingleSelectorState();

  TransactionCategory? _selected;
  final bool allowRoots;
  final bool optional;

  @override
  TransactionCategory? get value => _selected;
}

class _CategorySingleSelectorState extends State<CategorySingleSelector> {
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
          allowRoots: widget.allowRoots,
          optional: widget.optional,
        ),
        buttonHeight: height,
      ),
      displayText: widget._selected?.fullName ?? "Nenhuma",
    );
  }
}

class _SelectorDialog extends StatefulWidget {
  const _SelectorDialog(
      {required this.offset,
      required this.onChange,
      this.selected,
      required this.allowRoots,
      required this.optional});

  final Offset offset;
  final void Function(TransactionCategory?) onChange;
  final TransactionCategory? selected;
  final bool allowRoots;
  final bool optional;

  @override
  State<_SelectorDialog> createState() => __SelectorDialogState();
}

class __SelectorDialogState extends State<_SelectorDialog> {
  static const double itemWidth = 300;
  static const double itemHeight = 30;
  static const double arrowWidth = 20;

  String searchText = "";

  late TransactionCategory _selected;
  late Map<String, bool> expanded;

  static final TransactionCategory nullSimulator =
      TransactionCategory(name: "Nenhuma");

  @override
  void initState() {
    _selected = widget.selected ?? nullSimulator;
    expanded = {
      for (TransactionCategory tc in Database.categories.getAll()) tc.id: false
    };

    String parent = _selected.parent;
    if (!(expanded[parent] ?? true)) {
      do {
        expanded[parent] = true;
        parent = Database.categories.get(parent)!.parent;
      } while (parent.isNotEmpty);
    }

    super.initState();
  }

  void select(TransactionCategory tc) {
    setState(() {
      _selected = tc;
    });
  }

  Widget expandArrow(TransactionCategory tc) {
    if (tc.children.isEmpty) return Container(width: arrowWidth);
    return Icon(
      expanded[tc.id]! ? Icons.arrow_drop_down : Icons.arrow_right,
      size: arrowWidth,
    );
  }

  Widget dropDownItem(TransactionCategory tc, int depth) {
    final double pad = 15.0 * depth;
    final Color color = _selected == tc ? Colors.lightBlue : Colors.white;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          if (tc.children.isEmpty || widget.allowRoots) {
            select(tc);
            if (_selected == nullSimulator) {
              widget.onChange(null);
            } else {
              widget.onChange(_selected);
            }
          }
          setState(() {
            expanded[tc.id] = !(expanded[tc.id] ?? false);
          });
        },
        child: Container(
          width: itemWidth,
          height: itemHeight,
          padding: EdgeInsets.only(left: pad, right: 5, top: 5, bottom: 5),
          decoration: BoxDecoration(
            color: color,
            border: const Border.symmetric(horizontal: BorderSide(width: 0.3)),
          ),
          child: Row(
            children: [
              expandArrow(tc),
              Text(tc.name),
              Expanded(
                child: Container(color: color), // Tem q ter cor pra clicar
              ),
            ],
          ),
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
      res.add(Pair(nullSimulator, 0));
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
