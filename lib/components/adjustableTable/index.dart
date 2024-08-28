import 'package:budget_master/components/adjustableTable/header.dart';
import 'package:budget_master/models/enums.dart';
import 'package:budget_master/models/transaction.dart';
import 'package:budget_master/pages/edit/transaction.dart';
import 'package:budget_master/utils/app_colors.dart';
import 'package:budget_master/utils/app_sizes.dart';
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

  double get width => 1100;
  double get height => 200;

  Widget transactionRow(MapEntry e) {
    int index = e.key;
    Transaction transaction = e.value;
    Map<String, dynamic> attrs = transaction.display();
    Color valueColor;
    if (transaction.type == TransactionType.expense ||
        transaction.type == TransactionType.buy) {
      valueColor = Colors.red;
    } else if (transaction.type == TransactionType.income ||
        transaction.type == TransactionType.sell) {
      valueColor = Colors.green;
    } else {
      valueColor = Colors.black;
    }

    return GestureDetector(
      onSecondaryTap: () {
        showDialog(
          context: context,
          builder: (ctx) => TransactionEditDialog(transaction.id, context: ctx),
        );
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
                  style: TextStyle(
                    color: e.text == "Valor" ? valueColor : null,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  ScrollController horizontalScroller = ScrollController();

  @override
  Widget build(BuildContext context) {
    List<Widget> rows =
        widget.transactions.asMap().entries.map(transactionRow).toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: horizontalScroller,
      child: SizedBox(
        height: AppSizes.window.height,
        width: AppSizes.window.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            headerRow,
            Expanded(
              child: SingleChildScrollView(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: horizontalScroller,
                  child: Column(children: rows),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
