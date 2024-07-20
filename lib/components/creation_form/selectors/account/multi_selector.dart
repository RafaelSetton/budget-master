import 'package:budget_master/components/creation_form/selectors/selector.dart';
import 'package:budget_master/components/drop_down_button.dart';
import 'package:budget_master/models/account.dart';
import 'package:budget_master/models/account_group.dart';
import 'package:budget_master/models/enums.dart';
import 'package:budget_master/models/model.dart';
import 'package:budget_master/services/db.dart';
import 'package:budget_master/utils/functions.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AccountMultiSelector extends CreationFormSelector<List<Account>> {
  AccountMultiSelector(
      {super.key, super.controller, super.defaultValue = const []});

  @override
  State<AccountMultiSelector> createState() => _AccountMultiSelectorState();
}

class _AccountMultiSelectorState extends State<AccountMultiSelector> {
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
          selected: widget.controller.value,
          onChange: (acc) => setState(() {
            widget.controller.value = acc;
          }),
        ),
        buttonHeight: height,
      ),
      displayText: "${widget.controller.value.length} selecionadas",
    );
  }
}

class _SelectorDialog extends StatefulWidget {
  const _SelectorDialog(
      {required this.offset, required this.onChange, required this.selected});

  final Offset offset;
  final void Function(List<Account>) onChange;
  final List<Account> selected;

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

  List<Account> get selected => _selected.keys
      .where((element) => _selected[element] == CheckState.checked)
      .map((k) => Database.accounts.get(k))
      .whereType<Account>()
      .toList();

  late Map<String, CheckState> _selected;
  late Map<String, bool> expanded;

  @override
  void initState() {
    _selected = {
      for (Model m in [
        ...Database.accounts.getAll(),
        ...Database.groups.getAll()
      ])
        m.id: CheckState.blank
    };
    expanded = {for (AccountGroup g in Database.groups.getAll()) g.id: false};
    for (Account element in widget.selected) {
      toggle(element, value: CheckState.checked);
      expanded[element.group] = true;
    }
    super.initState();
  }

  CheckState getStateFromChildren(String id) {
    List<String> children = Database.groups.get(id)!.accounts;
    if (children.every((ch) => _selected[ch] == CheckState.blank)) {
      return CheckState.blank;
    } else if (children.every((ch) => _selected[ch] == CheckState.checked)) {
      return CheckState.checked;
    }
    return CheckState.partial;
  }

  void toggle(Model m, {CheckState? value}) {
    final CheckState newValue = value ??
        (_selected[m.id] == CheckState.checked
            ? CheckState.blank
            : CheckState.checked);

    if (m.runtimeType == Account) {
      Account acc = m as Account;
      _selected[acc.id] = newValue;
      if (acc.group.isNotEmpty) {
        _selected[acc.group] = getStateFromChildren(acc.group);
      }
    } else if (m.runtimeType == AccountGroup) {
      AccountGroup g = m as AccountGroup;
      _selected[g.id] = newValue;
      for (String acc in g.accounts) {
        _selected[acc] = newValue;
      }
    }
  }

  Widget selectionBox(Model m) {
    Container child;
    switch (_selected[m.id]!) {
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

  Widget expandArrow(Model m) {
    if (m.runtimeType != AccountGroup) return Container(width: arrowWidth);
    return GestureDetector(
      onTap: () {
        setState(() {
          expanded[m.id] = !expanded[m.id]!;
        });
      },
      child: Icon(
        expanded[m.id]! ? Icons.arrow_drop_down : Icons.arrow_right,
        size: arrowWidth,
      ),
    );
  }

  Widget dropDownItem(Model m) {
    double pad = 0;
    if (m.runtimeType == Account) {
      m as Account;
      if (m.group.isNotEmpty) pad = 15;
    }
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
            expandArrow(m),
            GestureDetector(
              onTap: () {
                setState(() {
                  toggle(m);
                });
                widget.onChange(selected);
              },
              child: SizedBox(
                width: itemWidth - arrowWidth - pad - 5,
                child: Row(children: [
                  selectionBox(m),
                  Container(
                    width: 10,
                    color: Colors.white,
                  ), // Tem q ter cor pra clicar
                  Text(m.name),
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

  bool matches(Model m) {
    if (m.runtimeType == Account) {
      m as Account;
      if (m.name.toLowerCase().contains(searchText.toLowerCase())) return true;
      return Database.groups
              .get(m.group)
              ?.name
              .toLowerCase()
              .contains(searchText.toLowerCase()) ??
          false;
    } else {
      m as AccountGroup;
      if (m.name.toLowerCase().contains(searchText.toLowerCase())) return true;
      return m.accounts.every((acc) => Database.accounts
          .get(acc)!
          .name
          .toLowerCase()
          .contains(searchText.toLowerCase()));
    }
  }

  List<Model> orderedItems([AccountGroup? group]) {
    List<Model> res = [];
    if (group == null) {
      for (Account acc in Database.accounts.getAll()) {
        if (acc.group.isEmpty) {
          res.add(acc);
        }
      }
      for (AccountGroup g in Database.groups.getAll()) {
        res.addAll(orderedItems(g));
      }
    } else if (expanded[group.id]!) {
      // Matches search and is expanded
      for (Account acc in group.getAccounts) {
        if (matches(acc)) {
          res.add(acc);
        }
      }
      if (res.isNotEmpty) res.insert(0, group);
    } else if (matches(group)) {
      res.add(group);
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
                    children: orderedItems().map(dropDownItem).toList(),
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
