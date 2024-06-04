// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:budget_master/components/adjustableTable/header.dart';
import 'package:budget_master/models/transaction.dart';
import 'package:budget_master/utils/app_colors.dart';
import 'package:flutter/material.dart';

class AdjustableTable extends StatefulWidget {
  final List<String> columns;
  final List<Transaction> transactions;

  const AdjustableTable(
      {super.key, required this.columns, required this.transactions});

  @override
  State<AdjustableTable> createState() => _AdjustableTableState();
}

class _AdjustableTableState extends State<AdjustableTable> {
  late List<AdjustableHeaderCell> headers;
  double height = 50;

  @override
  initState() {
    headers = widget.columns
        .asMap()
        .entries
        .map((element) => AdjustableHeaderCell(
              index: element.key,
              onChange: () => setState(() {}),
              text: element.value,
            ))
        .toList();
    super.initState();
  }

  Widget get headerRow {
    return SizedBox(
      height: 30,
      child: ReorderableListView(
        buildDefaultDragHandles: false,
        scrollDirection: Axis.horizontal,
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (oldIndex < newIndex) newIndex -= 1;

            final AdjustableHeaderCell item = headers.removeAt(oldIndex);
            headers.insert(newIndex, item);
            headers.asMap().forEach((key, value) {
              value.index = key;
            });
          });
        },
        children: headers,
      ),
    );
  }

  Widget transactionRow(MapEntry e) {
    int index = e.key;
    Transaction transaction = e.value;
    Map<String, dynamic> attrs = transaction.display();

    return GestureDetector(
      onSecondaryTap: () {
        print("Edit Transaction");
        //TODO
      },
      child: Row(
        children: headers
            .map(
              (e) => Container(
                decoration: BoxDecoration(
                    color: AppColors.tableBodyBackground[index % 2],
                    border: Border.all()),
                height: 30,
                width: e.width,
                child: Text(
                  attrs[e.text],
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> rows =
        widget.transactions.asMap().entries.map(transactionRow).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        headerRow,
        Expanded(
          child: SingleChildScrollView(
            child: Column(children: rows),
          ),
        ),
      ],
    );
  }
}
